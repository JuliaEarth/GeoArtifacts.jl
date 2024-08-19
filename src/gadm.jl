# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides a single function `GADM.get` to download data from the GADM database.
Please check its docstring for more details.
"""
module GADM

using GeoIO
using GeoTables
using TableTransforms
using Countries
using DataDeps

const CODES = [c.alpha3 for c in all_countries()]

const API_VERSIONS = ("4.1", "4.0", "3.6", "2.8")

"""
    GADM.codes()

Lis of all ISO 3166 Alpha 3 country codes.
"""
codes() = CODES

"""
    GADM.download(code; version="4.1")

Downloads data for country `code` using DataDeps.jl and returns file path.
The data is provided by the API of the [GADM](https://gadm.org) project.

It is possible to choose the API version by passing it to the
`version` keyword argument as string.
The available API versions are: 4.1 (default), 4.0, 3.6 and 2.8.
"""
function download(code; version="4.1")
  if code ∉ CODES
    throw(ArgumentError("country code \"$code\" not found, please provide a standard ISO 3 country code"))
  end

  if version ∉ API_VERSIONS
    throw(ArgumentError("invalid API version, please use one of these: $(join(API_VERSIONS, ", "))"))
  end

  route = if version == "2.8"
    "https://biogeo.ucdavis.edu/data/gadm2.8/gpkg"
  else
    "https://geodata.ucdavis.edu/gadm/gadm$version/gpkg"
  end

  filename = if version == "2.8"
    "$(code)_adm_gpkg.zip"
  elseif version == "3.6"
    "gadm36_$(code)_gpkg.zip"
  elseif version == "4.0"
    "gadm40_$(code).gpkg"
  else
    "gadm41_$(code).gpkg"
  end

  ID = "GADM_$code"
  postfetch = version ∈ ("3.6", "2.8") ? DataDeps.unpack : identity

  try
    # if data is already on disk
    # we just return the path
    @datadep_str ID
  catch
    # otherwise we register the data
    # and download using DataDeps.jl
    try
      register(DataDep(ID,
        "Geographic data for country $code provided by the https://gadm.org project.",
        "$route/$filename",
        Any,
        post_fetch_method=postfetch
      ))
      @datadep_str ID
    catch
      throw(ErrorException("download failed due to internet and/or server issues"))
    end
  end
end

"""
    GADM.get(country, subregions...; depth=0, version="4.1")


(Down)load GADM table and convert the result into a `GeoTable`.

The `depth` option can be used to return tables for subregions
at a given depth starting from the given region specification.

1. country: ISO 3166 Alpha 3 country code
2. subregions: Full official names in hierarchial order (provinces, districts, etc.)
3. depth: Number of levels below the last subregion to search, default = 0

## Examples

```julia
# geotable of size 1, data of India's borders
gtb = GADM.get("IND")
# geotable of all states and union territories inside India
gtb = GADM.get("IND"; depth=1)
# geotable of all districts inside Uttar Pradesh
gtb = GADM.get("IND", "Uttar Pradesh"; depth=1)
```
"""
function get(country, subregions...; depth=0, kwargs...)
  # download country data
  path = download(country; kwargs...)

  # find GeoPackage file
  files = readdir(path; join=true)
  isgpkg(f) = last(splitext(f)) == ".gpkg"
  gpkg = files[findfirst(isgpkg, files)]

  # select layer by level
  level = length(subregions) + depth
  gtb = GeoIO.load(gpkg; layer=level)

  fgtb = if !isempty(subregions)
    # fetch query params
    qcols = ["NAME_$(qlevel)" for qlevel in 1:length(subregions)]
    query = zip(qcols, subregions)

    # filter layer by subregions 
    gtb |> Filter(row -> all(row[col] == val for (col, val) in query))
  else
    gtb
  end

  fgtb
end

end
