# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

"""
Provides functions to download data from the GeoBR database:

`GeoBR.state`
`GeoBR.municipality`
`GeoBR.region`
`GeoBR.country`
`GeoBR.amazon`
`GeoBR.biomes`
`GeoBR.disasterriskarea`
`GeoBR.healthfacilities`
`GeoBR.indigenousland`
`GeoBR.metroarea`
`GeoBR.neighborhood`
`GeoBR.urbanarea`
`GeoBR.weightingarea`
`GeoBR.mesoregion`
`GeoBR.microregion`
`GeoBR.intermediateregion`
`GeoBR.immediateregion`
`GeoBR.municipalseat`
`GeoBR.censustract`
`GeoBR.statisticalgrid`
`GeoBR.conservationunits`
`GeoBR.semiarid`
`GeoBR.schools`
`GeoBR.comparableareas`
`GeoBR.urbanconcentrations`
`GeoBR.poparrangements`
`GeoBR.healthregion`
"""
module GeoBR

using GeoIO
using DataDeps
using CSV
using Tables
using TableTransforms

const APIVERSIONS = (v"1.7.0",)

"""
    download(url; version=last(APIVERSIONS))

(Down)load data for the specified `url` and `version` of the dataset.
"""
function download(url; version=last(APIVERSIONS))
  ID = "GeoBR_$(version)_$(basename(url))"
  try
    # if data is already on disk
    # we just return the path
    @datadep_str ID
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    register(DataDep(
      ID,
      """
      Data for GeoBR project.
      Source: $url
      """,
      url,
      Any
    ))
    @datadep_str ID
  end
  joinpath(ID, basename(url))
end

"""
    downloadmeta(version=last(APIVERSIONS))

(Down)load metadata for the specified `version` of the dataset.
"""
downloadmeta(version=last(APIVERSIONS)) = download("http://www.ipea.gov.br/geobr/metadata/metadata_$(version)_gpkg.csv"; version)

"""
    geturl(csv, entity, year, code)

Retrieve rows of `csv` for the given `entity`, `year` and `code`.
"""
function geturl(csv, entity, year, code)
  # TODO
end

"""
    get(entity, year; code=nothing, version=last(APIVERSIONS), kwargs...)

Load geographic data for given `entity` and `year`. Optionally specify
`code` or abbreviation and dataset `version`. The `kwargs` are forwarded
to `GeoIO.load`.
"""
function get(entity, year; code=nothing, version=last(APIVERSIONS), kwargs...)
  csv = CSV.File(downloadmeta(version))
  url = geturl(csv, entity, year, code)
  GeoIO.load(download(url; version); kwargs...)
end

"""
    state(; year=2010, code=nothing, kwargs...)

Get state data.

Arguments:
- `year`: Year of the data (default: 2010).
- `code`: State code or abbreviation.
- `kwargs`: Additional keyword arguments.
"""
state(; year=2010, code=nothing, kwargs...) = get("state"; year, code, kwargs...)

"""
    municipality(muni; year=2010, kwargs...)

Get municipality data for a given year.

Arguments:
- `muni`: Municipality code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Municipality data for the specified year.
"""
municipality(muni=nothing; year=2010, kwargs...) = get("municipality", year, muni; kwargs...)

"""
    region(; year=2010, kwargs...)

Get region data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Region data for the specified year.
"""
region(; year=2010, kwargs...) = get("regions", year; kwargs...)

"""
    country(; year=2010, kwargs...)

Get country data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Country data for the specified year.
"""
country(; year=2010, kwargs...) = get("country", year; kwargs...)

"""
    amazon(; year=2012, kwargs...)

Get Amazon data for a given year.

Arguments:
- `year`: Year of the data (default: 2012).
- `kwargs`: Additional keyword arguments.

Returns:
- Amazon data for the specified year.
"""
amazon(; year=2012, kwargs...) = get("amazonia_legal", year; kwargs...)

"""
    biomes(; year=2019, kwargs...)

Get biomes data for a given year.

Arguments:
- `year`: Year of the data (default: 2019).
- `kwargs`: Additional keyword arguments.

Returns:
- Biomes data for the specified year.
"""
biomes(; year=2019, kwargs...) = get("biomes", year; kwargs...)

"""
    disasterriskarea(; year=2010, kwargs...)

Get disaster risk area data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Disaster risk area data for the specified year.
"""
disasterriskarea(; year=2010, kwargs...) = get("disaster_risk_area", year; kwargs...)

"""
    healthfacilities(; year=2013, kwargs...)

Get health facilities data for a given year.

Arguments:
- `year`: Year of the data (default: 2013).
- `kwargs`: Additional keyword arguments.

Returns:
- Health facilities data for the specified year.
"""
healthfacilities(; year=2013, kwargs...) = get("health_facilities", year; kwargs...)

"""
    indigenousland(; date=201907, kwargs...)

Get indigenous land data for a given date.

Arguments:
- `date`: Date of the data (default: 201907).
- `kwargs`: Additional keyword arguments.

Returns:
- Indigenous land data for the specified date.
"""
indigenousland(; date=201907, kwargs...) = get("indigenous_land", date; kwargs...)

"""
    metroarea(; year=2018, kwargs...)

Get metropolitan area data for a given year.

Arguments:
- `year`: Year of the data (default: 2018).
- `kwargs`: Additional keyword arguments.

Returns:
- Metropolitan area data for the specified year.
"""
metroarea(; year=2018, kwargs...) = get("metropolitan_area", year; kwargs...)

"""
    neighborhood(; year=2010, kwargs...)

Get neighborhood data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Neighborhood data for the specified year.
"""
neighborhood(; year=2010, kwargs...) = get("neighborhood", year; kwargs...)

"""
    urbanarea(; year=2015, kwargs...)

Get urban area data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Urban area data for the specified year.
"""
urbanarea(; year=2015, kwargs...) = get("urban_area", year; kwargs...)

"""
    weightingarea(weighting; year=2010, kwargs...)

Get weighting area data for a given year.

Arguments:
- `weighting`: Weighting area code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Weighting area data for the specified year.
"""
weightingarea(weighting=nothing; year=2010, kwargs...) = get("weighting_area", year, weighting; kwargs...)

"""
    mesoregion(meso; year=2010, kwargs...)

Get mesoregion data for a given year.

Arguments:
- `meso`: Mesoregion code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Mesoregion data for the specified year.
"""
mesoregion(meso=nothing; year=2010, kwargs...) = get("meso_region", year, meso; kwargs...)

"""
    microregion(micro; year=2010, kwargs...)

Get microregion data for a given year.

Arguments:
- `micro`: Microregion code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Microregion data for the specified year.
"""
microregion(meso=nothing; year=2010, kwargs...) = get("micro_region", year, meso; kwargs...)

"""
    intermediateregion(intermediate; year=2019, kwargs...)

Get intermediate region data for a given year.

Arguments:
- `intermediate`: 
              6-digit code of an intermediate region. If the two-digit code or a 
              two-letter uppercase abbreviation of a state is passed, (e.g. 33 or 
              "RJ") the function will load all intermediate regions of that state. If 
              intermediate="all", all intermediate regions of the country are loaded 
              (defaults to "all")
- `year`: Year of the data (default: 2019).
- `kwargs`: Additional keyword arguments.

Returns:
- Intermediate region data for the specified year.
"""
function intermediateregion(intermediate; year=2019, kwargs...)
  gdf = get("intermediate_regions", year, kwargs...)
  if intermediate == "all"
    return gdf
  elseif isa(intermediate, Number) && length(string(intermediate)) == 2
    return gdf[gdf.code_state .== intermediate, :]
  elseif isa(intermediate, AbstractString) && length(intermediate) == 2
    return gdf[gdf.abbrev_state .== intermediate, :]
  else
    return gdf[gdf.code_intermediate .== intermediate, :]
  end
end

"""
    immediateregion(immediate; year=2017, kwargs...)

Get immediate region data for a given year.

Arguments:
- `immediate`: 
            6-digit code of an immediate region. If the two-digit code or a 
            two-letter uppercase abbreviation of a state is passed, (e.g. 33 or 
            "RJ") the function will load all immediate regions of that state. If 
            immediate="all", all immediate regions of the country are loaded 
(defaults to "all")
- `year`: Year of the data (default: 2017).
- `kwargs`: Additional keyword arguments.

Returns:
- Immediate region data for the specified year.
"""
function immediateregion(immediate; year=2017, kwargs...)
  gdf = get("immediate_regions", year, kwargs...)
  if immediate == "all"
    return gdf
  elseif isa(immediate, Number) && length(string(immediate)) == 2
    return gdf[gdf.code_state .== string(immediate), :]
  elseif isa(immediate, AbstractString) && length(immediate) == 2
    return gdf[gdf.abbrev_state .== immediate, :]
  else
    return gdf[gdf.code_immediate .== immediate, :]
  end
end

"""
    municipalseat(; year=2010, kwargs...)

Get municipal seat data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Municipal seat data for the specified year.
"""
municipalseat(; year=2010, kwargs...) = get("municipal_seat", year; kwargs...)

"""
    censustract(codetract; year=2010, kwargs...)

Get census tract data for a given year.

Arguments:
- `codetract`: Census tract code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Census tract data for the specified year.
"""
censustract(codetract=nothing; year=2010, kwargs...) = get("census_tract", year, codetract; kwargs...)

"""
    statisticalgrid(grid; year=2010, kwargs...)

Get statistical grid data for a given year.

Arguments:
- `grid`: Statistical grid code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Statistical grid data for the specified year.
"""
statisticalgrid(grid=nothing; year=2010, kwargs...) = get("statistical_grid", year, grid; kwargs...)

"""
    conservationunits(; date=201909, kwargs...)

Get conservation units data for a given date.

Arguments:
- `date`: Date of the data (default: 201909).
- `kwargs`: Additional keyword arguments.

Returns:
- Conservation units data for the specified date.
"""
conservationunits(; date=201909, kwargs...) = get("conservation_units", date; kwargs...)

"""
    semiarid(; year=2017, kwargs...)

Get semiarid data for a given year.

Arguments:
- `year`: Year of the data (default: 2017).
- `kwargs`: Additional keyword arguments.

Returns:
- Semiarid data for the specified year.
"""
semiarid(; year=2017, kwargs...) = get("semiarid", year; kwargs...)

"""
    schools(; year=2020, kwargs...)

Get schools data for a given year.

Arguments:
- `year`: Year of the data (default: 2020).
- `kwargs`: Additional keyword arguments.

Returns:
- Schools data for the specified year.
"""
schools(; year=2020, kwargs...) = get("schools", year; kwargs...)

"""
    comparableareas(; startyear=1970, endyear=2010, kwargs...)

Get comparable areas data for a given range of years.

Arguments:
- `startyear`: Start year of the data (default: 1970).
- `endyear`: End year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Comparable areas data for the specified range of years.
"""
function comparableareas(; startyear=1970, endyear=2010, kwargs...)
  years = (1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 2000, 2010)

  if startyear ∉ years || endyear ∉ years
    throw(ArgumentError("Invalid `startyear` or `endyear`. It must be one of the following: $years_available"))
  end

  meta = metadata("amc", startyear; all=true)
  filt = meta |> Filter(row -> contains(row.download_path, "$(startyear)_$(endyear)")) |> Tables.rows

  if isempty(filt)
    throw(ErrorException("No data found for the specified years"))
  end

  year = first(filt).year

  get("amc", year, kwargs...)
end

"""
    urbanconcentrations(; year=2015, kwargs...)

Get urban concentrations data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Urban concentrations data for the specified year.
"""
urbanconcentrations(; year=2015, kwargs...) = get("urban_concentrations", year; kwargs...)

"""
    poparrangements(; year=2015, kwargs...)

Get population arrangements data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Population arrangements data for the specified year.
"""
poparrangements(; year=2015, kwargs...) = get("pop_arrengements", year; kwargs...)

"""
    healthregion(; year=2013, kwargs...)

Get health region data for a given year.

Arguments:
- `year`: Year of the data (default: 2013).
- `kwargs`: Additional keyword arguments.

Returns:
- Health region data for the specified year.
"""
healthregion(; year=2013, kwargs...) = get("health_region", year; kwargs...)

end
