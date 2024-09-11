module GeoBR

using GeoIO

export municipality, state, country, region, readMunicipality

const BASE_URL = "https://raw.githubusercontent.com/ipeaGIT/geobr/master/data-raw"

function municipality(code::Int, year::Int=2010)
    return fetchGeobrData("municipality", code, year)
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
    
    
       # Construct the URL based on the type and code
        # Construct the URL based on the type and code
    url = isnothing(code) ? 
        "$(BASE_URL)/$year/$(type).geojson" : 
        "$(BASE_URL)/$year/$(type)_$(lpad(code, 7, '0')).geojson"
    
    # Attempt to fetch the data
    result = GeoIO.read(url)
    
    # If fetching fails and code is not nothing, try fetching all entities
    if isnothing(result) && !isnothing(code)
        return fetchGeobrData(type, nothing, year)
    end
    
    return result
end
    
    error("Failed to fetch data: File not found for $type, code $code, year $year")
end

end # module