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

(Down)load data for the specified `url` and `version` of the dataset.
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
    GeoBR.downloadmeta(; version=v"1.7.0")

(Down)load metadata for the specified `version` of the dataset.
"""
downloadmeta(; version=v"1.7.0") =
  download("http://www.ipea.gov.br/geobr/metadata/metadata_$(version)_gpkg.csv"; version)

"""
    GeoBR.get(entity, year, code; version=v"1.7.0", kwargs...)

Load geographic data for given `entity`, `year` and `code`.
Optionally specify dataset `version` and `kwargs` passed to
`GeoIO.load`.
"""
function get(entity, year, code=nothing; version=v"1.7.0", kwargs...)
  table = CSV.File(downloadmeta(; version))
  # TODO: add logic with code parameter, which
  # can be either an integer or a string
  srows = table |> Filter(row -> row.geo == entity && row.year == year)
  srow = Tables.rows(srows) |> first
  url = srow.download_path
  GeoIO.load(download(url; version); kwargs...)
end

"""
    GeoBR.state(code="all"; year=2010, kwargs...)

Get state data.

## Arguments

* `code`: State code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
state(code="all"; year=2010, kwargs...) = get("state", year, code; kwargs...)

"""
    GeoBR.municipality(code; year=2010, kwargs...)

Get municipality data for a given year.

## Arguments

* `code`: Municipality code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
municipality(code; year=2010, kwargs...) = get("municipality", year, code; kwargs...)

"""
    GeoBR.region(; year=2010, kwargs...)

Get region data for a given year.

## Arguments

* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
region(; year=2010, kwargs...) = get("regions", year; kwargs...)

"""
    GeoBR.country(; year=2010, kwargs...)

Get country data for a given year.

## Arguments

* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
country(; year=2010, kwargs...) = get("country", year; kwargs...)

"""
    GeoBR.amazon(; year=2012, kwargs...)

Get Amazon data for a given year.

## Arguments

* `year`: Year of the data (default: 2012).
* `kwargs`: Additional keyword arguments.
"""
amazon(; year=2012, kwargs...) = get("amazonia_legal", year; kwargs...)

"""
    GeoBR.biomes(; year=2019, kwargs...)

Get biomes data for a given year.

## Arguments

* `year`: Year of the data (default: 2019).
* `kwargs`: Additional keyword arguments.
"""
biomes(; year=2019, kwargs...) = get("biomes", year; kwargs...)

"""
    GeoBR.disasterriskarea(; year=2010, kwargs...)

Get disaster risk area data for a given year.

## Arguments

* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
disasterriskarea(; year=2010, kwargs...) = get("disaster_risk_area", year; kwargs...)

"""
    GeoBR.healthfacilities(; year=2013, kwargs...)

Get health facilities data for a given year.

## Arguments

* `year`: Year of the data (default: 2013).
* `kwargs`: Additional keyword arguments.
"""
healthfacilities(; year=2013, kwargs...) = get("health_facilities", year; kwargs...)

"""
    GeoBR.indigenousland(; date=201907, kwargs...)

Get indigenous land data for a given date.

## Arguments

* `date`: Date of the data (default: 201907).
* `kwargs`: Additional keyword arguments.
"""
indigenousland(; date=201907, kwargs...) = get("indigenous_land", date; kwargs...)

"""
    GeoBR.metroarea(; year=2018, kwargs...)

Get metropolitan area data for a given year.

## Arguments

* `year`: Year of the data (default: 2018).
* `kwargs`: Additional keyword arguments.
"""
metroarea(; year=2018, kwargs...) = get("metropolitan_area", year; kwargs...)

"""
    GeoBR.neighborhood(; year=2010, kwargs...)

Get neighborhood data for a given year.

## Arguments

* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
neighborhood(; year=2010, kwargs...) = get("neighborhood", year; kwargs...)

"""
    GeoBR.urbanarea(; year=2015, kwargs...)

Get urban area data for a given year.

## Arguments

* `year`: Year of the data (default: 2015).
* `kwargs`: Additional keyword arguments.
"""
urbanarea(; year=2015, kwargs...) = get("urban_area", year; kwargs...)

"""
    GeoBR.weightingarea(code; year=2010, kwargs...)

Get weighting area data for a given year.

## Arguments

* `code`: Weighting area code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
weightingarea(code; year=2010, kwargs...) = get("weighting_area", year, code; kwargs...)

"""
    GeoBR.mesoregion(code; year=2010, kwargs...)

Get mesoregion data for a given year.

## Arguments

* `code`: Mesoregion code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
mesoregion(code; year=2010, kwargs...) = get("meso_region", year, code; kwargs...)

"""
    GeoBR.microregion(code; year=2010, kwargs...)

Get microregion data for a given year.

## Arguments

* `code`: Microregion code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
microregion(code; year=2010, kwargs...) = get("micro_region", year, code; kwargs...)

"""
    GeoBR.intermediateregion(code; year=2019, kwargs...)

Get intermediate region data for a given year.

## Arguments

* `code`: 6-digit code of an intermediate region. If the two-digit code or a 
  two-letter uppercase abbreviation of a state is passed, (e.g. 33 or "RJ") 
  the function will load all intermediate regions of that state.
  Otherwise, all intermediate regions of the country are loaded.
* `year`: Year of the data (default: 2019).
* `kwargs`: Additional keyword arguments.
"""
intermediateregion(code; year=2019, kwargs...) = get("intermediate_regions", year, code; kwargs...)

"""
    GeoBR.immediateregion(code; year=2017, kwargs...)

Get immediate region data for a given year.

## Arguments

* `code`: 6-digit code of an immediate region. If the two-digit code or a 
  two-letter uppercase abbreviation of a state is passed, (e.g. 33 or "RJ") 
  the function will load all immediate regions of that state.
  Otherwise, all immediate regions of the country are loaded.
* `year`: Year of the data (default: 2017).
* `kwargs`: Additional keyword arguments.
"""
immediateregion(code; year=2017, kwargs...) = get("immediate_regions", year, code; kwargs...)

"""
    GeoBR.municipalseat(; year=2010, kwargs...)

Get municipal seat data for a given year.

## Arguments

* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
municipalseat(; year=2010, kwargs...) = get("municipal_seat", year; kwargs...)

"""
    GeoBR.censustract(code; year=2010, kwargs...)

Get census tract data for a given year.

## Arguments

* `code`: Census tract code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
censustract(code; year=2010, kwargs...) = get("census_tract", year, code; kwargs...)

"""
    GeoBR.statisticalgrid(code; year=2010, kwargs...)

Get statistical grid data for a given year.

## Arguments

* `code`: Statistical grid code or abbreviation.
* `year`: Year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
statisticalgrid(code; year=2010, kwargs...) = get("statistical_grid", year, code; kwargs...)

"""
    GeoBR.conservationunits(; date=201909, kwargs...)

Get conservation units data for a given date.

## Arguments

* `date`: Date of the data (default: 201909).
* `kwargs`: Additional keyword arguments.
"""
conservationunits(; date=201909, kwargs...) = get("conservation_units", date; kwargs...)

"""
    GeoBR.semiarid(; year=2017, kwargs...)

Get semiarid data for a given year.

## Arguments

* `year`: Year of the data (default: 2017).
* `kwargs`: Additional keyword arguments.
"""
semiarid(; year=2017, kwargs...) = get("semiarid", year; kwargs...)

"""
    GeoBR.schools(; year=2020, kwargs...)

Get schools data for a given year.

## Arguments

* `year`: Year of the data (default: 2020).
* `kwargs`: Additional keyword arguments.
"""
schools(; year=2020, kwargs...) = get("schools", year; kwargs...)

"""
    GeoBR.comparableareas(; startyear=1970, endyear=2010, kwargs...)

Get comparable areas data for a given range of years.

## Arguments

* `startyear`: Start year of the data (default: 1970).
* `endyear`: End year of the data (default: 2010).
* `kwargs`: Additional keyword arguments.
"""
function comparableareas(; startyear=1970, endyear=2010, version=v"1.7.0", kwargs...)
  years = (1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 2000, 2010)

  if startyear ∉ years || endyear ∉ years
    throw(ArgumentError("invalid `startyear` or `endyear`, please use one these: $years_available"))
  end

  table = CSV.File(downloadmeta(; version))
  srows = table |> Filter(row -> contains(row.download_path, "$(startyear)_$(endyear)")) |> Tables.rows

  if isempty(srows)
    throw(ErrorException("no comparable areas found for the specified years"))
  end

  year = first(srows).year

  get("amc", year; version, kwargs...)
end

"""
    GeoBR.urbanconcentrations(; year=2015, kwargs...)

Get urban concentrations data for a given year.

## Arguments

* `year`: Year of the data (default: 2015).
* `kwargs`: Additional keyword arguments.
"""
urbanconcentrations(; year=2015, kwargs...) = get("urban_concentrations", year; kwargs...)

"""
    GeoBR.poparrangements(; year=2015, kwargs...)

Get population arrangements data for a given year.

## Arguments

* `year`: Year of the data (default: 2015).
* `kwargs`: Additional keyword arguments.
"""
poparrangements(; year=2015, kwargs...) = get("pop_arrengements", year; kwargs...)

"""
    GeoBR.healthregion(; year=2013, kwargs...)

Get health region data for a given year.

## Arguments

* `year`: Year of the data (default: 2013).
* `kwargs`: Additional keyword arguments.
"""
healthregion(; year=2013, kwargs...) = get("health_region", year; kwargs...)

end