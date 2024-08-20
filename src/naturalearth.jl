# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides a single function `NaturalEarth.get` to download data from the
NaturalEarth database.  Please check its docstring for more details.
"""
module NaturalEarth

using GeoIO
using DataDeps
using TableTransforms
using Tables
using CSV

function download(scale, entity, variat)
  netable = CSV.File(joinpath(@__DIR__, "..", "artifacts", "NaturalEarth.csv"))

  scalestr = "1:$(scale)m"
  srows = netable |> Filter(row -> row.SCALE == scalestr && contains(row.ENTITY, entity) && contains(row.VARIANT, variat))
  srow = Tables.rows(srows) |> first

  url = srow.URL
  fname = split(url, "/") |> last |> splitext |> first

  try
    # if data is already on disk
    # we just return the path
    @datadep_str fname
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(fname,
        """
        Geographic data provided by the https://www.naturalearthdata.com project.
        Scale: $(srow.SCALE)
        Entity: $(srow.ENTITY)
        Variat: $(srow.VARIANT)
        """,
        url,
        Any,
        post_fetch_method=DataDeps.unpack
      ))
      @datadep_str fname
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end
end

function get(scale, entity, variat; kwargs...)
  path = download(scale, entity, variat)

  # find Shapefile/GeoTIFF file
  files = readdir(path; join=true)
  isgeo(f) = last(splitext(f)) ∈ (".shp", ".tif", ".tiff")
  file = files[findfirst(isgeo, files)]

  GeoIO.load(file; kwargs...)
end

end
