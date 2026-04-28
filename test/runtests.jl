using GeoArtifacts
using Meshes
using Test

@testset "GeoArtifacts.jl" begin
  @testset "GADM" begin
    @test !isempty(GADM.codes())
    @test_throws ArgumentError GADM.download("XXX")
    @test_throws ArgumentError GADM.download("SVN"; version=v"9.9")

    gtb = GADM.get("SVN", depth=1)
    @test length(gtb.geometry) == 12

    gtb = GADM.get("QAT", depth=1)
    @test length(gtb.geometry) == 7

    gtb = GADM.get("ISR", depth=1)
    @test length(gtb.geometry) == 7
  end

  @testset "NaturalEarth" begin
    @test_throws ArgumentError NaturalEarth.download("1:999", "Cultural", "countries")
    @test_throws ArgumentError NaturalEarth.countries("invalid")
    @test_throws ArgumentError NaturalEarth.borders("invalid")
    @test_throws ArgumentError NaturalEarth.states("invalid")
    @test_throws ArgumentError NaturalEarth.counties("invalid")
    @test_throws ArgumentError NaturalEarth.populatedplaces("invalid")
    @test_throws ArgumentError NaturalEarth.roads("invalid")
    @test_throws ArgumentError NaturalEarth.railroads("invalid")
    @test_throws ArgumentError NaturalEarth.lands("invalid")
    @test_throws ArgumentError NaturalEarth.minorislands("invalid")
    @test_throws ArgumentError NaturalEarth.oceans("invalid")
    @test_throws ArgumentError NaturalEarth.rivers("invalid")
    @test_throws ArgumentError NaturalEarth.lakes("invalid")
    @test_throws ArgumentError NaturalEarth.physicallabels("invalid")
    @test_throws ArgumentError NaturalEarth.iceshelves("invalid")
    @test_throws ArgumentError NaturalEarth.bathymetry("invalid")
    @test_throws ArgumentError NaturalEarth.graticules("invalid")
    @test_throws ArgumentError NaturalEarth.hypsometrictints("invalid")
    @test_throws ArgumentError NaturalEarth.hypsometrictints(size="invalid")
    @test_throws ArgumentError NaturalEarth.naturalearth1("invalid")
    @test_throws ArgumentError NaturalEarth.naturalearth1(size="invalid")
    @test_throws ArgumentError NaturalEarth.naturalearth2("invalid")
    @test_throws ArgumentError NaturalEarth.naturalearth2(size="invalid")
    @test_throws ArgumentError NaturalEarth.shadedrelief(size="invalid")
    @test_throws ArgumentError NaturalEarth.grayearth("invalid")
    @test_throws ArgumentError NaturalEarth.grayearth(size="invalid")

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

    gtb = NaturalEarth.airports()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 0

    gtb = NaturalEarth.ports()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 0

    gtb = NaturalEarth.urbanareas()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.urbanareas(scale="1:50")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.usparks()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.timezones()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.coastlines()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1
    gtb = NaturalEarth.coastlines(scale="1:110")
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

    gtb = NaturalEarth.reefs()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

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

    gtb = NaturalEarth.playas()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.playas(scale="1:50")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.glaciatedareas()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.glaciatedareas(scale="1:110")
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

    gtb = NaturalEarth.geographiclines()
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1
    gtb = NaturalEarth.geographiclines(scale="1:110")
    @test gtb.geometry isa GeometrySet
    @test paramdim(gtb.geometry) == 1

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

    gtb = NaturalEarth.oceanbottom()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
    gtb = NaturalEarth.oceanbottom(scale="1:50")
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

    gtb = NaturalEarth.usmanualshadedrelief()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.manualshadedrelief()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2

    gtb = NaturalEarth.prismashadedrelief()
    @test gtb.geometry isa Grid
    @test paramdim(gtb.geometry) == 2
  end

  @testset "GeoBR" begin
    @test_throws ArgumentError GeoBR.download("metadata_1.7.0_gpkg.csv"; version=v"9.9")
    @test_throws ArgumentError GeoBR.comparableareas(startyear=1971)

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

    # these tests are passing locally but are breaking in CI
    # gtb = GeoBR.indigenousland()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.metroarea()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.neighborhood()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.urbanarea()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.weightingarea("RJ")
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.mesoregion("RJ")
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.microregion("RJ")
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.intermediateregion("RJ")
    # @test gtb.geometry isa SubDomain
    # @test paramdim(gtb.geometry) == 2
    # gtb = GeoBR.intermediateregion(3301)
    # @test gtb.geometry isa SubDomain
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.immediateregion("RJ")
    # @test gtb.geometry isa SubDomain
    # @test paramdim(gtb.geometry) == 2
    # gtb = GeoBR.immediateregion(330001)
    # @test gtb.geometry isa SubDomain
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.municipalseat()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 0

    # gtb = GeoBR.censustract("RJ")
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.statisticalgrid("RJ")
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.conservationunits()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.semiarid()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.schools()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 0

    # gtb = GeoBR.comparableareas()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2
    # gtb = GeoBR.comparableareas(startyear=2000, endyear=2010)
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.urbanconcentrations()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.poparrangements()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2

    # gtb = GeoBR.healthregion()
    # @test gtb.geometry isa GeometrySet
    # @test paramdim(gtb.geometry) == 2
  end
end
