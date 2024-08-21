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
  if scale ∉ ("1:10", "1:50", "1:100")
    throw(ArgumentError("invalid scale, please use one these: 1:10, 1:50, 1:100"))
  end

  table = CSV.File(joinpath(@__DIR__, "..", "artifacts", "NaturalEarth.csv"))

  srows = table |> Filter(row -> row.SCALE == "$(scale)m" && contains(row.ENTITY, entity) && contains(row.VARIANT, variant))
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

function countries(variant="default"; scale="1:10", kwargs...)
  ispov = false
  variantstr = if variant == "default"
    "countries"
  elseif variant == "nolakes"
    "without boundary lakes"
  else
    ispov = true
    if variant == "isopov"
      "countries (ISO POV)"
    elseif variant == "toplevel"
      "countries (top-level-countries POV)"
    elseif variant == "ARG"
      "countries (Argentina POV)"
    elseif variant == "BDG"
      "countries (Bangladesh POV)"
    elseif variant == "BRA"
      "countries (Brazil POV)"
    elseif variant == "CHN"
      "countries (China POV)"
    elseif variant == "EGY"
      "countries (Egypt POV)"
    elseif variant == "FRA"
      "countries (France POV)"
    elseif variant == "DEU"
      "countries (Germany POV)"
    elseif variant == "GRC"
      "countries (Greece POV)"
    elseif variant == "IDN"
      "countries (Indonesia POV)"
    elseif variant == "IND"
      "countries (India POV)"
    elseif variant == "ISO"
      "countries (ISO POV)"
    elseif variant == "ISR"
      "countries (Israel POV)"
    elseif variant == "ITA"
      "countries (Italy POV)"
    elseif variant == "JPN"
      "countries (Japan POV)"
    elseif variant == "KOR"
      "countries (South Korea POV)"
    elseif variant == "MAR"
      "countries (Morocco POV)"
    elseif variant == "NEP"
      "countries (Nepal POV)"
    elseif variant == "NLD"
      "countries (Netherlands POV)"
    elseif variant == "PAK"
      "countries (Pakistan POV)"
    elseif variant == "POL"
      "countries (Poland POV)"
    elseif variant == "PRT"
      "countries (Portugal POV)"
    elseif variant == "PSE"
      "countries (Palestine POV)"
    elseif variant == "RUS"
      "countries (Russia POV)"
    elseif variant == "SAU"
      "countries (Saudi Arabia POV)"
    elseif variant == "ESP"
      "countries (Spain POV)"
    elseif variant == "SWE"
      "countries (Sweden POV)"
    elseif variant == "TUR"
      "countries (Turkey POV)"
    elseif variant == "TWN"
      "countries (Taiwan POV)"
    elseif variant == "GBR"
      "countries (United Kingdom POV)"
    elseif variant == "USA"
      "countries (United States POV)"
    elseif variant == "UKR"
      "countries (Ukraine POV)"
    elseif variant == "VNM"
      "countries (Vietnam POV)"
    else
      varianterror()
    end
  end
  entity = ispov ? "Admin 0 – Countries point-of-views" : "Admin 0 – Countries"
  get(scale, entity, variantstr; kwargs...)
end

function borders(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    if scale == "1:10"
      "land boundaries"
    elseif scale == "1:50"
      "land lines"
    else
      "country boundaries"
    end
  elseif variant == "mapunit"
    "map unit lines"
  elseif variant == "maritme"
    "maritime indicators"
  elseif variant == "maritimechn"
    "maritime indicators China supplement"
  elseif variant == "pacific"
    "Pacific grouping lines"
  else
    varianterror()
  end
  get(scale, "Admin 0 – Boundary Lines", variantstr; kwargs...)
end

function states(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "states and provinces"
  elseif variant == "ranks"
    if scale == "1:10"
      "as scale ranks"
    else
      "scale ranks"
    end
  elseif variant == "nolakes"
    "without large lakes"
  elseif variant == "borders"
    if scale == "1:100"
      "boundaries"
    else
      "boundary lines"
    end
  else
    varianterror()
  end
  get(scale, "Admin 1 – States, Provinces", variantstr; kwargs...)
end

function counties(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "counties"
  elseif variant == "nolakes"
    "without large lakes"
  elseif variant == "ranks"
    "as scale ranks"
  elseif variant == "ranksislands"
    "scale ranks with minor islands"
  else
    varianterror()
  end
  get(scale, "Admin 2 – Counties", variantstr; kwargs...)
end

function populatedplaces(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "populated places"
  elseif variant == "simple"
    "simple (less columns)"
  else
    varianterror()
  end
  get(scale, "Populated Places", variantstr; kwargs...)
end

function roads(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "roads"
  elseif variant == "northamerica"
    "North America supplement"
  else
    varianterror()
  end
  get(scale, "Roads", variantstr; kwargs...)
end

function railroads(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "railroads"
  elseif variant == "northamerica"
    "North America supplement"
  else
    varianterror()
  end
  get(scale, "Railroads", variantstr; kwargs...)
end

airports(; scale="1:10", kwargs...) = get(scale, "Airports", "airports"; kwargs...)

ports(; scale="1:10", kwargs...) = get(scale, "Ports", "ports"; kwargs...)

urbanareas(; scale="1:10", kwargs...) = get(scale, "Urban Areas", "urban areas"; kwargs...)

usparks(; scale="1:10", kwargs...) = get(scale, "Parks and Protected Lands", "U.S. national parks"; kwargs...)

timezones(; scale="1:10", kwargs...) = get(scale, "Timezones", "time zones"; kwargs...)

# -----------------
# HELPER FUNCTIONS
# -----------------

varianterror() = throw(ArgumentError("invalid variant, please check the docstring"))

end
