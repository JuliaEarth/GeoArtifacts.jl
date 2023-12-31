# GeoArtifacts.jl

[![Build Status](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl)

Julia package for loading geospatial artifacts, e.g. datasets, from different databases.

## Datasets

### GADM

```julia
julia> GADM.get("BRA", depth = 1)
```

### INMET

```julia
julia> INMET.stations()
```

### GeoStatsImages.jl

```julia
julia> GeoArtifacts.image(identifier)
```
