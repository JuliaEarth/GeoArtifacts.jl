# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to (down)load data from the GeoBR database.

Please check the docstring of each function for more details:

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

(Down)load data for the specified `url` and `version` of the GeoBR database.

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

Metadata for the specified `version` of the GeoBR database.
"""
metadata(; version=v"1.7.0") =
  CSV.File(download("http://www.ipea.gov.br/geobr/metadata/metadata_$(version)_gpkg.csv"; version))

"""
    GeoBR.get(entity, year=nothing, code=nothing; version=v"1.7.0", kwargs...)

Load geographic data for given `entity`, `year` and `code`.
Optionally specify database `version` and `kwargs` passed to `GeoIO.load` function.
"""
function get(entity, year=nothing, code=nothing; version=v"1.7.0", kwargs...)
  table = metadata(; version)

  function select(row)
    result = row.geo == entity
    if !isnothing(year)
      result &= row.year == year
    end
    if !isnothing(code)
      codestr = string(code)
      result &= row.code == codestr || row.code_abbrev == codestr
    end
    result
  end

  srows = table |> Filter(select) |> Tables.rows

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

* `code`: State code or abbreviation, e.g. 33 or "RJ" (default to all states);
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
state(code="state"; year=nothing, kwargs...) = get("state", year, code; kwargs...)

"""
    GeoBR.municipality(code="municipality"; year=nothing, kwargs...)

Get municipality data for a given year.

## Arguments

* `code`: State code or abbreviation, e.g. 33 or "RJ" (default to all states);
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
municipality(code="municipality"; year=nothing, kwargs...) = get("municipality", year, code; kwargs...)

"""
    GeoBR.region(; year=nothing, kwargs...)

Get region data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
region(; year=nothing, kwargs...) = get("regions", year; kwargs...)

"""
    GeoBR.country(; year=nothing, kwargs...)

Get country data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
country(; year=nothing, kwargs...) = get("country", year; kwargs...)

"""
    GeoBR.amazon(; year=nothing, kwargs...)

Get Amazon data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
amazon(; year=nothing, kwargs...) = get("amazonia_legal", year; kwargs...)

"""
    GeoBR.biomes(; year=nothing, kwargs...)

Get biomes data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
biomes(; year=nothing, kwargs...) = get("biomes", year; kwargs...)

"""
    GeoBR.disasterriskarea(; year=nothing, kwargs...)

Get disaster risk area data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
disasterriskarea(; year=nothing, kwargs...) = get("disaster_risk_area", year; kwargs...)

"""
    GeoBR.healthfacilities(; year=nothing, kwargs...)

Get health facilities data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
healthfacilities(; year=nothing, kwargs...) = get("health_facilities", year; kwargs...)

"""
    GeoBR.indigenousland(; date=nothing, kwargs...)

Get indigenous land data for a given date.

## Arguments

* `date`: Date of the data in format YYYYMM (default to latest available date);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
indigenousland(; date=nothing, kwargs...) = get("indigenous_land", date; kwargs...)

"""
    GeoBR.metroarea(; year=nothing, kwargs...)

Get metropolitan area data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
metroarea(; year=nothing, kwargs...) = get("metropolitan_area", year; kwargs...)

"""
    GeoBR.neighborhood(; year=nothing, kwargs...)

Get neighborhood data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
neighborhood(; year=nothing, kwargs...) = get("neighborhood", year; kwargs...)

"""
    GeoBR.urbanarea(; year=nothing, kwargs...)

Get urban area data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
urbanarea(; year=nothing, kwargs...) = get("urban_area", year; kwargs...)

"""
    GeoBR.weightingarea(code; year=nothing, kwargs...)

Get weighting area data for a given year.

## Arguments

* `code`: State code or abbreviation, e.g. 33 or "RJ";
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
weightingarea(code; year=nothing, kwargs...) = get("weighting_area", year, code; kwargs...)

"""
    GeoBR.mesoregion(code; year=nothing, kwargs...)

Get mesoregion data for a given year.

## Arguments

* `code`: State code or abbreviation, e.g. 33 or "RJ";
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
mesoregion(code; year=nothing, kwargs...) = get("meso_region", year, code; kwargs...)

"""
    GeoBR.microregion(code; year=nothing, kwargs...)

Get microregion data for a given year.

## Arguments

* `code`: State code or abbreviation, e.g. 33 or "RJ";
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
microregion(code; year=nothing, kwargs...) = get("micro_region", year, code; kwargs...)

"""
    GeoBR.intermediateregion(code; year=nothing, kwargs...)

Get intermediate region data for a given year.

## Arguments

* `code`: 4-digit code of an intermediate region. If the two-digit code or a 
  two-letter uppercase abbreviation of a state is passed, (e.g. 33 or "RJ") 
  the function will load all intermediate regions of that state.
  Otherwise, all intermediate regions of the country are loaded.
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
function intermediateregion(code; year=nothing, kwargs...)
  gtb = get("intermediate_regions", year; kwargs...)
  gtb |> Filter(row -> row.abbrev_state == code || row.code_state == code || row.code_intermediate == code)
end

"""
    GeoBR.immediateregion(code; year=nothing, kwargs...)

Get immediate region data for a given year.

## Arguments

* `code`: 6-digit code of an immediate region. If the two-digit code or a 
  two-letter uppercase abbreviation of a state is passed, (e.g. 33 or "RJ") 
  the function will load all immediate regions of that state.
  Otherwise, all immediate regions of the country are loaded.
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
function immediateregion(code; year=nothing, kwargs...)
  gtb = get("immediate_regions", year; kwargs...)
  gtb |> Filter(row -> row.abbrev_state == code || row.code_state == code || row.code_immediate == code)
end

"""
    GeoBR.municipalseat(; year=nothing, kwargs...)

Get municipal seat data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
municipalseat(; year=nothing, kwargs...) = get("municipal_seat", year; kwargs...)

"""
    GeoBR.censustract(code; year=nothing, kwargs...)

Get census tract data for a given year.

## Arguments

* `code`: State code or abbreviation, e.g. 33 or "RJ";
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
censustract(code; year=nothing, kwargs...) = get("census_tract", year, code; kwargs...)

"""
    GeoBR.statisticalgrid(code; year=nothing, kwargs...)

Get statistical grid data for a given year.

## Arguments

* `code`: State code or abbreviation, e.g. 33 or "RJ";
* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
statisticalgrid(code; year=nothing, kwargs...) = get("statistical_grid", year, code; kwargs...)

"""
    GeoBR.conservationunits(; date=nothing, kwargs...)

Get conservation units data for a given date.

## Arguments

* `date`: Date of the data in format YYYYMM (default to latest available date);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
conservationunits(; date=nothing, kwargs...) = get("conservation_units", date; kwargs...)

"""
    GeoBR.semiarid(; year=nothing, kwargs...)

Get semiarid data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
semiarid(; year=nothing, kwargs...) = get("semiarid", year; kwargs...)

"""
    GeoBR.schools(; year=nothing, kwargs...)

Get schools data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
schools(; year=nothing, kwargs...) = get("schools", year; kwargs...)

"""
    GeoBR.comparableareas(; startyear=1970, endyear=2010, kwargs...)

Get comparable areas data for a given range of years.

## Arguments

* `startyear`: Start year of the data in format YYYY (default to 1970);
* `endyear`: End year of the data in format YYYY (default to 2010);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
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

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
urbanconcentrations(; year=nothing, kwargs...) = get("urban_concentrations", year; kwargs...)

"""
    GeoBR.poparrangements(; year=nothing, kwargs...)

Get population arrangements data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
poparrangements(; year=nothing, kwargs...) = get("pop_arrengements", year; kwargs...)

"""
    GeoBR.healthregion(; year=nothing, kwargs...)

Get health region data for a given year.

## Arguments

* `year`: Year of the data in format YYYY (default to latest available year);
* `kwargs`: Keyword arguments passed to [`GeoBR.get`](@ref) function;
"""
healthregion(; year=nothing, kwargs...) = get("health_region", year; kwargs...)

end
