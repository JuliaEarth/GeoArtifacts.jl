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

function extract_metadata(geo, year, code, code_abbrev; return_all=false)
    table = CSV.File(joinpath(@__DIR__, "..", "artifacts", "GeoBR.csv"))

    srows = table |> Filter(row ->
        row.geo == geo &&
            row.year == year &&
            (isnothing(code) || parse(Int, row.code) == code) &&
            (isnothing(code_abbrev) || row.code_abbrev == code_abbrev)
    )

    if isempty(srows)
        throw(ErrorException("No matching rows found for the given parameters"))
    end

    return return_all ? Tables.rows(srows) : Tables.rows(srows) |> first
end

function download(geo, year, code, code_abbrev)
    srow = extract_metadata(geo, year, code, code_abbrev)

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

function get(geo, year, code=nothing, code_abbrev=nothing; kwargs...)
    path = download(geo, year, code, code_abbrev)
    GeoIO.load(path; kwargs...)
end

function state(state; year=2010, kwargs...)
    code = isa(state, Number) ? state : nothing
    code_abbrev = isa(state, AbstractString) ? state : nothing
    gdf = get("state", year, code, code_abbrev, kwargs...)
    return gdf
end

function municipality(muni; year=2010, kwargs...)
    code = isa(muni, Number) ? muni : nothing
    code_abbrev = isa(muni, AbstractString) ? muni : nothing
    gdf = get("municipality", year, code, code_abbrev; kwargs...)
    return gdf
end

function region(; year=2010, kwargs...)
    gdf = get("regions", year, nothing, nothing, kwargs...)
    return gdf
end

function country(; year=2010, kwargs...)
    gdf = get("country", year, nothing, nothing, kwargs...)
    return gdf
end

function amazon(; year=2012, kwargs...)
    gdf = get("amazonia_legal", year, nothing, nothing, kwargs...)
    return gdf
end

function biomes(; year=2019, kwargs...)
    gdf = get("biomes", year, nothing, nothing, kwargs...)
    return gdf
end

function disasterriskarea(; year=2010, kwargs...)
    gdf = get("disaster_risk_area", year, nothing, nothing, kwargs...)
    return gdf
end

function healthfacilities(; year=2013, kwargs...)
    gdf = get("health_facilities", year, nothing, nothing, kwargs...)
    return gdf
end

function indigenousland(; date=201907, kwargs...)
    gdf = get("indigenous_land", date, nothing, nothing, kwargs...)
    return gdf
end

function metroarea(; year=2018, kwargs...)
    gdf = get("metropolitan_area", year, nothing, nothing, kwargs...)
    return gdf
end

function neighborhood(; year=2010, kwargs...)
    gdf = get("neighborhood", year, nothing, nothing, kwargs...)
    return gdf
end

function urbanarea(; year=2015, kwargs...)
    gdf = get("urban_area", year, nothing, nothing, kwargs...)
    return gdf
end

function weightingarea(weighting; year=2010, kwargs...)
    code = isa(weighting, Number) ? weighting : nothing
    code_abbrev = isa(weighting, AbstractString) ? weighting : nothing
    gdf = get("weighting_area", year, code, code_abbrev, kwargs...)
    return gdf
end

function mesoregion(meso; year=2010, kwargs...)
    code = isa(meso, Number) ? meso : nothing
    code_abbrev = isa(meso, AbstractString) ? meso : nothing
    gdf = get("meso_region", year, code, code_abbrev, kwargs...)
    return gdf
end

function microregion(micro; year=2010, kwargs...)
    code = isa(micro, Number) ? micro : nothing
    code_abbrev = isa(micro, AbstractString) ? micro : nothing
    gdf = get("micro_region", year, code, code_abbrev, kwargs...)
    return gdf
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
    gdf = get("municipal_seat", year, nothing, nothing, kwargs...)
    return gdf
end

function censustract(codetract; year=2010, kwargs...)
    code = isa(codetract, Number) ? codetract : nothing
    code_abbrev = isa(codetract, AbstractString) ? codetract : nothing
    gdf = get("census_tract", year, code, code_abbrev, kwargs...)
    return gdf
end

function statisticalgrid(grid; year=2010, kwargs...)
    code = isa(grid, Number) ? grid : nothing
    code_abbrev = isa(grid, AbstractString) ? grid : nothing
    gdf = get("statistical_grid", year, code, code_abbrev, kwargs...)
    return gdf
end

function conservationunits(; date=201909, kwargs...)
    gdf = get("conservation_units", date, nothing, nothing, kwargs...)
    return gdf
end

function semiarid(; year=2017, kwargs...)
    gdf = get("semiarid", year, nothing, nothing, kwargs...)
    return gdf
end

function schools(; year=2020, kwargs...)
    gdf = get("schools", year, nothing, nothing, kwargs...)
    return gdf
end

function comparableareas(; startyear=1970, endyear=2010, kwargs...)
    years_available = [1872, 1900, 1911, 1920, 1933, 1940, 1950, 1960, 1970, 1980, 1991, 2000, 2010]

    if !(startyear in years_available) || !(endyear in years_available)
        throw(ArgumentError("Invalid `startyear` or `endyear`. It must be one of the following: $years_available"))
    end

    metadata = extract_metadata("amc", startyear, nothing, nothing; return_all=true)
    metadata = metadata |> Filter(row -> contains(row.download_path, "$(startyear)_$(endyear)")) |> Tables.rows

    if isempty(metadata)
        throw(ErrorException("No data found for the specified years"))
    end

    first_row = first(metadata)
    gdf = get("amc", first_row.year, nothing, nothing; kwargs...)

    return gdf
end

function urbanconcentrations(; year=2015, kwargs...)
    gdf = get("urban_concentrations", year, nothing, nothing, kwargs...)
    return gdf
end

function poparrangements(; year=2015, kwargs...)
    gdf = get("pop_arrengements", year, nothing, nothing, kwargs...)
    return gdf
end

function healthregion(; year=2013, kwargs...)
    gdf = get("health_region", year, nothing, nothing, kwargs...)
    return gdf
end

function getdatadep(ID, url)
    filename = split(url, "/") |> last
    return ID * "/" * filename
end

end