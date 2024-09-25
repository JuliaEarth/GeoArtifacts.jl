# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to download data from the GeoBR database:

* [`GeoBR.state`](@ref)
* [`GeoBR.municipality`](@ref)
* [`GeoBR.region`](@ref)
* [`GeoBR.country`](@ref)
* [`GeoBR.amazon`](@ref)
* [`GeoBR.biomes`](@ref)
* [`GeoBR.disasterriskarea`](@ref)
* [`GeoBR.healthfacilities`](@ref)
* [`GeoBR.indigenousland`](@ref)
* [`GeoBR.metroarea`](@ref)
* [`GeoBR.neighborhood`](@ref)
* [`GeoBR.urbanarea`](@ref)
* [`GeoBR.weightingarea`](@ref)
* [`GeoBR.mesoregion`](@ref)
* [`GeoBR.microregion`](@ref)
* [`GeoBR.intermediateregion`](@ref)
* [`GeoBR.immediateregion`](@ref)
* [`GeoBR.municipalseat`](@ref)
* [`GeoBR.censustract`](@ref)
* [`GeoBR.statisticalgrid`](@ref)
* [`GeoBR.conservationunits`](@ref)
* [`GeoBR.semiarid`](@ref)
* [`GeoBR.schools`](@ref)
* [`GeoBR.comparableareas`](@ref)
* [`GeoBR.urbanconcentrations`](@ref)
* [`GeoBR.poparrangements`](@ref)
* [`GeoBR.healthregion`](@ref)

Please check their docstrings for more details.
"""
module GeoBR

using GeoIO
using DataDeps
using CSV
using Tables
using TableTransforms

const APIVERSIONS = (v"1.7.0",)

"""
    GeoBR.download(url; version=v"1.7.0")

(Down)load data for the specified `url` and `version` of the GeoBR API.

The available API versions are: 1.7.0.
"""
function download(url; version=v"1.7.0")
  if version ∉ APIVERSIONS
    throw(ArgumentError("invalid API version, please check the docstring"))
  end

  filename = basename(url)

  ID = "GeoBR_$(version)_$(filename)"

  dir = try
    # if data is already on disk
    # we just return the path
    @datadep_str ID
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(
        ID,
        """
        Geographic data provided by the GeoBR project.
        Source: $url
        """,
        url,
        Any
      ))
      @datadep_str ID
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end

  joinpath(dir, filename)
end

"""
    GeoBR.metadata(; version=v"1.7.0")

Metadata for the specified `version` of the GeoBR dataset.
"""
function metadata(; version=v"1.7.0")
  path = download("http://www.ipea.gov.br/geobr/metadata/metadata_$(version)_gpkg.csv"; version)
  CSV.File(path)
end

"""
    GeoBR.get(entity, year=nothing, code=nothing; version=v"1.7.0", kwargs...)

Load geographic data for given `entity`, `year` and `code`.
Optionally specify dataset `version` and `kwargs` passed to
`GeoIO.load`.
"""
function get(entity, year=nothing, code=nothing; version=v"1.7.0", kwargs...)
  table = metadata(; version)

  checkyear = if isnothing(year)
    _ -> true
  else
    row -> row.year == year
  end

  checkcode = if isnothing(code)
    _ -> true
  else
    codestr = string(code)
    row -> row.code == codestr || row.code_abbrev == codestr
  end

  filter = Filter(row -> row.geo == entity && checkyear(row) && checkcode(row))
  srows = table |> filter |> Tables.rows

  srow = if isnothing(year)
    argmax(row -> row.year, srows)
  else
    srows |> first
  end

  url = srow.download_path
  GeoIO.load(download(url; version); kwargs...)
end

"""
    GeoBR.state(code="state"; year=nothing, kwargs...)

Get state data.

## Arguments

* `code`: State code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
state(code="state"; year=nothing, kwargs...) = get("state", year, code; kwargs...)

"""
    GeoBR.municipality(code="municipality"; year=nothing, kwargs...)

Get municipality data for a given year.

## Arguments

* `code`: Municipality code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
municipality(code="municipality"; year=nothing, kwargs...) = get("municipality", year, code; kwargs...)

"""
    GeoBR.region(; year=nothing, kwargs...)

Get region data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
region(; year=nothing, kwargs...) = get("regions", year; kwargs...)

"""
    GeoBR.country(; year=nothing, kwargs...)

Get country data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
country(; year=nothing, kwargs...) = get("country", year; kwargs...)

"""
    GeoBR.amazon(; year=nothing, kwargs...)

Get Amazon data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
amazon(; year=nothing, kwargs...) = get("amazonia_legal", year; kwargs...)

"""
    GeoBR.biomes(; year=nothing, kwargs...)

Get biomes data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
biomes(; year=nothing, kwargs...) = get("biomes", year; kwargs...)

"""
    GeoBR.disasterriskarea(; year=nothing, kwargs...)

Get disaster risk area data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
disasterriskarea(; year=nothing, kwargs...) = get("disaster_risk_area", year; kwargs...)

"""
    GeoBR.healthfacilities(; year=nothing, kwargs...)

Get health facilities data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
healthfacilities(; year=nothing, kwargs...) = get("health_facilities", year; kwargs...)

"""
    GeoBR.indigenousland(; date=nothing, kwargs...)

Get indigenous land data for a given date.

## Arguments

* `date`: Date of the data in format YYYYMM (default to latest available date);
* `kwargs`: Additional keyword arguments;
"""
indigenousland(; date=nothing, kwargs...) = get("indigenous_land", date; kwargs...)

"""
    GeoBR.metroarea(; year=nothing, kwargs...)

Get metropolitan area data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
metroarea(; year=nothing, kwargs...) = get("metropolitan_area", year; kwargs...)

"""
    GeoBR.neighborhood(; year=nothing, kwargs...)

Get neighborhood data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
neighborhood(; year=nothing, kwargs...) = get("neighborhood", year; kwargs...)

"""
    GeoBR.urbanarea(; year=nothing, kwargs...)

Get urban area data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
urbanarea(; year=nothing, kwargs...) = get("urban_area", year; kwargs...)

"""
    GeoBR.weightingarea(code; year=nothing, kwargs...)

Get weighting area data for a given year.

## Arguments

* `code`: Weighting area code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
weightingarea(code; year=nothing, kwargs...) = get("weighting_area", year, code; kwargs...)

"""
    GeoBR.mesoregion(code; year=nothing, kwargs...)

Get mesoregion data for a given year.

## Arguments

* `code`: Mesoregion code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
mesoregion(code; year=nothing, kwargs...) = get("meso_region", year, code; kwargs...)

"""
    GeoBR.microregion(code; year=nothing, kwargs...)

Get microregion data for a given year.

## Arguments

* `code`: Microregion code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
microregion(code; year=nothing, kwargs...) = get("micro_region", year, code; kwargs...)

"""
    GeoBR.intermediateregion(code; year=nothing, kwargs...)

Get intermediate region data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
intermediateregion(; year=nothing, kwargs...) = get("intermediate_regions", year; kwargs...)

"""
    GeoBR.immediateregion(code; year=nothing, kwargs...)

Get immediate region data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
immediateregion(; year=nothing, kwargs...) = get("immediate_regions", year; kwargs...)

"""
    GeoBR.municipalseat(; year=nothing, kwargs...)

Get municipal seat data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
municipalseat(; year=nothing, kwargs...) = get("municipal_seat", year; kwargs...)

"""
    GeoBR.censustract(code; year=nothing, kwargs...)

Get census tract data for a given year.

## Arguments

* `code`: Census tract code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
censustract(code; year=nothing, kwargs...) = get("census_tract", year, code; kwargs...)

"""
    GeoBR.statisticalgrid(code="statistical_grid"; year=nothing, kwargs...)

Get statistical grid data for a given year.

## Arguments

* `code`: Statistical grid code or abbreviation;
* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
statisticalgrid(code="statistical_grid"; year=nothing, kwargs...) = get("statistical_grid", year, code; kwargs...)

"""
    GeoBR.conservationunits(; date=nothing, kwargs...)

Get conservation units data for a given date.

## Arguments

* `date`: Date of the data in format YYYYMM (default to latest available date);
* `kwargs`: Additional keyword arguments;
"""
conservationunits(; date=nothing, kwargs...) = get("conservation_units", date; kwargs...)

"""
    GeoBR.semiarid(; year=nothing, kwargs...)

Get semiarid data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
semiarid(; year=nothing, kwargs...) = get("semiarid", year; kwargs...)

"""
    GeoBR.schools(; year=nothing, kwargs...)

Get schools data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
schools(; year=nothing, kwargs...) = get("schools", year; kwargs...)

"""
    GeoBR.comparableareas(; startyear=1970, endyear=2010, kwargs...)

Get comparable areas data for a given range of years.

## Arguments

* `startyear`: Start year of the data (default to 1970);
* `endyear`: End year of the data (default to 2010);
* `kwargs`: Additional keyword arguments;
"""
function comparableareas(; startyear=1970, endyear=2010, version=v"1.7.0", kwargs...)
  years = (1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 2000, 2010)

  if startyear ∉ years || endyear ∉ years
    throw(ArgumentError("invalid `startyear` or `endyear`, please use one these: $years_available"))
  end

  table = metadata(; version)
  srows = table |> Filter(row -> contains(row.download_path, "$(startyear)_$(endyear)")) |> Tables.rows

  if isempty(srows)
    throw(ErrorException("no comparable areas found for the specified years"))
  end

  srow = first(srows)
  year = srow.year
  code = srow.code

  get("amc", year, code; version, kwargs...)
end

"""
    GeoBR.urbanconcentrations(; year=nothing, kwargs...)

Get urban concentrations data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
urbanconcentrations(; year=nothing, kwargs...) = get("urban_concentrations", year; kwargs...)

"""
    GeoBR.poparrangements(; year=nothing, kwargs...)

Get population arrangements data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
poparrangements(; year=nothing, kwargs...) = get("pop_arrengements", year; kwargs...)

"""
    GeoBR.healthregion(; year=nothing, kwargs...)

Get health region data for a given year.

## Arguments

* `year`: Year of the data (default to latest available year);
* `kwargs`: Additional keyword arguments;
"""
healthregion(; year=nothing, kwargs...) = get("health_region", year; kwargs...)

end