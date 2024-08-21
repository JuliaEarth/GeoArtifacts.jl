# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides a single function `NaturalEarth.get` to download data from the
NaturalEarth database. Please check its docstring for more details.
"""
module NaturalEarth

using GeoIO
using DataDeps
using TableTransforms
using Tables
using CSV

function download(scale, entity, variant)
  if scale ∉ (10, 50, 100)
    throw(ArgumentError("invalid scale, please use one these: 10, 50, 100"))
  end

  table = CSV.File(joinpath(@__DIR__, "..", "artifacts", "NaturalEarth.csv"))

  srows = table |> Filter(row -> row.SCALE == "1:$(scale)m" && contains(row.ENTITY, entity) && contains(row.VARIANT, variant))
  srow = Tables.rows(srows) |> first

  url = srow.URL
  fname = split(url, "/") |> last |> splitext |> first
  ID = "NaturalEarth_$fname"

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
        url,
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

# -------------
# USER HELPERS
# -------------

countries(; scale=10, kwargs...) = get(scale, "Admin 0 – Countries", "countries"; kwargs...)

function borders(; scale=10, kwargs...)
  variant = if scale == 10
    "land boundaries"
  elseif scale == 50
    "land lines"
  else
    "country boundaries"
  end
  get(scale, "Admin 0 – Boundary Lines", variant; kwargs...)
end

states(; scale=10, kwargs...) = get(scale, "Admin 1 – States, Provinces", "states and provinces"; kwargs...)

counties(; scale=10, kwargs...) = get(scale, "Admin 2 – Counties", "counties"; kwargs...)

populatedplaces(; scale=10, kwargs...) = get(scale, "Populated Places", "populated places"; kwargs...)

roads(; scale=10, kwargs...) = get(scale, "Roads", "roads"; kwargs...)

railroads(; scale=10, kwargs...) = get(scale, "Railroads", "railroads"; kwargs...)

airports(; scale=10, kwargs...) = get(scale, "Airports", "airports"; kwargs...)

ports(; scale=10, kwargs...) = get(scale, "Ports", "ports"; kwargs...)

urbanareas(; scale=10, kwargs...) = get(scale, "Urban Areas", "urban areas"; kwargs...)

usparks(; scale=10, kwargs...) = get(scale, "Parks and Protected Lands", "U.S. national parks"; kwargs...)

timezones(; scale=10, kwargs...) = get(scale, "Timezones", "time zones"; kwargs...)

end
