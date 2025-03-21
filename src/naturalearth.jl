# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to (down)load data from the Natural Earth database:

https://www.naturalearthdata.com

Please check the docstring of each function for more details:

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
* [`NaturalEarth.coastlines`](@ref)
* [`NaturalEarth.lands`](@ref)
* [`NaturalEarth.minorislands`](@ref)
* [`NaturalEarth.reefs`](@ref)
* [`NaturalEarth.oceans`](@ref)
* [`NaturalEarth.rivers`](@ref)
* [`NaturalEarth.lakes`](@ref)
* [`NaturalEarth.physicallabels`](@ref)
* [`NaturalEarth.playas`](@ref)
* [`NaturalEarth.glaciatedareas`](@ref)
* [`NaturalEarth.iceshelves`](@ref)
* [`NaturalEarth.bathymetry`](@ref)
* [`NaturalEarth.geographiclines`](@ref)
* [`NaturalEarth.graticules`](@ref)
* [`NaturalEarth.hypsometrictints`](@ref)
* [`NaturalEarth.naturalearth1`](@ref)
* [`NaturalEarth.naturalearth2`](@ref)
* [`NaturalEarth.oceanbottom`](@ref)
* [`NaturalEarth.shadedrelief`](@ref)
* [`NaturalEarth.grayearth`](@ref)
* [`NaturalEarth.usmanualshadedrelief`](@ref)
* [`NaturalEarth.manualshadedrelief`](@ref)
* [`NaturalEarth.prismashadedrelief`](@ref)
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

* `scale`: Specifies the the map scale, can be: `"1:10"`, `"1:50"` or `"1:110"`;
* `entity`: Specifies the name of the map to load;
* `variant`: Specifies the type of geographic data to load;
"""
function download(scale, entity, variant)
  if scale ∉ ("1:10", "1:50", "1:110")
    throw(ArgumentError("invalid scale, please use one these: 1:10, 1:50, 1:110"))
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

* `scale`: Specifies the the map scale, can be: `"1:10"`, `"1:50"` or `"1:110"`;
* `entity`: Specifies the name of the map to load;
* `variant`: Specifies the type of geographic data to load;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;
"""
function get(scale, entity, variant; kwargs...)
  path = download(scale, entity, variant)

  # find Shapefile/GeoTIFF file
  files = rreaddir(path)
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
NaturalEarth.countries(scale="1:110")
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
NaturalEarth.borders(scale="1:110")
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
NaturalEarth.states(scale="1:110")
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
    if scale == "1:110"
      "boundaries"
    else
      "boundary lines"
    end
  else
    varianterror()
  end
  entity = if scale == "1:50"
    "Admin 1 – States, provinces"
  else
    "Admin 1 – States, Provinces"
  end
  get(scale, entity, variantstr; kwargs...)
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
NaturalEarth.populatedplaces(scale="1:110")
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

"""
    NaturalEarth.coastlines(; scale="1:10", kwargs...)

Load all coastlines of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.coastlines()
NaturalEarth.coastlines(scale="1:110")
```
"""
coastlines(; scale="1:10", kwargs...) = get(scale, "Coastline", "coastline"; kwargs...)

"""
    NaturalEarth.lands(variant="default"; scale="1:10", kwargs...)

Load all lands of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default lands map;
* `"ranks"`: Lands with scale ranks;

## Examples

```julia
NaturalEarth.lands()
NaturalEarth.lands(scale="1:110")
NaturalEarth.lands("ranks")
```
"""
function lands(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "land"
  elseif variant == "ranks"
    "scale rank"
  else
    varianterror()
  end
  get(scale, "Land", variantstr; kwargs...)
end

"""
    NaturalEarth.minorislands(variant="default"; scale="1:10", kwargs...)

Load all minor islands of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default minor islands map;
* `"coastline"`: Minor islands coastline;

## Examples

```julia
NaturalEarth.minorislands()
NaturalEarth.minorislands("coastline")
```
"""
function minorislands(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "minor islands"
  elseif variant == "coastline"
    "minor islands coastline"
  else
    varianterror()
  end
  get(scale, "Minor Islands", variantstr; kwargs...)
end

"""
    NaturalEarth.reefs(; scale="1:10", kwargs...)

Load all reefs of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.reefs()
```
"""
reefs(; scale="1:10", kwargs...) = get(scale, "Reefs", "reefs"; kwargs...)

"""
    NaturalEarth.oceans(variant="default"; scale="1:10", kwargs...)

Load all oceans of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default oceans map;
* `"ranks"`: Oceans with scale ranks;

## Examples

```julia
NaturalEarth.oceans()
NaturalEarth.oceans(scale="1:110")
NaturalEarth.oceans("ranks")
```
"""
function oceans(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "ocean"
  elseif variant == "ranks"
    "scale rank"
  else
    varianterror()
  end
  get(scale, "Ocean", variantstr; kwargs...)
end

"""
    NaturalEarth.rivers(variant="default"; scale="1:10", kwargs...)

Load all rivers and lake centerlines of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default rivers map;
* `"ranks"`: Rivers with scale ranks and tapering;
* `"australia"`: Rivers with Australia supplement;
* `"europe"`: Rivers with Europe supplement;
* `"northamerica"`: Rivers with North America supplement;

## Examples

```julia
NaturalEarth.rivers()
NaturalEarth.rivers(scale="1:110")
NaturalEarth.rivers("ranks")
```
"""
function rivers(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "rivers and lake centerlines"
  elseif variant == "ranks"
    "with scale ranks + tapering"
  elseif variant == "australia"
    "Australia supplement"
  elseif variant == "europe"
    "Europe supplement"
  elseif variant == "northamerica"
    "North America supplement"
  else
    varianterror()
  end
  entity = if scale == "1:10"
    "Rivers + lake centerlines"
  else
    "Rivers, Lake Centerlines"
  end
  get(scale, entity, variantstr; kwargs...)
end

"""
    NaturalEarth.lakes(variant="default"; scale="1:10", kwargs...)

Load all lakes and reservoirs of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default lakes map;
* `"historic"`: Historic lakes;
* `"pluvial"`: Pluvial lakes;
* `"australia"`: Lakes with Australia supplement;
* `"europe"`: Lakes with Europe supplement;
* `"northamerica"`: Lakes with North America supplement;

## Examples

```julia
NaturalEarth.lakes()
NaturalEarth.lakes(scale="1:110")
NaturalEarth.lakes("historic")
```
"""
function lakes(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "lakes"
  elseif variant == "historic"
    if scale == "1:10"
      "historic lakes"
    else
      "historic"
    end
  elseif variant == "pluvial"
    "pluvial lakes"
  elseif variant == "australia"
    "Australia supplement"
  elseif variant == "europe"
    "Europe supplement"
  elseif variant == "northamerica"
    "North America supplement"
  else
    varianterror()
  end
  get(scale, "Lakes + Reservoirs", variantstr; kwargs...)
end

"""
    NaturalEarth.physicallabels(variant="default"; scale="1:10", kwargs...)

Load physical labels for areas and points of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Physical labels for areas;
* `"points"`: Physical labels for points;
* `"elevationpoints"`: Physical labels for elevation points;
* `"marineareas"`: Physical labels for marine areas;

```julia
NaturalEarth.physicallabels()
NaturalEarth.physicallabels(scale="1:50")
NaturalEarth.physicallabels("points")
NaturalEarth.physicallabels("points", scale="1:110")
```
"""
function physicallabels(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "label areas"
  elseif variant == "points"
    "label points"
  elseif variant == "elevationpoints"
    "elevation points"
  elseif variant == "marineareas"
    "marine areas"
  else
    varianterror()
  end
  get(scale, "Physical Labels", variantstr; kwargs...)
end

"""
    NaturalEarth.playas(; scale="1:10", kwargs...)

Load all playas of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.playas()
NaturalEarth.playas(scale="1:50")
```
"""
playas(; scale="1:10", kwargs...) = get(scale, "Playas", "playas"; kwargs...)

"""
    NaturalEarth.glaciatedareas(; scale="1:10", kwargs...)

Load all glaciated areas of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.glaciatedareas()
NaturalEarth.glaciatedareas(scale="1:110")
```
"""
glaciatedareas(; scale="1:10", kwargs...) = get(scale, "Glaciated Areas", "glaciated areas"; kwargs...)

"""
    NaturalEarth.iceshelves(variant="default"; scale="1:10", kwargs...)

Load the Antarctic ice shelves.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default Antarctic ice shelves map;
* `"borders"`: Antarctic ice shelve borders;

## Examples

```julia
NaturalEarth.iceshelves()
NaturalEarth.iceshelves(scale="1:50")
NaturalEarth.iceshelves("borders")
```
"""
function iceshelves(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "Antarctic ice shelves"
  elseif variant == "borders"
    "Antarctic ice shelve edge"
  else
    varianterror()
  end
  get(scale, "Antarctic Ice Shelves", variantstr; kwargs...)
end

"""
    NaturalEarth.bathymetry(variant="default"; scale="1:10", kwargs...)

Load the bathymetry of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: All depths;
* Number: Depth in meters, can be: `"0"`, `"200"`, `"1000"`, `"2000"`, `"3000"`,
  `"4000"`, `"5000"`, `"6000"`, `"7000"`, `"8000"`, `"9000"`, `"10000"`;

## Examples

```julia
NaturalEarth.bathymetry()
NaturalEarth.bathymetry("5000")
```
"""
function bathymetry(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    "all"
  elseif variant == "0"
    "0m"
  elseif variant == "200"
    "200 m"
  elseif variant == "1000"
    "1,000 m"
  elseif variant == "2000"
    "2,000 m"
  elseif variant == "3000"
    "3,000 m"
  elseif variant == "4000"
    "4,000 m"
  elseif variant == "5000"
    "5,000 m"
  elseif variant == "6000"
    "6,000 m"
  elseif variant == "7000"
    "7,000 m"
  elseif variant == "8000"
    "8,000 m"
  elseif variant == "9000"
    "9,000 m"
  elseif variant == "10000"
    "10,000 m"
  else
    varianterror()
  end
  get(scale, "Bathymetry", variantstr; kwargs...)
end

"""
    NaturalEarth.geographiclines(; scale="1:10", kwargs...)

Load all geographic lines of the Earth.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.geographiclines()
NaturalEarth.geographiclines(scale="1:110")
```
"""
geographiclines(; scale="1:10", kwargs...) = get(scale, "Geographic lines", "geographic lines"; kwargs...)

"""
    NaturalEarth.graticules(variant="default"; scale="1:10", kwargs...)

Load the graticules of the Earth.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: All graticules;
* Number: Grid interval in degrees, can be: `"1"`, `"5"`, `"10`, `"15"`, `"20"`, `"30"`;
* `"boundingbox"`: WGS84 bounding box;

## Examples

```julia
NaturalEarth.graticules()
NaturalEarth.graticules("15")
```
"""
function graticules(variant="default"; scale="1:10", kwargs...)
  variantstr = if variant == "default"
    if scale == "1:10"
      "all graticules"
    else
      "all"
    end
  elseif variant == "1"
    "1 degree"
  elseif variant == "5"
    "5"
  elseif variant == "10"
    "10"
  elseif variant == "15"
    "15"
  elseif variant == "20"
    "20"
  elseif variant == "30"
    "30"
  elseif variant == "boundingbox"
    "bounding box"
  else
    varianterror()
  end
  get(scale, "Graticules", variantstr; kwargs...)
end

"""
    NaturalEarth.hypsometrictints(variant="default"; scale="1:10", size="default", kwargs...)

Load the Cross-blended Hypsometric Tints raster data.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `size`: Optional keyword argument to determine the map size;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default Cross-blended Hypsometric Tints map;
* `"relief"`: Cross-blended Hypsometric Tints with Shaded Relief;
* `"water"`: Cross-blended Hypsometric Tints with Shaded Relief and Water;
* `"drainages"`: Cross-blended Hypsometric Tints with Shaded Relief, Water, and Drainages;
* `"oceanbottom"`: Cross-blended Hypsometric Tints with Shaded Relief, Water, Drainages, and Ocean Bottom;

## Sizes

* `"default"`: Minimum size supported by `scale`;
* `"large"`: Large size;
* `"medium"`: Medium size;
* `"small"`: Small size;

## Examples

```julia
NaturalEarth.hypsometrictints()
NaturalEarth.hypsometrictints(scale="1:50")
NaturalEarth.hypsometrictints("oceanbottom", size="large")
```
"""
function hypsometrictints(variant="default"; scale="1:10", size="default", kwargs...)
  variantstr = if size == "default"
    if scale == "1:10"
      "medium size"
    else
      "small size"
    end
  elseif size == "large"
    "large size"
  elseif size == "medium"
    "medium size"
  elseif size == "small"
    "small size"
  else
    sizeerror()
  end

  entity = if variant == "default"
    if scale == "1:10"
      "Cross Blended Hypso"
    else
      "Cross Blended Hypso with Shaded Relief"
    end
  elseif variant == "relief"
    "Cross Blended Hypso with Shaded Relief"
  elseif variant == "water"
    "Cross Blended Hypso with Shaded Relief and Water"
  elseif variant == "drainages"
    "Cross Blended Hypso with Shaded Relief, Water, and Drainages"
  elseif variant == "oceanbottom"
    "Cross Blended Hypso with Relief, Water, Drains, and Ocean Bottom"
  else
    varianterror()
  end

  get(scale, entity, variantstr; kwargs...)
end

"""
    NaturalEarth.naturalearth1(variant="default"; scale="1:10", size="default", kwargs...)

Load the Natural Earth I raster data.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `size`: Optional keyword argument to determine the map size;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default Natural Earth I map;
* `"relief"`: Natural Earth I with Shaded Relief;
* `"water"`: Natural Earth I with Shaded Relief and Water;
* `"drainages"`: Natural Earth I with Shaded Relief, Water, and Drainages;

## Sizes

* `"default"`: Minimum size supported by passed `scale`;
* `"large"`: Large size;
* `"medium"`: Medium size;
* `"small"`: Small size;

## Examples

```julia
NaturalEarth.naturalearth1()
NaturalEarth.naturalearth1(scale="1:50")
NaturalEarth.naturalearth1("drainages", size="large")
```
"""
function naturalearth1(variant="default"; scale="1:10", size="default", kwargs...)
  variantstr = if size == "default"
    if scale == "1:10"
      "medium size"
    else
      "small size"
    end
  elseif size == "large"
    "large size"
  elseif size == "medium"
    "medium size"
  elseif size == "small"
    "small size"
  else
    sizeerror()
  end

  entity = if variant == "default"
    if scale == "1:10"
      "Natural Earth I"
    else
      "Natural Earth I with Shaded Relief"
    end
  elseif variant == "relief"
    "Natural Earth I with Shaded Relief"
  elseif variant == "water"
    "Natural Earth I with Shaded Relief and Water"
  elseif variant == "drainages"
    "Natural Earth I with Shaded Relief, Water, and Drainages"
  else
    varianterror()
  end

  get(scale, entity, variantstr; kwargs...)
end

"""
    NaturalEarth.naturalearth2(variant="default"; scale="1:10", size="default", kwargs...)

Load the Natural Earth II raster data.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `size`: Optional keyword argument to determine the map size;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default Natural Earth II map;
* `"relief"`: Natural Earth II with Shaded Relief;
* `"water"`: Natural Earth II with Shaded Relief and Water;
* `"drainages"`: Natural Earth II with Shaded Relief, Water, and Drainages;

## Sizes

* `"default"`: Minimum size supported by passed `scale`;
* `"large"`: Large size;
* `"medium"`: Medium size;
* `"small"`: Small size;

## Examples

```julia
NaturalEarth.naturalearth2()
NaturalEarth.naturalearth2(scale="1:50")
NaturalEarth.naturalearth2("drainages", size="large")
```
"""
function naturalearth2(variant="default"; scale="1:10", size="default", kwargs...)
  variantstr = if size == "default"
    if scale == "1:10"
      "medium size"
    else
      "small size"
    end
  elseif size == "large"
    "large size"
  elseif size == "medium"
    "medium size"
  elseif size == "small"
    "small size"
  else
    sizeerror()
  end

  entity = if variant == "default"
    if scale == "1:10"
      "Natural Earth II"
    else
      "Natural Earth II with Shaded Relief"
    end
  elseif variant == "relief"
    "Natural Earth II with Shaded Relief"
  elseif variant == "water"
    "Natural Earth II with Shaded Relief and Water"
  elseif variant == "drainages"
    "Natural Earth II with Shaded Relief, Water, and Drainages"
  else
    varianterror()
  end

  get(scale, entity, variantstr; kwargs...)
end

"""
    NaturalEarth.oceanbottom(; scale="1:10", kwargs...)

Load the Ocean Bottom raster data.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.oceanbottom()
NaturalEarth.oceanbottom(scale="1:50")
```
"""
function oceanbottom(; scale="1:10", kwargs...)
  variantstr = if scale == "1:10"
    "medium size"
  else
    "small size"
  end

  get(scale, "Ocean Bottom", variantstr; kwargs...)
end

"""
    NaturalEarth.shadedrelief(; scale="1:10", size="default", kwargs...)

Load the Shaded Relief raster data.

## Arguments

* `scale`: Optional keyword argument to determine the map scale;
* `size`: Optional keyword argument to determine the map size;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Sizes

* `"default"`: Minimum size supported by passed `scale`;
* `"large"`: Large size;
* `"medium"`: Medium size;
* `"small"`: Small size;

## Examples

```julia
NaturalEarth.shadedrelief()
NaturalEarth.shadedrelief(scale="1:50")
```
"""
function shadedrelief(; scale="1:10", size="default", kwargs...)
  variantstr = if size == "default"
    if scale == "1:10"
      "medium size"
    else
      "small size"
    end
  elseif size == "large"
    "large size"
  elseif size == "medium"
    "medium size"
  elseif size == "small"
    "small size"
  else
    sizeerror()
  end

  get(scale, "Shaded Relief Basic", variantstr; kwargs...)
end

"""
    NaturalEarth.grayearth(variant="default"; scale="1:10", size="default", kwargs...)

Load the Gray Earth raster data.

## Arguments

* `variant`: Specifies the type of geographic data to load;
* `scale`: Optional keyword argument to determine the map scale;
* `size`: Optional keyword argument to determine the map size;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Variants

* `"default"`: Default Gray Earth map;
* `"relief"`: Gray Earth with Shaded Relief and Hypsography;
* `"flatwater"`: Gray Earth with Shaded Relief, Hypsography, and Flat Water;
* `"oceanbottom"`: Gray Earth with Shaded Relief, Hypsography, and Ocean Bottom;
* `"drainages"`: Gray Earth with Shaded Relief, Hypsography, Ocean Bottom, and Drainages;

## Sizes

* `"default"`: Minimum size supported by passed `scale`;
* `"large"`: Large size;
* `"medium"`: Medium size;
* `"small"`: Small size;

## Examples

```julia
NaturalEarth.grayearth()
NaturalEarth.grayearth(scale="1:50")
NaturalEarth.grayearth("drainages", size="large")
```
"""
function grayearth(variant="default"; scale="1:10", size="default", kwargs...)
  variantstr = if size == "default"
    if scale == "1:10"
      "medium size"
    else
      "small size"
    end
  elseif size == "large"
    "large size"
  elseif size == "medium"
    "medium size"
  elseif size == "small"
    "small size"
  else
    sizeerror()
  end

  entity = if variant == "default"
    "Gray Earth with Shaded Relief and Hypsography"
  elseif variant == "relief"
    "Gray Earth with Shaded Relief and Hypsography"
  elseif variant == "flatwater"
    "Gray Earth with Shaded Relief, Hypsography, and Flat Water"
  elseif variant == "oceanbottom"
    "Gray Earth with Shaded Relief, Hypsography, and Ocean Bottom"
  elseif variant == "drainages"
    "Gray Earth with Shaded Relief, Hypsography, Ocean Bottom, and Drainages"
  else
    varianterror()
  end

  get(scale, entity, variantstr; kwargs...)
end

"""
    NaturalEarth.usmanualshadedrelief(; kwargs...)

Load the Manual Shaded Relief of Contiguous US raster data.

## Arguments

* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.usmanualshadedrelief()
```
"""
usmanualshadedrelief(; kwargs...) = get("1:10", "Manual Shaded Relief of Contiguous US", "medium size"; kwargs...)

"""
    NaturalEarth.manualshadedrelief(; kwargs...)

Load the Manual Shaded Relief raster data.

## Arguments

* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.manualshadedrelief()
```
"""
manualshadedrelief(; kwargs...) = get("1:50", "Manual Shaded Relief", "small size"; kwargs...)

"""
    NaturalEarth.prismashadedrelief(; kwargs...)

Load the Prisma Shaded Relief raster data.

## Arguments

* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

## Examples

```julia
NaturalEarth.prismashadedrelief()
```
"""
prismashadedrelief(; kwargs...) = get("1:50", "Prisma Shaded Relief", "small size"; kwargs...)

# -----------------
# HELPER FUNCTIONS
# -----------------

varianterror() = throw(ArgumentError("invalid variant, please check the docstring"))

sizeerror() = throw(ArgumentError("invalid size, please check the docstring"))

# recursive readdir
function rreaddir(dir)
  files = String[]
  _rreaddir!(files, dir)
  files
end

function _rreaddir!(files, dir)
  for path in readdir(dir, join=true)
    isdir(path) && _rreaddir!(files, path)
    isfile(path) && push!(files, path)
  end
end

end
