# GeoArtifacts.jl

[![Build Status](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/JuliaEarth/GeoArtifacts.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/JuliaEarth/GeoArtifacts.jl)

GeoArtifacts.jl provides geospatial artifacts (e.g., datasets) from different sources
in a universal representation described in the book
[*Geospatial Data Science with Julia*](https://juliaearth.github.io/geospatial-data-science-with-julia).

## Usage

The package is organized in different submodules, which encapsulate the artifacts.
Downloads are performed in the host machine upon demand, during the first call to
functions of a submodule. Please check the docstring of each submodule for more
information.

### Artifacts

#### [GADM](https://gadm.org)

```
help?> GADM
  Provides functions to (down)load data from the GADM database.

  Please check the docstring of each function for more details:

    •  GADM.get

    •  GADM.codes

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

#### [NaturalEarth](https://www.naturalearthdata.com)

```
help?> NaturalEarth

  Provides functions to (down)load data from the Natural Earth database.

  Please check the docstring of each function for more details:

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

#### [GeoBR](https://ipeagit.github.io/geobr)

```
help?> GeoBR

  Provides functions to (down)load data from the GeoBR database.

  Please check the docstring of each function for more details:

    •  GeoBR.state

    •  GeoBR.municipality

    •  GeoBR.region

    •  GeoBR.country

    •  GeoBR.amazon

    •  GeoBR.biomes

    •  GeoBR.disasterriskarea

    •  GeoBR.healthfacilities

    •  GeoBR.indigenousland

    •  GeoBR.metroarea

    •  GeoBR.neighborhood

    •  GeoBR.urbanarea

    •  GeoBR.weightingarea

    •  GeoBR.mesoregion

    •  GeoBR.microregion

    •  GeoBR.intermediateregion

    •  GeoBR.immediateregion

    •  GeoBR.municipalseat

    •  GeoBR.censustract

    •  GeoBR.statisticalgrid

    •  GeoBR.conservationunits

    •  GeoBR.semiarid

    •  GeoBR.schools

    •  GeoBR.comparableareas

    •  GeoBR.urbanconcentrations

    •  GeoBR.poparrangements

    •  GeoBR.healthregion

julia> GeoBR.state()
29×2 GeoTable over 29 GeometrySet
┌───────────────────────────────────────────────┬──────────────────────────────┐
│                  name_state                   │           geometry           │
│                  Categorical                  │         MultiPolygon         │
│                   [NoUnits]                   │ 🖈 GeodeticLatLon{SIRGAS2000} │
├───────────────────────────────────────────────┼──────────────────────────────┤
│                     Acre                      │      Multi(1×PolyArea)       │
│                    Alagoas                    │      Multi(1×PolyArea)       │
│                     Amapá                     │      Multi(1×PolyArea)       │
│                   Amazonas                    │      Multi(1×PolyArea)       │
│                     Bahia                     │      Multi(10×PolyArea)      │
│                     Ceará                     │      Multi(1×PolyArea)       │
│ Distrito estadual de Fernando de Noronha (PE) │      Multi(1×PolyArea)       │
│               Distrito Federal                │      Multi(1×PolyArea)       │
│                Espírito Santo                 │      Multi(8×PolyArea)       │
│                     Goiás                     │      Multi(1×PolyArea)       │
│                 Litígio PI/CE                 │      Multi(3×PolyArea)       │
│                   Maranhão                    │      Multi(51×PolyArea)      │
│                  Mato Grosso                  │      Multi(1×PolyArea)       │
│              Mato Grosso do Sul               │      Multi(1×PolyArea)       │
│                 Minas Gerais                  │      Multi(1×PolyArea)       │
│                     Pará                      │      Multi(17×PolyArea)      │
│                    Paraíba                    │      Multi(2×PolyArea)       │
│                    Paraná                     │      Multi(1×PolyArea)       │
│                  Pernambuco                   │      Multi(1×PolyArea)       │
│                     Piauí                     │      Multi(1×PolyArea)       │
│                Rio de Janeiro                 │      Multi(82×PolyArea)      │
│              Rio Grande do Norte              │      Multi(1×PolyArea)       │
│               Rio Grande do Sul               │      Multi(1×PolyArea)       │
│                   Rondônia                    │      Multi(1×PolyArea)       │
│                    Roraima                    │      Multi(1×PolyArea)       │
│                Santa Catarina                 │      Multi(2×PolyArea)       │
│                   São Paulo                   │      Multi(37×PolyArea)      │
│                    Sergipe                    │      Multi(1×PolyArea)       │
│                   Tocantins                   │      Multi(1×PolyArea)       │
└───────────────────────────────────────────────┴──────────────────────────────┘

julia> GeoBR.state("RJ")
1×6 GeoTable over 1 GeometrySet
┌────────────┬──────────────┬────────────────┬─────────────┬─────────────┬──────────────────────────────┐
│ code_state │ abbrev_state │   name_state   │ code_region │ name_region │           geometry           │
│ Continuous │ Categorical  │  Categorical   │ Continuous  │ Categorical │         MultiPolygon         │
│ [NoUnits]  │  [NoUnits]   │   [NoUnits]    │  [NoUnits]  │  [NoUnits]  │ 🖈 GeodeticLatLon{SIRGAS2000} │
├────────────┼──────────────┼────────────────┼─────────────┼─────────────┼──────────────────────────────┤
│    33.0    │      RJ      │ Rio De Janeiro │     3.0     │   Sudeste   │     Multi(577×PolyArea)      │
└────────────┴──────────────┴────────────────┴─────────────┴─────────────┴──────────────────────────────┘
```

#### [INMET](https://mapas.inmet.gov.br)

```
help?> INMET

  Provides functions to (down)load data from the INMET API.

  Please check the docstring of each function for more details:

    •  INMET.stations

    •  INMET.on

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

julia> INMET.on(Date(2024,1,1))
603×23 GeoTable over 603 PointSet
┌─────────────┬─────────────┬─────────────┬────────────────────────────────┬─────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬────────────┬───────
│ CD_ESTACAO  │     UF      │ HR_MEDICAO  │            DC_NOME             │ DT_MEDICAO  │  TEM_INS   │  TEM_MIN   │  TEM_MAX   │  UMD_INS   │  UMD_MIN   │  UMD_MAX   │  PRE ⋯
│ Categorical │ Categorical │ Categorical │          Categorical           │ Categorical │ Continuous │ Continuous │ Continuous │ Continuous │ Continuous │ Continuous │ Cont ⋯
│  [NoUnits]  │  [NoUnits]  │  [NoUnits]  │           [NoUnits]            │  [NoUnits]  │    [°C]    │    [°C]    │    [°C]    │    [%]     │    [%]     │    [%]     │   [m ⋯
├─────────────┼─────────────┼─────────────┼────────────────────────────────┼─────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼────────────┼───────
│    A001     │     DF      │    0000     │            BRASILIA            │ 2024-01-01  │  22.0 °C   │  21.8 °C   │  22.6 °C   │   79.0 %   │   77.0 %   │   81.0 %   │ 885. ⋯
│    A002     │     GO      │    0000     │            GOIÂNIA             │ 2024-01-01  │  23.6 °C   │  23.6 °C   │  24.4 °C   │   78.0 %   │   77.0 %   │   79.0 %   │ 930. ⋯
│    A003     │     GO      │    0000     │           MORRINHOS            │ 2024-01-01  │  23.9 °C   │  23.9 °C   │  25.7 °C   │   78.0 %   │   71.0 %   │   78.0 %   │ 927. ⋯
│    A004     │     GO      │    0000     │          NIQUELANDIA           │ 2024-01-01  │  missing   │  missing   │  missing   │  missing   │  missing   │  missing   │  mis ⋯
│    A005     │     GO      │    0000     │           PORANGATU            │ 2024-01-01  │  26.4 °C   │  26.4 °C   │  27.3 °C   │   84.0 %   │   74.0 %   │   84.0 %   │ 970. ⋯
│    A006     │     GO      │    0000     │             CRIXÁS             │ 2024-01-01  │  missing   │  missing   │  missing   │  missing   │  missing   │  missing   │  mis ⋯
│    A007     │     GO      │    0000     │             FAINA              │ 2024-01-01  │  missing   │  missing   │  missing   │  missing   │  missing   │  missing   │  mis ⋯
│    A008     │     DF      │    0000     │ FACULDADE DA TERRA DE BRASÍLIA │ 2024-01-01  │  missing   │  missing   │  missing   │  missing   │  missing   │  missing   │  mis ⋯
│      ⋮      │      ⋮      │      ⋮      │               ⋮                │      ⋮      │     ⋮      │     ⋮      │     ⋮      │     ⋮      │     ⋮      │     ⋮      │      ⋱
└─────────────┴─────────────┴─────────────┴────────────────────────────────┴─────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴────────────┴───────
                                                                                                                                                12 columns and 595 rows omitted
```
