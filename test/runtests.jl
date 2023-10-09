using GeoArtifacts
using Meshes
using Test

@testset "GeoArtifacts.jl" begin
  # @testset "gadm" begin
  #   gtb = gadm("SVN", depth=1, ϵ=0.04)
  #   @test length(gtb.geometry) == 12

  #   gtb = gadm("QAT", depth=1, ϵ=0.04)
  #   @test length(gtb.geometry) == 7

  #   gtb = gadm("ISR", depth=1)
  #   @test length(gtb.geometry) == 7
  # end

  @testset "inmetstations" begin
    # automatic stations
    gtb = inmetstations()
    @test all(isequal("Automatica"), gtb.TP_ESTACAO)
    @test gtb.geometry isa PointSet
    @test embeddim(gtb.geometry) == 3

    # manual stations
    gtb = inmetstations(:manual)
    @test all(isequal("Convencional"), gtb.TP_ESTACAO)
    @test gtb.geometry isa PointSet
    @test embeddim(gtb.geometry) == 3
  end
end
