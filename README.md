# GeoArtifacts.jl

[![Build Status](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl)

Julia package for loading geospatial artifacts, e.g. datasets, from different databases.

# Usage

### (Down)loading data from GADM

The `gadm` function (down)loads data from the GADM dataset:

```julia
julia> gadm("BRA", depth = 1)
```

### (Down)loading data from INMET

```julia
julia> inmetstations()
565×13 GeoTable over 565 PointSet{3,Float64}
┌────────────┬────────────┬───────────┬─────────────┬─────────────┬────────────────┬─────────────────┬───────────────────────────
│ TP_ESTACAO │ CD_ESTACAO │ SG_ESTADO │ CD_SITUACAO │ CD_DISTRITO │    CD_OSCAR    │ DT_FIM_OPERACAO │         CD_WSI           ⋯
│  Textual   │  Textual   │  Textual  │   Textual   │   Textual   │    Textual     │     Missing     │         Textual          ⋯
│ [NoUnits]  │ [NoUnits]  │ [NoUnits] │  [NoUnits]  │  [NoUnits]  │   [NoUnits]    │    [NoUnits]    │        [NoUnits]         ⋯
├────────────┼────────────┼───────────┼─────────────┼─────────────┼────────────────┼─────────────────┼───────────────────────────
│ Automatica │    A422    │    BA     │    Pane     │      04     │ 0-2000-0-86765 │     missing     │ 0-76-0-2906907000000408  ⋯
│ Automatica │    A360    │    CE     │  Operante   │      03     │ 0-2000-0-81755 │     missing     │ 0-76-0-2300200000000446  ⋯
│     ⋮      │     ⋮      │     ⋮     │      ⋮      │      ⋮      │       ⋮        │        ⋮        │            ⋮             ⋱
└────────────┴────────────┴───────────┴─────────────┴─────────────┴────────────────┴─────────────────┴───────────────────────────
                                                                                                   5 columns and 563 rows omitted
```

### Loading data from GeoStatsImages.jl

```julia
julia> geostatsimage(identifier)
```

where `identifier` can be any of the strings listed with the command `availableimages()`.

Please read the docstrings for more details.
