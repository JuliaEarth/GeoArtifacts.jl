   module GeoBR

   using HTTP
   using JSON3
   using GeoJSON

   export municipality, state, country, region

   const BASE_URL = "https://raw.githubusercontent.com/ipeaGIT/geobr/master/data-raw"

   function municipality(; code::Union{Int,Nothing}=nothing, year::Int=2010)
       if isnothing(code)
           error("Municipality code is required")
       end
       fetch_geobr_data("municipality", code, year)
   end

   function state(; code::Union{Int,Nothing}=nothing, year::Int=2010)
       fetch_geobr_data("state", code, year)
   end

   function country(; year::Int=2010)
       fetch_geobr_data("country", nothing, year)
   end

   function region(; year::Int=2010)
       fetch_geobr_data("region", nothing, year)
   end

   function fetch_geobr_data(type::String, code::Union{Int,Nothing}, year::Int)
       println("Debug: Entering fetch_geobr_data function")
       println("Debug: type=$type, code=$code, year=$year")
       code_str = isnothing(code) ? "all" : lpad(code, 7, '0')
       base_url = "https://raw.githubusercontent.com/ipeaGIT/geobr/master/data-raw"
       
       # Try different URL patterns
       urls = [
           "$base_url/$year/$(type)_$code_str.geojson",
           "$base_url/$(type)/$year/$(type)_$code_str.geojson",
           "$base_url/$(type)_$code_str.geojson"
       ]
       
       for (i, url) in enumerate(urls)
           println("Debug: Attempting URL $i: $url")
           try
               response = HTTP.get(url)
               println("Debug: Response status for URL $i: $(response.status)")
               if response.status == 200
                   println("Debug: Successful response from URL $i")
                   data = JSON3.read(String(response.body))
                   return GeoJSON.FeatureCollection(data)
               end
           catch e
               println("Debug: Error for URL $i: $e")
           end
       end
       
       error("Failed to fetch data: File not found for $type, code $code, year $year")
   end

   end # module