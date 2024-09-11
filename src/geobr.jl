# ------------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# ------------------------------------------------------------------

module GeoBR

using GeoIO
using DataDeps
using CSV
using Tables
using TableTransforms

const APIVERSIONS = (v"1.7.0",)

function extractmetadata(geo, year, code, abbrev; returnall=false)
    url = "http://www.ipea.gov.br/geobr/metadata/metadata_1.7.0_gpkg.csv"
    ID = "GeoBR_metadata"
    path = ""
    try
        path = @datadep_str getdatadep(ID, url)
    catch
        register(DataDep(ID,
            """
            Metadata for GeoBR package.
            Source: $url
            """,
            url,
            Any
        ))
        path = @datadep_str getdatadep(ID, url)
    end

    table = CSV.File(path)

    srows = table |> Filter(row ->
        row.geo == geo &&
            row.year == year &&
            (isnothing(code) || parse(Int, row.code) == code) &&
            (isnothing(abbrev) || row.code_abbrev == abbrev)
    )

    if isempty(srows)
        throw(ErrorException("No matching rows found for the given parameters"))
    end

    return returnall ? Tables.rows(srows) : Tables.rows(srows) |> first
end

function download(geo, year, code, abbrev)
    srow = extractmetadata(geo, year, code, abbrev)

    url = srow.download_path
    fname = split(url, "/") |> last |> splitext |> first
    ID = "GeoBR_$fname"
    try
        # if data is already on disk
        # we just return the path
        @datadep_str getdatadep(ID, url)
    catch
        # otherwise we register the data
        # and download using DataDeps.jl
        try
            register(DataDep(ID,
                """
                Metadata for GeoBR package.
                Source: $url
                """,
                url,
                Any
            ))
            @datadep_str getdatadep(ID, url)
        catch
            throw(ErrorException("download failed due to internet and/or server issues"))
        end
    end
end

function get(geo, year, code=nothing, abbrev=nothing; kwargs...)
    path = download(geo, year, code, abbrev)
    GeoIO.load(path; kwargs...)
end

"""
    state(state; year=2010, kwargs...)

Get state data for a given year.

Arguments:
- `state`: State code or abbreviation.
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- State data for the specified year.
"""
function state(state; year=2010, kwargs...)
    code = isa(state, Number) ? state : nothing
    abbrev = isa(state, AbstractString) ? state : nothing
    get("state", year, code, abbrev, kwargs...)
end

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
function municipality(muni; year=2010, kwargs...)
    code = isa(muni, Number) ? muni : nothing
    abbrev = isa(muni, AbstractString) ? muni : nothing
    get("municipality", year, code, abbrev; kwargs...)
end

"""
    region(; year=2010, kwargs...)

Get region data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Region data for the specified year.
"""
function region(; year=2010, kwargs...)
    get("regions", year, nothing, nothing, kwargs...)
end

"""
    country(; year=2010, kwargs...)

Get country data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Country data for the specified year.
"""
function country(; year=2010, kwargs...)
    get("country", year, nothing, nothing, kwargs...)
end

"""
    amazon(; year=2012, kwargs...)

Get Amazon data for a given year.

Arguments:
- `year`: Year of the data (default: 2012).
- `kwargs`: Additional keyword arguments.

Returns:
- Amazon data for the specified year.
"""
function amazon(; year=2012, kwargs...)
    get("amazonia_legal", year, nothing, nothing, kwargs...)
end

"""
    biomes(; year=2019, kwargs...)

Get biomes data for a given year.

Arguments:
- `year`: Year of the data (default: 2019).
- `kwargs`: Additional keyword arguments.

Returns:
- Biomes data for the specified year.
"""
function biomes(; year=2019, kwargs...)
    get("biomes", year, nothing, nothing, kwargs...)
end

"""
    disasterriskarea(; year=2010, kwargs...)

Get disaster risk area data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Disaster risk area data for the specified year.
"""
function disasterriskarea(; year=2010, kwargs...)
    get("disaster_risk_area", year, nothing, nothing, kwargs...)
end

"""
    healthfacilities(; year=2013, kwargs...)

Get health facilities data for a given year.

Arguments:
- `year`: Year of the data (default: 2013).
- `kwargs`: Additional keyword arguments.

Returns:
- Health facilities data for the specified year.
"""
function healthfacilities(; year=2013, kwargs...)
    get("health_facilities", year, nothing, nothing, kwargs...)
end

"""
    indigenousland(; date=201907, kwargs...)

Get indigenous land data for a given date.

Arguments:
- `date`: Date of the data (default: 201907).
- `kwargs`: Additional keyword arguments.

Returns:
- Indigenous land data for the specified date.
"""
function indigenousland(; date=201907, kwargs...)
    get("indigenous_land", date, nothing, nothing, kwargs...)
end

"""
    metroarea(; year=2018, kwargs...)

Get metropolitan area data for a given year.

Arguments:
- `year`: Year of the data (default: 2018).
- `kwargs`: Additional keyword arguments.

Returns:
- Metropolitan area data for the specified year.
"""
function metroarea(; year=2018, kwargs...)
    get("metropolitan_area", year, nothing, nothing, kwargs...)
end

"""
    neighborhood(; year=2010, kwargs...)

Get neighborhood data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Neighborhood data for the specified year.
"""
function neighborhood(; year=2010, kwargs...)
    get("neighborhood", year, nothing, nothing, kwargs...)
end

"""
    urbanarea(; year=2015, kwargs...)

Get urban area data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Urban area data for the specified year.
"""
function urbanarea(; year=2015, kwargs...)
    get("urban_area", year, nothing, nothing, kwargs...)
end

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
function weightingarea(weighting; year=2010, kwargs...)
    code = isa(weighting, Number) ? weighting : nothing
    abbrev = isa(weighting, AbstractString) ? weighting : nothing
    get("weighting_area", year, code, abbrev, kwargs...)
end

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
function mesoregion(meso; year=2010, kwargs...)
    code = isa(meso, Number) ? meso : nothing
    abbrev = isa(meso, AbstractString) ? meso : nothing
    get("meso_region", year, code, abbrev, kwargs...)
end

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
function microregion(micro; year=2010, kwargs...)
    code = isa(micro, Number) ? micro : nothing
    abbrev = isa(micro, AbstractString) ? micro : nothing
    get("micro_region", year, code, abbrev, kwargs...)
end

"""
    intermediateregion(intermediate; year=2019, kwargs...)

Get intermediate region data for a given year.

Arguments:
- `intermediate`: Intermediate region code or abbreviation.
- `year`: Year of the data (default: 2019).
- `kwargs`: Additional keyword arguments.

Returns:
- Intermediate region data for the specified year.
"""
function intermediateregion(intermediate; year=2019, kwargs...)
    gdf = get("intermediate_regions", year, nothing, nothing, kwargs...)
    if intermediate == "all"
        return gdf
    elseif isa(intermediate, Number) && length(string(intermediate)) == 2
        return gdf[gdf.code_state.==intermediate, :]
    elseif isa(intermediate, AbstractString) && length(intermediate) == 2
        return gdf[gdf.abbrev_state.==intermediate, :]
    else
        return gdf[gdf.code_intermediate.==intermediate, :]
    end
end

"""
    immediateregion(immediate; year=2017, kwargs...)

Get immediate region data for a given year.

Arguments:
- `immediate`: Immediate region code or abbreviation.
- `year`: Year of the data (default: 2017).
- `kwargs`: Additional keyword arguments.

Returns:
- Immediate region data for the specified year.
"""
function immediateregion(immediate; year=2017, kwargs...)
    gdf = get("immediate_regions", year, nothing, nothing, kwargs...)
    if immediate == "all"
        return gdf
    elseif isa(immediate, Number) && length(string(immediate)) == 2
        return gdf[gdf.code_state.==string(immediate), :]
    elseif isa(immediate, AbstractString) && length(immediate) == 2
        return gdf[gdf.abbrev_state.==immediate, :]
    else
        return gdf[gdf.code_immediate.==immediate, :]
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
function municipalseat(; year=2010, kwargs...)
    get("municipal_seat", year, nothing, nothing, kwargs...)
end

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
function censustract(codetract; year=2010, kwargs...)
    code = isa(codetract, Number) ? codetract : nothing
    abbrev = isa(codetract, AbstractString) ? codetract : nothing
    get("census_tract", year, code, abbrev, kwargs...)
end

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
function statisticalgrid(grid; year=2010, kwargs...)
    code = isa(grid, Number) ? grid : nothing
    abbrev = isa(grid, AbstractString) ? grid : nothing
    get("statistical_grid", year, code, abbrev, kwargs...)
end

"""
    conservationunits(; date=201909, kwargs...)

Get conservation units data for a given date.

Arguments:
- `date`: Date of the data (default: 201909).
- `kwargs`: Additional keyword arguments.

Returns:
- Conservation units data for the specified date.
"""
function conservationunits(; date=201909, kwargs...)
    get("conservation_units", date, nothing, nothing, kwargs...)
end

"""
    semiarid(; year=2017, kwargs...)

Get semiarid data for a given year.

Arguments:
- `year`: Year of the data (default: 2017).
- `kwargs`: Additional keyword arguments.

Returns:
- Semiarid data for the specified year.
"""
function semiarid(; year=2017, kwargs...)
    get("semiarid", year, nothing, nothing, kwargs...)
end

"""
    schools(; year=2020, kwargs...)

Get schools data for a given year.

Arguments:
- `year`: Year of the data (default: 2020).
- `kwargs`: Additional keyword arguments.

Returns:
- Schools data for the specified year.
"""
function schools(; year=2020, kwargs...)
    get("schools", year, nothing, nothing, kwargs...)
end

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
    years_available = [1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 2000, 2010]

    if !(startyear in years_available) || !(endyear in years_available)
        throw(ArgumentError("Invalid `startyear` or `endyear`. It must be one of the following: $years_available"))
    end

    metadata = extractmetadata("amc", startyear, nothing, nothing; returnall=true)
    metadata = metadata |> Filter(row -> contains(row.download_path, "$(startyear)_$(endyear)")) |> Tables.rows

    if isempty(metadata)
        throw(ErrorException("No data found for the specified years"))
    end

    first_row = first(metadata)
    get("amc", first_row.year, nothing, nothing; kwargs...)
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
function urbanconcentrations(; year=2015, kwargs...)
    get("urban_concentrations", year, nothing, nothing, kwargs...)
end

"""
    poparrangements(; year=2015, kwargs...)

Get population arrangements data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Population arrangements data for the specified year.
"""
function poparrangements(; year=2015, kwargs...)
    get("pop_arrengements", year, nothing, nothing, kwargs...)
end

"""
    healthregion(; year=2013, kwargs...)

Get health region data for a given year.

Arguments:
- `year`: Year of the data (default: 2013).
- `kwargs`: Additional keyword arguments.

Returns:
- Health region data for the specified year.
"""
function healthregion(; year=2013, kwargs...)
    get("health_region", year, nothing, nothing, kwargs...)
end

function getdatadep(ID, url)
    filename = split(url, "/") |> last
    ID * "/" * filename
end

end