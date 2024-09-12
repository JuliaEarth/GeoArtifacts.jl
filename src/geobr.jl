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
`GeoBR.filepath`
"""
module GeoBR

using GeoIO
using DataDeps
using CSV
using Tables
using TableTransforms

const APIVERSIONS = (v"1.7.0",)

"""
    metadata()

Retrieve the metadata file path for the GeoBR project.

# Returns
The file path of the metadata CSV file.
"""
function metadata()
    url = "http://www.ipea.gov.br/geobr/metadata/metadata_1.7.0_gpkg.csv"
    ID = "GeoBR_metadata"
    try
        @datadep_str filepath(ID, url)
    catch
        register(DataDep(ID,
            """
            Metadata for GeoBR project.
            Source: $url
            """,
            url,
            Any
        ))
        @datadep_str filepath(ID, url)
    end
end

"""
    metadatarows(geo, year, code, abbrev; all=false)

Retrieve metadata rows for the specified parameters.

# Arguments
- `geo`: The geographic level (e.g., "state", "municipality").
- `year`: The year of the data (e.g., 2010).
- `code`: The numeric code of the geographic area (optional).
- `abbrev`: The abbreviation of the geographic area (optional).
- `all`: If true, return all matching rows; if false, return only the first row (default: false).

# Returns
A single row or all rows of metadata matching the specified criteria.

# Throws
- `ErrorException` if no matching rows are found.
"""
function metadatarows(geo, year, code, abbrev; all=false)
    path = metadata()
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

    all ? Tables.rows(srows) : Tables.rows(srows) |> first
end

"""
    download(url, ID)

Download a file from the given URL and save it using DataDeps.jl.

# Arguments
- `url`: The URL of the file to download.
- `ID`: A unique identifier for the DataDep.

# Returns
The local file path of the downloaded file.

# Throws
- `ErrorException` if the download fails due to internet or server issues.
"""
function download(url, ID)
    try
        # if data is already on disk
        # we just return the path
        @datadep_str filepath(ID, url)
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
            @datadep_str filepath(ID, url)
        catch
            throw(ErrorException("download failed due to internet and/or server issues"))
        end
    end
end

"""
    get(geo, year, code=nothing, abbrev=nothing; kwargs...)

Retrieve geographic data based on the specified parameters.

# Arguments
- `geo`: The geographic level (e.g., "state", "municipality").
- `year`: The year of the data.
- `code`: The numeric code of the geographic area (optional).
- `abbrev`: The abbreviation of the geographic area (optional).
- `kwargs`: Additional keyword arguments to pass to GeoIO.load.

# Returns
The loaded geographic data.

# Throws
- May throw exceptions from metadatarows, download, or GeoIO.load functions.
"""
function get(geo, year, code=nothing, abbrev=nothing; kwargs...)
    srow = metadatarows(geo, year, code, abbrev)
    url = srow.download_path
    fname = split(url, "/") |> last |> splitext |> first
    ID = "GeoBR_$fname"

    path = download(url, ID)
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
region(; year=2010, kwargs...) = get("regions", year, nothing, nothing, kwargs...)

"""
    country(; year=2010, kwargs...)

Get country data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Country data for the specified year.
"""
country(; year=2010, kwargs...) = get("country", year, nothing, nothing, kwargs...)

"""
    amazon(; year=2012, kwargs...)

Get Amazon data for a given year.

Arguments:
- `year`: Year of the data (default: 2012).
- `kwargs`: Additional keyword arguments.

Returns:
- Amazon data for the specified year.
"""
amazon(; year=2012, kwargs...) = get("amazonia_legal", year, nothing, nothing, kwargs...)

"""
    biomes(; year=2019, kwargs...)

Get biomes data for a given year.

Arguments:
- `year`: Year of the data (default: 2019).
- `kwargs`: Additional keyword arguments.

Returns:
- Biomes data for the specified year.
"""
biomes(; year=2019, kwargs...) = get("biomes", year, nothing, nothing, kwargs...)

"""
    disasterriskarea(; year=2010, kwargs...)

Get disaster risk area data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Disaster risk area data for the specified year.
"""
disasterriskarea(; year=2010, kwargs...) = get("disaster_risk_area", year, nothing, nothing, kwargs...)

"""
    healthfacilities(; year=2013, kwargs...)

Get health facilities data for a given year.

Arguments:
- `year`: Year of the data (default: 2013).
- `kwargs`: Additional keyword arguments.

Returns:
- Health facilities data for the specified year.
"""
healthfacilities(; year=2013, kwargs...) = get("health_facilities", year, nothing, nothing, kwargs...)

"""
    indigenousland(; date=201907, kwargs...)

Get indigenous land data for a given date.

Arguments:
- `date`: Date of the data (default: 201907).
- `kwargs`: Additional keyword arguments.

Returns:
- Indigenous land data for the specified date.
"""
indigenousland(; date=201907, kwargs...) = get("indigenous_land", date, nothing, nothing, kwargs...)

"""
    metroarea(; year=2018, kwargs...)

Get metropolitan area data for a given year.

Arguments:
- `year`: Year of the data (default: 2018).
- `kwargs`: Additional keyword arguments.

Returns:
- Metropolitan area data for the specified year.
"""
metroarea(; year=2018, kwargs...) = get("metropolitan_area", year, nothing, nothing, kwargs...)

"""
    neighborhood(; year=2010, kwargs...)

Get neighborhood data for a given year.

Arguments:
- `year`: Year of the data (default: 2010).
- `kwargs`: Additional keyword arguments.

Returns:
- Neighborhood data for the specified year.
"""
neighborhood(; year=2010, kwargs...) = get("neighborhood", year, nothing, nothing, kwargs...)

"""
    urbanarea(; year=2015, kwargs...)

Get urban area data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Urban area data for the specified year.
"""
urbanarea(; year=2015, kwargs...) = get("urban_area", year, nothing, nothing, kwargs...)

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
municipalseat(; year=2010, kwargs...) = get("municipal_seat", year, nothing, nothing, kwargs...)

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
conservationunits(; date=201909, kwargs...) = get("conservation_units", date, nothing, nothing, kwargs...)

"""
    semiarid(; year=2017, kwargs...)

Get semiarid data for a given year.

Arguments:
- `year`: Year of the data (default: 2017).
- `kwargs`: Additional keyword arguments.

Returns:
- Semiarid data for the specified year.
"""
semiarid(; year=2017, kwargs...) = get("semiarid", year, nothing, nothing, kwargs...)

"""
    schools(; year=2020, kwargs...)

Get schools data for a given year.

Arguments:
- `year`: Year of the data (default: 2020).
- `kwargs`: Additional keyword arguments.

Returns:
- Schools data for the specified year.
"""
schools(; year=2020, kwargs...) = get("schools", year, nothing, nothing, kwargs...)

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

    if startyear ∉ years_available || endyear ∉ years_available
        throw(ArgumentError("Invalid `startyear` or `endyear`. It must be one of the following: $years_available"))
    end

    metadata = metadatarows("amc", startyear, nothing, nothing; all=true)
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
urbanconcentrations(; year=2015, kwargs...) = get("urban_concentrations", year, nothing, nothing, kwargs...)

"""
    poparrangements(; year=2015, kwargs...)

Get population arrangements data for a given year.

Arguments:
- `year`: Year of the data (default: 2015).
- `kwargs`: Additional keyword arguments.

Returns:
- Population arrangements data for the specified year.
"""
poparrangements(; year=2015, kwargs...) = get("pop_arrengements", year, nothing, nothing, kwargs...)

"""
    healthregion(; year=2013, kwargs...)

Get health region data for a given year.

Arguments:
- `year`: Year of the data (default: 2013).
- `kwargs`: Additional keyword arguments.

Returns:
- Health region data for the specified year.
"""
healthregion(; year=2013, kwargs...) = get("health_region", year, nothing, nothing, kwargs...)

function filepath(ID, url)
    filename = split(url, "/") |> last
    ID * "/" * filename
end

end