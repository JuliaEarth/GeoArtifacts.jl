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

function download(scale, entity, variant)
  table = CSV.File(joinpath(@__DIR__, "..", "artifacts", "NaturalEarth.csv"))

  srows = table |> Filter(row -> row.SCALE == "1:$(scale)m" && contains(row.ENTITY, entity) && contains(row.VARIANT, variant))
  srow = Tables.rows(srows) |> first

  ID = "NaturalEarth_$(srow.SCALE)_$(srow.ENTITY)_$(srow.VARIANT)"

  try
    # if data is already on disk
    # we just return the path
    @datadep_str ID
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(ID,
        """
        Geographic data provided by the https://www.naturalearthdata.com project.
        Scale: $(srow.SCALE)
        Entity: $(srow.ENTITY)
        Variant: $(srow.VARIANT)
        """,
        srow.URL,
        Any,
        post_fetch_method=DataDeps.unpack
      ))
      @datadep_str ID
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end
end

function get(scale, entity, variant; kwargs...)
  path = download(scale, entity, variant)

  # find Shapefile/GeoTIFF file
  files = readdir(path; join=true)
  isgeo(f) = last(splitext(f)) ∈ (".shp", ".tif", ".tiff")
  file = files[findfirst(isgeo, files)]

  GeoIO.load(file; kwargs...)
end

end
