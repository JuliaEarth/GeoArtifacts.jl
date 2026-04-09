using GeoArtifacts
using Meshes
using Test

@testset "GeoArtifacts.jl" begin
  @testset "GADM" begin
    gtb = GADM.get("SVN", depth=1)
    @test length(gtb.geometry) == 12

    gtb = GADM.get("QAT", depth=1)
    @test length(gtb.geometry) == 7

    gtb = GADM.get("ISR", depth=1)
    @test length(gtb.geometry) == 7

    # GADM.codes — table of all country codes
    codes = GADM.codes()
    @test length(codes) > 200
    @test "USA" in [row.code for row in codes]
    @test "BRA" in [row.code for row in codes]

    # GADM.get — default depth
    gtb = GADM.get("BRA")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GADM.get("USA")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    # GADM.get — subregion filtering
    gtb = GADM.get("BRA", depth=1)
    @test length(gtb.geometry) > 0

    gtb = GADM.get("FRA", depth=1)
    @test length(gtb.geometry) > 0

    # GADM.get — version parameter
    gtb = GADM.get("BRA"; version=v"4.1")
    @test gtb.geometry isa GeometrySet

    gtb = GADM.get("BRA"; version=v"4.0")
    @test gtb.geometry isa GeometrySet

    # GADM.get — error: invalid country code
    @test_throws ArgumentError GADM.get("XXX")
    @test_throws ArgumentError GADM.get("invalid")

    # GADM.get — error: invalid version
    @test_throws ArgumentError GADM.get("BRA"; version=v"9.9")
    @test_throws ArgumentError GADM.get("BRA"; version=v"1.0")
  end

  @testset "NaturalEarth" begin
    gtb = NaturalEarth.countries()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.countries(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.borders()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1
    gtb = NaturalEarth.borders(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

    gtb = NaturalEarth.states()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.states(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.counties()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.populatedplaces()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 0
    gtb = NaturalEarth.populatedplaces(scale="1:50")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 0

    gtb = NaturalEarth.roads()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

    gtb = NaturalEarth.railroads()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

    gtb = NaturalEarth.lands()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.lands(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.minorislands()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.oceans()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.oceans(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.rivers()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1
    gtb = NaturalEarth.rivers(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

    gtb = NaturalEarth.lakes()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.lakes(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.physicallabels()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.physicallabels(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.iceshelves()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.iceshelves(scale="1:50")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.bathymetry()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.graticules()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1
    gtb = NaturalEarth.graticules(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

    gtb = NaturalEarth.hypsometrictints()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.hypsometrictints(scale="1:50")
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.naturalearth1()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.naturalearth1(scale="1:50")
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.naturalearth2()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.naturalearth2(scale="1:50")
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.shadedrelief()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.shadedrelief(scale="1:50")
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.grayearth()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.grayearth(scale="1:50")
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    # Country-specific variants
    gtb = NaturalEarth.countries(variant="BRA")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.countries(variant="USA")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.countries(variant="CHN")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.countries(variant="RUS")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    # Variant: nolakes
    gtb = NaturalEarth.countries(variant="nolakes")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.states(variant="nolakes")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.counties(variant="nolakes")
    @test gtb.geometry isa GeometrySet

    # Variant: ranks
    gtb = NaturalEarth.states(variant="ranks")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.lands(variant="ranks")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.oceans(variant="ranks")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.rivers(variant="ranks")
    @test gtb.geometry isa GeometrySet

    # Variant: borders
    gtb = NaturalEarth.states(variant="borders")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.iceshelves(variant="borders")
    @test gtb.geometry isa GeometrySet

    # Variant: simple
    gtb = NaturalEarth.populatedplaces(variant="simple")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 0

    # Variant: region-specific
    gtb = NaturalEarth.rivers(variant="australia")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.lakes(variant="australia")
    @test gtb.geometry isa GeometrySet

    # Variant: mapunit
    gtb = NaturalEarth.borders(variant="mapunit")
    @test gtb.geometry isa GeometrySet

    # Variant: coastline
    gtb = NaturalEarth.minorislands(variant="coastline")
    @test gtb.geometry isa GeometrySet

    # Variant: historic / pluvial
    gtb = NaturalEarth.lakes(variant="historic")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.lakes(variant="pluvial")
    @test gtb.geometry isa GeometrySet

    # Variant: points
    gtb = NaturalEarth.physicallabels(variant="points")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.physicallabels(variant="elevationpoints")
    @test gtb.geometry isa GeometrySet

    # Variant: boundingbox / 15
    gtb = NaturalEarth.graticules(variant="boundingbox")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.graticules(variant="15")
    @test gtb.geometry isa GeometrySet

    # Variant: depth-specific
    gtb = NaturalEarth.bathymetry(variant="5000")
    @test gtb.geometry isa GeometrySet
    gtb = NaturalEarth.bathymetry(variant="0")
    @test gtb.geometry isa GeometrySet

    # Variant: size (grid functions)
    gtb = NaturalEarth.hypsometrictints(size="small")
    @test gtb.geometry isa Grid
    gtb = NaturalEarth.naturalearth1(variant="relief")
    @test gtb.geometry isa Grid
    gtb = NaturalEarth.naturalearth1(variant="water")
    @test gtb.geometry isa Grid
    gtb = NaturalEarth.grayearth(variant="relief")
    @test gtb.geometry isa Grid
    gtb = NaturalEarth.grayearth(variant="flatwater")
    @test gtb.geometry isa Grid
    gtb = NaturalEarth.shadedrelief(size="small")
    @test gtb.geometry isa Grid

    # Invalid scale — ArgumentError
    @test_throws ArgumentError NaturalEarth.download("1:99", "countries", "default")
    @test_throws ArgumentError NaturalEarth.countries(scale="1:99")

    # Invalid variant — ArgumentError
    @test_throws ArgumentError NaturalEarth.countries(variant="nonexistent_variant_xyz")
  end

  @testset "GeoBR" begin
    gtb = GeoBR.state()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = GeoBR.state("RJ")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.municipality()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = GeoBR.municipality("RJ")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.region()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.country()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.amazon()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.biomes()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.disasterriskarea()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.healthfacilities()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 0

    # GeoBR.state — numeric code
    gtb = GeoBR.state(33)
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    # GeoBR.intermediateregion — all three filter modes
    gtb = GeoBR.intermediateregion("RJ")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.intermediateregion(33)
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.intermediateregion(3301)
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    # GeoBR.immediateregion — all three filter modes
    gtb = GeoBR.immediateregion("RJ")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.immediateregion(33)
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.immediateregion(330001)
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    # GeoBR.comparableareas — default and valid custom years
    gtb = GeoBR.comparableareas()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = GeoBR.comparableareas(startyear=2000, endyear=2010)
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    # GeoBR.comparableareas — invalid years (ArgumentError)
    @test_throws ArgumentError GeoBR.comparableareas(startyear=2005, endyear=2010)
    @test_throws ArgumentError GeoBR.comparableareas(startyear=1800, endyear=2010)
    @test_throws ArgumentError GeoBR.comparableareas(startyear=1970, endyear=2099)

    # GeoBR.download — invalid version
    @test_throws ArgumentError GeoBR.download("http://example.com/test.parquet"; version=v"9.9.9")
  end
end
