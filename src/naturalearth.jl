# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides utility functions to download data from the NaturalEarth database.
Please check the docstrings for more details.
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

# -----------
# PUBLIC API
# -----------

countries(; scale=10, kwargs...) = get(scale, "Admin 0 – Countries", "countries"; kwargs...)

function borders(; scale=10, variant=:border, kwargs...)
  variantstr = if variant == :border
    if scale == 10
      "land boundaries"
    elseif scale == 50
      "land lines"
    else
      "country boundaries"
    end
  elseif variant == :mapunit
    "map unit lines"
  elseif variant == :maritme
    "maritime indicators"
  elseif variant == :maritimechn
    "maritime indicators China supplement"
  elseif variant == :pacific
    "Pacific grouping lines"
  else
    varianterror()
  end
  get(scale, "Admin 0 – Boundary Lines", variantstr; kwargs...)
end

function states(; scale=10, variant=:states, kwargs...)
  variantstr = if variant == :states
    "states and provinces"
  elseif variant == :ranks
    if scale == 10
      "as scale ranks"
    else
      "scale ranks"
    end
  elseif variant == :nolakes
    "without large lakes"
  elseif variant == :borders
    if scale == 100
      "boundaries"
    else
      "boundary lines"
    end
  else
    varianterror()
  end
  get(scale, "Admin 1 – States, Provinces", variantstr; kwargs...)
end

function counties(; scale=10, variant=:counties, kwargs...)
  variantstr = if variant == :counties
    "counties"
  elseif variant == :nolakes
    "without large lakes"
  elseif variant == :ranks
    "as scale ranks"
  elseif variant == :ranksislands
    "scale ranks with minor islands"
  else
    varianterror()
  end
  get(scale, "Admin 2 – Counties", variantstr; kwargs...)
end

function populatedplaces(; scale=10, variant=:populatedplaces, kwargs...)
  variantstr = if variant == :populatedplaces
    "populated places"
  elseif variant == :simple
    "simple (less columns)"
  else
    varianterror()
  end
  get(scale, "Populated Places", variantstr; kwargs...)
end

function roads(; scale=10, variant=:roads, kwargs...)
  variantstr = if variant == :roads
    "roads"
  elseif variant == :northamerica
    "North America supplement"
  else
    varianterror()
  end
  get(scale, "Roads", variantstr; kwargs...)
end

function railroads(; scale=10, variant=:railroads, kwargs...)
  variantstr = if variant == :railroads
    "railroads"
  elseif variant == :northamerica
    "North America supplement"
  else
    varianterror()
  end
  get(scale, "Railroads", variantstr; kwargs...)
end

airports(; scale=10, kwargs...) = get(scale, "Airports", "airports"; kwargs...)

ports(; scale=10, kwargs...) = get(scale, "Ports", "ports"; kwargs...)

urbanareas(; scale=10, kwargs...) = get(scale, "Urban Areas", "urban areas"; kwargs...)

usparks(; scale=10, kwargs...) = get(scale, "Parks and Protected Lands", "U.S. national parks"; kwargs...)

timezones(; scale=10, kwargs...) = get(scale, "Timezones", "time zones"; kwargs...)

# -----------------
# HELPER FUNCTIONS
# -----------------

varianterror() = throw(ArgumentError("invalid variant, please check the docstring"))

end
