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
  end

  @testset "NaturalEarth" begin
    gtb = NaturalEarth.get("admin_0_countries", 110)
    @test gtb.geometry isa GeometrySet
    @test embeddim(gtb.geometry) == 2

    gtb = NaturalEarth.get("110m_admin_0_countries")
    @test gtb.geometry isa GeometrySet
    @test embeddim(gtb.geometry) == 2
  end

  @testset "INMET" begin
    # automatic stations
    gtb = INMET.stations()
    @test all(isequal("Automatica"), gtb.TP_ESTACAO)
    @test gtb.geometry isa PointSet
    @test embeddim(gtb.geometry) == 3

    # manual stations
    gtb = INMET.stations(:manual)
    @test all(isequal("Convencional"), gtb.TP_ESTACAO)
    @test gtb.geometry isa PointSet
    @test embeddim(gtb.geometry) == 3
  end

  @testset "GeoStatsImages" begin
    gtb = GeoStatsImages.get("Strebelle")
    @test names(gtb) == ["facies", "geometry"]
  end
end
