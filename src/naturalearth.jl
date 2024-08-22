# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to download data from the Natural Earth database:

* [`NaturalEarth.countries`](@ref)
* [`NaturalEarth.borders`](@ref)
* [`NaturalEarth.states`](@ref)
* [`NaturalEarth.counties`](@ref)
* [`NaturalEarth.populatedplaces`](@ref)
* [`NaturalEarth.roads`](@ref)
* [`NaturalEarth.railroads`](@ref)
* [`NaturalEarth.airports`](@ref)
* [`NaturalEarth.ports`](@ref)
* [`NaturalEarth.urbanareas`](@ref)
* [`NaturalEarth.usparks`](@ref)
* [`NaturalEarth.timezones`](@ref)

Please check their docstrings for more details.
"""
module NaturalEarth

using GeoIO
using DataDeps
using TableTransforms
using Tables
using CSV

"""
    NaturalEarth.download(scale, entity, variant)

Download geometric data from Natural Earth database.

`entity` and `variant` can be queried with a substring
of the full name. If more than one result is returned in the query,
only the first result will be selected.

Check the Natural Earth website to see all available entities and variants
for each scale: https://www.naturalearthdata.com/

## Arguments

* `scale`: Specifies the the map scale, can be `"1:10"`, `"1:50"` or `"1:100"`;
* `entity`: Specifies the name of the map to load;
* `variant`: Specifies the type of geographic data to load;
"""
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

"""
    NaturalEarth.get(scale, entity, variant; kwargs...)

Load geometric data from Natural Earth database.

`entity` and `variant` must be queried with a substring
of the full name. If more than one results are returned in query,
only the first result are selected.

Check the Natural Earth website to see all available entities and variants
for each scale: https://www.naturalearthdata.com/

## Arguments

* `scale`: Specifies the the map scale, can be `"1:10"`, `"1:50"` or `"1:100"`;
* `entity`: Specifies the name of the map to load;
* `variant`: Specifies the type of geographic data to load;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;
"""
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

"""
    NaturalEarth.countries(variant="default"; scale="1:10", kwargs...)

Load all countries of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default countries map;
* `"nolakes"`: Countries without boundary lakes;
* `"iso"`: ISO point-of-view;
* `"toplevel"`: Top level countries point-of-view;
* ISO 3166 Alpha 3 string: Point-of-view of the following countries:
  * `"ARG"`: Argentina
  * `"BDG"`: Bangladesh
  * `"BRA"`: Brazil
  * `"CHN"`: China
  * `"EGY"`: Egypt
  * `"FRA"`: France
  * `"DEU"`: Germany
  * `"GRC"`: Greece
  * `"IDN"`: Indonesia
  * `"IND"`: India
  * `"ISR"`: Israel
  * `"ITA"`: Italy
  * `"JPN"`: Japan
  * `"KOR"`: South Korea
  * `"MAR"`: Morocco
  * `"NEP"`: Nepal
  * `"NLD"`: Netherlands
  * `"PAK"`: Pakistan
  * `"POL"`: Poland
  * `"PRT"`: Portugal
  * `"PSE"`: Palestine
  * `"RUS"`: Russia
  * `"SAU"`: Saudi Arabia
  * `"ESP"`: Spain
  * `"SWE"`: Sweden
  * `"TUR"`: Turkey
  * `"TWN"`: Taiwan
  * `"GBR"`: United Kingdom
  * `"USA"`: United States
  * `"UKR"`: Ukraine
  * `"VNM"`: Vietnam

## Examples

```julia
NaturalEarth.countries()
NaturalEarth.countries(scale="1:100")
NaturalEarth.countries("BRA")
NaturalEarth.countries("USA")
```
"""
function countries(variant="default"; scale="1:10", kwargs...)
  ispov = false
  variantstr = if variant == "default"
    "countries"
  elseif variant == "nolakes"
    "without boundary lakes"
  else
    ispov = true
    if variant == "iso"
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

"""
    NaturalEarth.borders(variant="default"; scale="1:10", kwargs...)

Load all country borders of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default borders map;
* `"mapunit"`: Borders with map units;
* `"maritme"`: Borders of maritime indicators;
* `"maritimechn"`: Borders of maritime indicators with China supplement;
* `"maritme"`: Borders of Pacific grouping lines;

## Examples

```julia
NaturalEarth.borders()
NaturalEarth.borders(scale="1:100")
NaturalEarth.borders("maritme")
NaturalEarth.borders("pacific")
```
"""
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

"""
    NaturalEarth.states(variant="default"; scale="1:10", kwargs...)

Load all states of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default states map;
* `"ranks"`: States with scale ranks;
* `"nolakes"`: States without large lakes;
* `"borders"`: State borders;

## Examples

```julia
NaturalEarth.states()
NaturalEarth.states(scale="1:100")
NaturalEarth.states("borders")
```
"""
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

"""
    NaturalEarth.counties(variant="default"; scale="1:10", kwargs...)

Load all counties of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default counties map;
* `"nolakes"`: Counties without large lakes;
* `"ranks"`: Counties with scale ranks;
* `"ranksislands"`: Counties with scale ranks and minor islands;

## Examples

```julia
NaturalEarth.counties()
NaturalEarth.counties("ranks")
```
"""
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

"""
    NaturalEarth.populatedplaces(variant="default"; scale="1:10", kwargs...)

Load all populated places of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default populated places map;
* `"simple"`: Simplified data (less columns);

## Examples

```julia
NaturalEarth.populatedplaces()
NaturalEarth.populatedplaces(scale="1:100")
NaturalEarth.populatedplaces("simple")
```
"""
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

"""
    NaturalEarth.roads(variant="default"; scale="1:10", kwargs...)

Load all roads of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default roads map;
* `"northamerica"`: Roads with North America supplement;

## Examples

```julia
NaturalEarth.roads()
NaturalEarth.roads("northamerica")
```
"""
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

"""
    NaturalEarth.railroads(variant="default"; scale="1:10", kwargs...)

Load all rail roads of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default rail roads map;
* `"northamerica"`: Rail roads with North America supplement;

## Examples

```julia
NaturalEarth.railroads()
NaturalEarth.railroads("northamerica")
```
"""
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

"""
    NaturalEarth.airports(; scale="1:10", kwargs...)

Load all airports of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.airports()
NaturalEarth.airports("scale="1:50"")
```
"""
airports(; scale="1:10", kwargs...) = get(scale, "Airports", "airports"; kwargs...)

"""
    NaturalEarth.ports(; scale="1:10", kwargs...)

Load all ports of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.ports()
NaturalEarth.ports("scale="1:50"")
```
"""
ports(; scale="1:10", kwargs...) = get(scale, "Ports", "ports"; kwargs...)

"""
    NaturalEarth.urbanareas(; scale="1:10", kwargs...)

Load all urban areas of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.urbanareas()
NaturalEarth.urbanareas("scale="1:50"")
```
"""
urbanareas(; scale="1:10", kwargs...) = get(scale, "Urban Areas", "urban areas"; kwargs...)

"""
    NaturalEarth.usparks(; scale="1:10", kwargs...)

Load the U.S. national parks.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.usparks()
```
"""
usparks(; scale="1:10", kwargs...) = get(scale, "Parks and Protected Lands", "U.S. national parks"; kwargs...)

"""
    NaturalEarth.timezones(; scale="1:10", kwargs...)

Load all time zones of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.timezones()
```
"""
timezones(; scale="1:10", kwargs...) = get(scale, "Timezones", "time zones"; kwargs...)

# -----------------
# HELPER FUNCTIONS
# -----------------

varianterror() = throw(ArgumentError("invalid variant, please check the docstring"))

end
