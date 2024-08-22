# GeoArtifacts.jl

[![Build Status](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl)

GeoArtifacts.jl provides geospatial artifacts (e.g., datasets) from different sources. It is used in the book
[*Geospatial Data Science with Julia*](https://juliaearth.github.io/geospatial-data-science-with-julia).

## Usage

The package is organized in different submodules, which encapsulate the artifacts.

Please check the docstring of each submodule for more information.

### Artifacts

#### GADM

```
help?> GADM

  Provides a single function GADM.get to download data from the GADM database. Please check its docstring for more details.
```

##### Examples

```
julia> GADM.get("BRA", depth=1)
27×12 GeoTable over 27 GeometrySet
┌─────────────┬─────────────┬─────────────┬────────────────────┬──────────────────────┬─────────────┬──────────────────┬──────────────────┬─────────────┬─────────────┬───────
│    GID_1    │    GID_0    │   COUNTRY   │       NAME_1       │      VARNAME_1       │  NL_NAME_1  │      TYPE_1      │    ENGTYPE_1     │    CC_1     │   HASC_1    │    I ⋯
│ Categorical │ Categorical │ Categorical │    Categorical     │     Categorical      │ Categorical │   Categorical    │   Categorical    │ Categorical │ Categorical │ Cate ⋯
│  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │     [NoUnits]      │      [NoUnits]       │  [NoUnits]  │    [NoUnits]     │    [NoUnits]     │  [NoUnits]  │  [NoUnits]  │  [No ⋯
├─────────────┼─────────────┼─────────────┼────────────────────┼──────────────────────┼─────────────┼──────────────────┼──────────────────┼─────────────┼─────────────┼───────
│   BRA.1_1   │     BRA     │   Brazil    │        Acre        │          NA          │     NA      │      Estado      │      State       │     NA      │    BR.AC    │    B ⋯
│   BRA.2_1   │     BRA     │   Brazil    │      Alagoas       │          NA          │     NA      │      Estado      │      State       │     NA      │    BR.AL    │    B ⋯
│   BRA.3_1   │     BRA     │   Brazil    │       Amapá        │          NA          │     NA      │      Estado      │      State       │     NA      │    BR.AP    │      ⋯
│   BRA.4_1   │     BRA     │   Brazil    │      Amazonas      │       Amazone        │     NA      │      Estado      │      State       │     NA      │    BR.AM    │    B ⋯
│   BRA.5_1   │     BRA     │   Brazil    │       Bahia        │         Ba¡a         │     NA      │      Estado      │      State       │     NA      │    BR.BA    │    B ⋯
│   BRA.6_1   │     BRA     │   Brazil    │       Ceará        │          NA          │     NA      │      Estado      │      State       │     NA      │    BR.CE    │      ⋯
│   BRA.7_1   │     BRA     │   Brazil    │  Distrito Federal  │          NA          │     NA      │ Distrito Federal │ Federal District │     NA      │    BR.DF    │    B ⋯
│   BRA.8_1   │     BRA     │   Brazil    │   Espírito Santo   │    Espiritu Santo    │     NA      │      Estado      │      State       │     NA      │    BR.ES    │      ⋯
│   BRA.9_1   │     BRA     │   Brazil    │       Goiás        │     Goiáz|Goyáz      │     NA      │      Estado      │      State       │     NA      │    BR.GO    │      ⋯
│  BRA.10_1   │     BRA     │   Brazil    │      Maranhão      │ São Luíz de Maranhão │     NA      │      Estado      │      State       │     NA      │    BR.MA    │      ⋯
│  BRA.12_1   │     BRA     │   Brazil    │    Mato Grosso     │     Matto Grosso     │     NA      │      Estado      │      State       │     NA      │    BR.MT    │    B ⋯
│      ⋮      │      ⋮      │      ⋮      │         ⋮          │          ⋮           │      ⋮      │        ⋮         │        ⋮         │      ⋮      │      ⋮      │      ⋱
└─────────────┴─────────────┴─────────────┴────────────────────┴──────────────────────┴─────────────┴──────────────────┴──────────────────┴─────────────┴─────────────┴───────
                                                                                                                                                 2 columns and 16 rows omitted
```

#### NaturalEarth

```
help?> NaturalEarth

  Provides functions to download data from the Natural Earth database:

    •  NaturalEarth.countries

    •  NaturalEarth.borders

    •  NaturalEarth.states

    •  NaturalEarth.counties

    •  NaturalEarth.populatedplaces

    •  NaturalEarth.roads

    •  NaturalEarth.railroads

    •  NaturalEarth.airports

    •  NaturalEarth.ports

    •  NaturalEarth.urbanareas

    •  NaturalEarth.usparks

    •  NaturalEarth.timezones

    •  NaturalEarth.coastlines

    •  NaturalEarth.lands

    •  NaturalEarth.minorislands

    •  NaturalEarth.reefs

    •  NaturalEarth.oceans

    •  NaturalEarth.rivers

    •  NaturalEarth.lakes

    •  NaturalEarth.physicallabels

    •  NaturalEarth.playas

    •  NaturalEarth.glaciatedareas

    •  NaturalEarth.iceshelves

    •  NaturalEarth.bathymetry

    •  NaturalEarth.geographiclines

    •  NaturalEarth.graticules

    •  NaturalEarth.hypsometrictints

    •  NaturalEarth.naturalearth1

    •  NaturalEarth.naturalearth2

    •  NaturalEarth.oceanbottom

    •  NaturalEarth.shadedrelief

    •  NaturalEarth.grayearth

    •  NaturalEarth.usmanualshadedrelief

    •  NaturalEarth.manualshadedrelief

    •  NaturalEarth.prismashadedrelief

  Please check their docstrings for more details.
```

##### Examples

```
julia> NaturalEarth.countries()
258×169 GeoTable over 258 GeometrySet
┌─────────────────┬─────────────┬─────────────┬────────────────┬─────────────┬─────────────┬─────────────┬───────────────────┬─────────────┬──────────────────────────────┬───
│   featurecla    │  scalerank  │  LABELRANK  │   SOVEREIGNT   │   SOV_A3    │  ADM0_DIF   │    LEVEL    │       TYPE        │     TLC     │            ADMIN             │  ⋯
│   Categorical   │ Categorical │ Categorical │  Categorical   │ Categorical │ Categorical │ Categorical │    Categorical    │ Categorical │         Categorical          │  ⋯
│    [NoUnits]    │  [NoUnits]  │  [NoUnits]  │   [NoUnits]    │  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │     [NoUnits]     │  [NoUnits]  │          [NoUnits]           │  ⋯
├─────────────────┼─────────────┼─────────────┼────────────────┼─────────────┼─────────────┼─────────────┼───────────────────┼─────────────┼──────────────────────────────┼───
│ Admin-0 country │      0      │      2      │   Indonesia    │     IDN     │      0      │      2      │ Sovereign country │      1      │          Indonesia           │  ⋯
│ Admin-0 country │      0      │      3      │    Malaysia    │     MYS     │      0      │      2      │ Sovereign country │      1      │           Malaysia           │  ⋯
│ Admin-0 country │      0      │      2      │     Chile      │     CHL     │      0      │      2      │ Sovereign country │      1      │            Chile             │  ⋯
│ Admin-0 country │      0      │      3      │    Bolivia     │     BOL     │      0      │      2      │ Sovereign country │      1      │           Bolivia            │  ⋯
│ Admin-0 country │      0      │      2      │      Peru      │     PER     │      0      │      2      │ Sovereign country │      1      │             Peru             │  ⋯
│ Admin-0 country │      0      │      2      │   Argentina    │     ARG     │      0      │      2      │ Sovereign country │      1      │          Argentina           │  ⋯
│ Admin-0 country │      3      │      3      │ United Kingdom │     GB1     │      1      │      2      │    Dependency     │      1      │ Dhekelia Sovereign Base Area │  ⋯
│ Admin-0 country │      1      │      5      │     Cyprus     │     CYP     │      0      │      2      │ Sovereign country │      1      │            Cyprus            │  ⋯
│ Admin-0 country │      0      │      2      │     India      │     IND     │      0      │      2      │ Sovereign country │      1      │            India             │  ⋯
│ Admin-0 country │      0      │      2      │     China      │     CH1     │      1      │      2      │      Country      │      1      │            China             │  ⋯
│ Admin-0 country │      0      │      4      │     Israel     │     IS1     │      1      │      2      │     Disputed      │      1      │            Israel            │  ⋯
│        ⋮        │      ⋮      │      ⋮      │       ⋮        │      ⋮      │      ⋮      │      ⋮      │         ⋮         │      ⋮      │              ⋮               │  ⋱
└─────────────────┴─────────────┴─────────────┴────────────────┴─────────────┴─────────────┴─────────────┴───────────────────┴─────────────┴──────────────────────────────┴───
                                                                                                                                              159 columns and 247 rows omitted
```

```
julia> NaturalEarth.coastlines()
4133×4 GeoTable over 4133 GeometrySet
┌─────────────┬─────────────┬────────────┬───────────────────────────────┐
│ featurecla  │  scalerank  │  min_zoom  │           geometry            │
│ Categorical │ Categorical │ Continuous │             Multi             │
│  [NoUnits]  │  [NoUnits]  │ [NoUnits]  │ 🖈 GeodeticLatLon{WGS84Latest} │
├─────────────┼─────────────┼────────────┼───────────────────────────────┤
│  Coastline  │      0      │    0.0     │         Multi(1×Rope)         │
│  Coastline  │      0      │    0.0     │         Multi(1×Rope)         │
│  Coastline  │      6      │    5.0     │         Multi(1×Ring)         │
│  Coastline  │      0      │    0.0     │         Multi(1×Rope)         │
│  Coastline  │      0      │    0.0     │         Multi(1×Rope)         │
│  Coastline  │      6      │    5.0     │         Multi(1×Ring)         │
│  Coastline  │      5      │    3.0     │         Multi(1×Ring)         │
│  Coastline  │      5      │    3.0     │         Multi(1×Ring)         │
│  Coastline  │      6      │    6.0     │         Multi(1×Ring)         │
│  Coastline  │      6      │    5.0     │         Multi(1×Ring)         │
│  Coastline  │      6      │    5.0     │         Multi(1×Ring)         │
│      ⋮      │      ⋮      │     ⋮      │               ⋮               │
└─────────────┴─────────────┴────────────┴───────────────────────────────┘
                                                         4122 rows omitted
```

#### INMET

```
help?> INMET

  Provides functions to load data from the INMET API. Please check their docstrings for more details:

    •  INMET.stations
```

##### Examples

```
julia> INMET.stations()
566×13 GeoTable over 566 PointSet{3,Float64}
┌─────────────┬─────────────┬─────────────┬─────────────┬─────────────┬────────────────┬─────────────────┬─────────────────────────┬─────────────┬───────────────────────────────┬────────────────
│ TP_ESTACAO  │ CD_ESTACAO  │  SG_ESTADO  │ CD_SITUACAO │ CD_DISTRITO │    CD_OSCAR    │ DT_FIM_OPERACAO │         CD_WSI          │ SG_ENTIDADE │      DT_INICIO_OPERACAO       │        DC_NOM ⋯
│ Categorical │ Categorical │ Categorical │ Categorical │ Categorical │  Categorical   │     Missing     │       Categorical       │ Categorical │          Categorical          │      Categori ⋯
│  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │   [NoUnits]    │    [NoUnits]    │        [NoUnits]        │  [NoUnits]  │           [NoUnits]           │       [NoUnit ⋯
├─────────────┼─────────────┼─────────────┼─────────────┼─────────────┼────────────────┼─────────────────┼─────────────────────────┼─────────────┼───────────────────────────────┼────────────────
│ Automatica  │    A422     │     BA      │    Pane     │      04     │ 0-2000-0-86765 │     missing     │ 0-76-0-2906907000000408 │    INMET    │ 2008-07-20T21:00:00.000-03:00 │       ABROLHO ⋯
│ Automatica  │    A360     │     CE      │  Operante   │      03     │ 0-2000-0-81755 │     missing     │ 0-76-0-2300200000000446 │    INMET    │ 2009-04-21T21:00:00.000-03:00 │        ACARAU ⋯
│ Automatica  │    A657     │     ES      │  Operante   │      06     │ 0-2000-0-86827 │     missing     │ 0-76-0-3200102000000478 │    INMET    │ 2011-09-23T21:00:00.000-03:00 │    AFONSO CLA ⋯
│ Automatica  │    A908     │     MT      │  Operante   │      09     │ 0-2000-0-86686 │     missing     │ 0-76-0-5100201000000157 │    INMET    │ 2006-12-15T21:00:00.000-03:00 │       AGUA BO ⋯
│ Automatica  │    A756     │     MS      │  Operante   │      07     │ 0-2000-0-86812 │     missing     │ 0-76-0-5000203000000463 │    INMET    │ 2010-08-13T21:00:00.000-03:00 │      AGUA CLA ⋯
│ Automatica  │    A045     │     DF      │  Operante   │      10     │ 0-2000-0-86716 │     missing     │ 0-76-0-5300108000000435 │    INMET    │ 2008-10-02T21:00:00.000-03:00 │    AGUAS EMEN ⋯
│ Automatica  │    A549     │     MG      │  Operante   │      05     │ 0-2000-0-86722 │     missing     │ 0-76-0-3101003000000252 │    INMET    │ 2007-09-08T21:00:00.000-03:00 │    AGUAS VERM ⋯
│ Automatica  │    A534     │     MG      │  Operante   │      05     │ 0-2000-0-86803 │     missing     │ 0-76-0-3101102000000239 │    INMET    │ 2007-08-04T21:00:00.000-03:00 │        AIMORE ⋯
│ Automatica  │    A617     │     ES      │  Operante   │      06     │ 0-2000-0-86828 │     missing     │ 0-76-0-3200201000000125 │    INMET    │ 2006-10-24T21:00:00.000-03:00 │        ALEGRE ⋯
│ Automatica  │    A826     │     RS      │  Operante   │      08     │ 0-2000-0-86975 │     missing     │ 0-76-0-4300406000000113 │    INMET    │ 2006-09-27T21:00:00.000-03:00 │       ALEGRET ⋯
│ Automatica  │    A615     │     ES      │  Operante   │      06     │ 0-2000-0-86829 │     missing     │ 0-76-0-3200300000000135 │    INMET    │ 2006-11-02T21:00:00.000-03:00 │    ALFREDO CH ⋯
│      ⋮      │      ⋮      │      ⋮      │      ⋮      │      ⋮      │       ⋮        │        ⋮        │            ⋮            │      ⋮      │               ⋮               │           ⋮   ⋱
└─────────────┴─────────────┴─────────────┴─────────────┴─────────────┴────────────────┴─────────────────┴─────────────────────────┴─────────────┴───────────────────────────────┴────────────────
                                                                                                                                                                    3 columns and 555 rows omitted
```

### GeoStatsImages

```julia
julia> GeoStatsImages.get("WalkerLake")
160000×2 GeoTable over 400×400 CartesianGrid{2,Float64}
┌────────────┬───────────────────────────────────────────┐
│     Z      │                 geometry                  │
│ Continuous │                Quadrangle                 │
│ [NoUnits]  │                                           │
├────────────┼───────────────────────────────────────────┤
│  0.256614  │  Quadrangle((0.0, 0.0), ..., (0.0, 1.0))  │
│  0.260752  │  Quadrangle((1.0, 0.0), ..., (1.0, 1.0))  │
│  0.26127   │  Quadrangle((2.0, 0.0), ..., (2.0, 1.0))  │
│  0.24452   │  Quadrangle((3.0, 0.0), ..., (3.0, 1.0))  │
│  0.220545  │  Quadrangle((4.0, 0.0), ..., (4.0, 1.0))  │
│     ⋮      │                     ⋮                     │
└────────────┴───────────────────────────────────────────┘
                                       159995 rows omitted
```
