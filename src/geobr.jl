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

function state(state; year=2010, kwargs...)
    code = isa(state, Number) ? state : nothing
    abbrev = isa(state, AbstractString) ? state : nothing
    get("state", year, code, abbrev, kwargs...)
end

function municipality(muni; year=2010, kwargs...)
    code = isa(muni, Number) ? muni : nothing
    abbrev = isa(muni, AbstractString) ? muni : nothing
    get("municipality", year, code, abbrev; kwargs...)
end

function region(; year=2010, kwargs...)
    get("regions", year, nothing, nothing, kwargs...)
end

function country(; year=2010, kwargs...)
    get("country", year, nothing, nothing, kwargs...)
end

function amazon(; year=2012, kwargs...)
    get("amazonia_legal", year, nothing, nothing, kwargs...)
end

function biomes(; year=2019, kwargs...)
    get("biomes", year, nothing, nothing, kwargs...)
end

function disasterriskarea(; year=2010, kwargs...)
    get("disaster_risk_area", year, nothing, nothing, kwargs...)
end

function healthfacilities(; year=2013, kwargs...)
    get("health_facilities", year, nothing, nothing, kwargs...)
end

function indigenousland(; date=201907, kwargs...)
    get("indigenous_land", date, nothing, nothing, kwargs...)
end

function metroarea(; year=2018, kwargs...)
    get("metropolitan_area", year, nothing, nothing, kwargs...)
end

function neighborhood(; year=2010, kwargs...)
    get("neighborhood", year, nothing, nothing, kwargs...)
end

function urbanarea(; year=2015, kwargs...)
    get("urban_area", year, nothing, nothing, kwargs...)
end

function weightingarea(weighting; year=2010, kwargs...)
    code = isa(weighting, Number) ? weighting : nothing
    abbrev = isa(weighting, AbstractString) ? weighting : nothing
    get("weighting_area", year, code, abbrev, kwargs...)
end

function mesoregion(meso; year=2010, kwargs...)
    code = isa(meso, Number) ? meso : nothing
    abbrev = isa(meso, AbstractString) ? meso : nothing
    get("meso_region", year, code, abbrev, kwargs...)
end

function microregion(micro; year=2010, kwargs...)
    code = isa(micro, Number) ? micro : nothing
    abbrev = isa(micro, AbstractString) ? micro : nothing
    get("micro_region", year, code, abbrev, kwargs...)
end

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

function municipalseat(; year=2010, kwargs...)
    get("municipal_seat", year, nothing, nothing, kwargs...)
end

function censustract(codetract; year=2010, kwargs...)
    code = isa(codetract, Number) ? codetract : nothing
    abbrev = isa(codetract, AbstractString) ? codetract : nothing
    get("census_tract", year, code, abbrev, kwargs...)
end

function statisticalgrid(grid; year=2010, kwargs...)
    code = isa(grid, Number) ? grid : nothing
    abbrev = isa(grid, AbstractString) ? grid : nothing
    get("statistical_grid", year, code, abbrev, kwargs...)
end

function conservationunits(; date=201909, kwargs...)
    get("conservation_units", date, nothing, nothing, kwargs...)
end

function semiarid(; year=2017, kwargs...)
    get("semiarid", year, nothing, nothing, kwargs...)
end

function schools(; year=2020, kwargs...)
    get("schools", year, nothing, nothing, kwargs...)
end

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

function urbanconcentrations(; year=2015, kwargs...)
    get("urban_concentrations", year, nothing, nothing, kwargs...)
end

function poparrangements(; year=2015, kwargs...)
    get("pop_arrengements", year, nothing, nothing, kwargs...)
end

function healthregion(; year=2013, kwargs...)
    get("health_region", year, nothing, nothing, kwargs...)
end

function getdatadep(ID, url)
    filename = split(url, "/") |> last
    ID * "/" * filename
end

end