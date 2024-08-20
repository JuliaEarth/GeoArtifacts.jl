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

const TABLE = CSV.File(joinpath(@__DIR__, "..", "artifacts", "NaturalEarth.csv")) 

function download(scale, map, variation)
  scalestr = "1:$(scale)m"
  mapquery = contains(map)
  varquery = contains(variation)

  srows = TABLE |> Filter(row -> row.Scale == scalestr && mapquery(row.Map) && varquery(row.Variation))
  srow = Tables.rows(srows) |> first

  link = srow.Download
  fname = split(link, "/") |> last |> splitext |> first

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
        Scale: $(srow.Scale)
        Map: $(srow.Map)
        Variation: $(srow.Variation)
        """,
        link,
        Any,
        post_fetch_method=DataDeps.unpack
      ))
      @datadep_str fname
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end
end

function get(scale, map, variation; kwargs...)
  path = download(scale, map, variation)

  # find Shapefile/GeoTIFF file
  files = readdir(path; join=true)
  isgeo(f) = last(splitext(f)) ∈ (".shp", ".tif", ".tiff")
  file = files[findfirst(isgeo, files)]

  GeoIO.load(file; kwargs...)
end

end
