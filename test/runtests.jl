using GeoArtifacts
using Meshes
using Test

@testset "GeoArtifacts.jl" begin
  @testset "GeoStatsImages.jl" begin
    gtb = GeoArtifacts.image("Strebelle")
    @test names(gtb) == ["facies", "geometry"]
  end

  @testset "GADM.jl" begin
    gtb = GADM.get("SVN", depth=1)
    @test length(gtb.geometry) == 12

    gtb = GADM.get("QAT", depth=1)
    @test length(gtb.geometry) == 7

    gtb = GADM.get("ISR", depth=1)
    @test length(gtb.geometry) == 7
  end

  @testset "INMET.jl" begin
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

  @testset "NaturalEarth.jl" begin
    gtb = GeoArtifacts.naturalearth("admin_0_countries", 110)
    @test gtb.geometry isa GeometrySet
    @test embeddim(gtb.geometry) == 2

    gtb = GeoArtifacts.naturalearth("110m_admin_0_countries")
    @test gtb.geometry isa GeometrySet
    @test embeddim(gtb.geometry) == 2
  end
end
