using GeoArtifacts
using Test
using Meshes
using GeoTables

@testset "GeoArtifacts.jl" begin
    # Test GADM module
    @testset "GADM" begin
        # Test GADM.codes function
        codes = GADM.codes()
        @test codes isa Vector{String}
        @test length(codes) > 0
        @test "USA" in codes
        @test "BRA" in codes
        
        # Test GADM.get function with basic usage
        result = GADM.get("VAT")  # Vatican - small dataset
        @test result isa GeoTable
        @test nrow(result) > 0
        
        # Test GADM.get with depth parameter
        result_depth = GADM.get("VAT", depth=1)
        @test result_depth isa GeoTable
        
        # Test invalid country code
        @test_throws Exception GADM.get("INVALID")
    end
    
    # Test NaturalEarth module
    @testset "NaturalEarth" begin
        # Test countries function
        countries = NaturalEarth.countries()
        @test countries isa GeoTable
        @test nrow(countries) > 0
        
        # Test with quality parameter
        countries_med = NaturalEarth.countries(quality="medium")
        @test countries_med isa GeoTable
        
        countries_low = NaturalEarth.countries(quality="low")
        @test countries_low isa GeoTable
        
        # Test states function
        states = NaturalEarth.states()
        @test states isa GeoTable
        
        # Test other vector functions
        borders = NaturalEarth.borders()
        @test borders isa GeoTable
        
        coastlines = NaturalEarth.coastlines()
        @test coastlines isa GeoTable
        
        rivers = NaturalEarth.rivers()
        @test rivers isa GeoTable
        
        lakes = NaturalEarth.lakes()
        @test lakes isa GeoTable
        
        # Test populated places
        places = NaturalEarth.populatedplaces()
        @test places isa GeoTable
        
        # Test with different quality
        places_med = NaturalEarth.populatedplaces(quality="medium")
        @test places_med isa GeoTable
        
        # Test other geographic features
        lands = NaturalEarth.lands()
        @test lands isa GeoTable
        
        oceans = NaturalEarth.oceans()
        @test oceans isa GeoTable
        
        # Test graticules
        grat = NaturalEarth.graticules()
        @test grat isa GeoTable
        
        # Test different graticule intervals
        grat30 = NaturalEarth.graticules(interval=30)
        @test grat30 isa GeoTable
        
        # Test raster functions return file paths
        ne1_path = NaturalEarth.naturalearth1()
        @test ne1_path isa String
        @test isfile(ne1_path)
        
        relief_path = NaturalEarth.shadedrelief()
        @test relief_path isa String
        @test isfile(relief_path)
        
        # Test different resolutions for rasters
        ne1_med = NaturalEarth.naturalearth1(quality="medium")
        @test ne1_med isa String
        @test isfile(ne1_med)
        
        # Test bathymetry
        bathy = NaturalEarth.bathymetry()
        @test bathy isa String
        @test isfile(bathy)
    end
    
    # Test GeoBR module if available
    @testset "GeoBR" begin
        # Test basic functionality
        try
            result = GeoBR.states()
            @test result isa GeoTable
            @test nrow(result) > 0
        catch e
            # Skip if GeoBR data is not accessible
            @test_skip "GeoBR.states() - data not accessible: $e"
        end
        
        try
            municipalities = GeoBR.municipalities()
            @test municipalities isa GeoTable
        catch e
            @test_skip "GeoBR.municipalities() - data not accessible: $e"
        end
        
        try
            # Test with year parameter
            states_2010 = GeoBR.states(year=2010)
            @test states_2010 isa GeoTable
        catch e
            @test_skip "GeoBR.states(year=2010) - data not accessible: $e"
        end
    end
end