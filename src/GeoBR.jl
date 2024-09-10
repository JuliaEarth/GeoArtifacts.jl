module GeoBR

using GeoIO

export municipality, state, country, region, readMunicipality

const BASE_URL = "https://raw.githubusercontent.com/ipeaGIT/geobr/master/data-raw"

function municipality(code::Int, year::Int=2010)
    return fetchGeobrData("municipality", code, year)
end

function readMunicipality(codeMuni::Int, year::Int=2010)
    return municipality(codeMuni, year)
end

function state(code::Union{Int,Nothing}, year::Int=2010)
    return fetchGeobrData("state", code, year)
end

function country(year::Int=2010)
    return fetchGeobrData("country", nothing, year)
end

function region(code::Union{Int,Nothing}, year::Int=2010)
    return fetchGeobrData("region", code, year)
end

function fetchGeobrData(type::String, code::Union{Int,Nothing}, year::Int)
    codeStr = isnothing(code) ? "all" : lpad(code, 7, '0')
    
    
    # Try different URL patterns
    urls = [
        "$(BASE_URL)/$year/$(type)_$codeStr.geojson",
        "$(BASE_URL)/$(type)/$year/$(type)_$codeStr.geojson",
        "$(BASE_URL)/$(type)_$codeStr.geojson"
    ]
    
    for url in urls
        try
            return GeoIO.read(url)
        catch
            # Continue to the next URL if there's an error
        end
    end
    
    # If all URLs fail, try fetching data for all entities of the given type
    if !isnothing(code)
        try
            return fetchGeobrData(type, nothing, year)
        catch
            # If that also fails, throw an error
        end
    end
    
    error("Failed to fetch data: File not found for $type, code $code, year $year")
end

end # module