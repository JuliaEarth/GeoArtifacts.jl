# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to (down)load data from the GADM database.

Please check the docstring of each function for more details:

* [`GADM.get`](@ref)
* [`GADM.codes`](@ref)
"""
module GADM

using GeoIO
using GeoTables
using TableTransforms
using Countries
using DataDeps

const CODES = [c.alpha3 for c in all_countries()]

const CODETABLE = [(country=c.name, code=c.alpha3) for c in all_countries()]

const APIVERSIONS = (v"4.1", v"4.0", v"3.6", v"2.8")

"""
    GADM.download(code; version=v"4.1")

Downloads data for country `code` using a given `version` of
the [GADM](https://gadm.org) API.

The available API versions are: 4.1 (default), 4.0, 3.6 and 2.8.
"""
function download(code; version=v"4.1")
  if code ∉ CODES
    throw(ArgumentError("country code \"$code\" not found, please provide a standard ISO 3 country code"))
  end

  if version ∉ APIVERSIONS
    throw(ArgumentError("invalid API version, please check the docstring"))
  end

  route = if version == v"2.8"
    "https://biogeo.ucdavis.edu/data/gadm2.8/gpkg"
  else
    "https://geodata.ucdavis.edu/gadm/gadm$(version.major).$(version.minor)/gpkg"
  end

  filename = if version == v"2.8"
    "$(code)_adm_gpkg.zip"
  elseif version == v"3.6"
    "gadm36_$(code)_gpkg.zip"
  elseif version == v"4.0"
    "gadm40_$(code).gpkg"
  else
    "gadm41_$(code).gpkg"
  end

  ID = "GADM_$code"
  postfetch = version < v"4.0" ? DataDeps.unpack : identity

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
    GADM.get(country, subregions...; depth=0, version=v"4.1", kwargs...)

(Down)load GADM table and convert the result into a `GeoTable`.

The `depth` option can be used to return tables for subregions
at a given depth starting from the given region specification.

The [`GADM.codes`](@ref) function can be used to get a table with all country codes.

## Arguments

* `country`: ISO 3166 Alpha 3 country code;
* `subregions`: Full official names in hierarchial order (provinces, districts, etc.);
* `depth`: Number of levels below the last subregion to search;
* `version`: Version of the GADM API;
* `kwargs`: Keyword arguments passed to `GeoIO.load` function;

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
function get(country, subregions...; depth=0, version=v"4.1", kwargs...)
  # download country data
  path = download(country; version)

  # find GeoPackage file
  files = readdir(path; join=true)
  isgpkg(f) = last(splitext(f)) == ".gpkg"
  gpkg = files[findfirst(isgpkg, files)]

  # select layer by level
  level = length(subregions) + depth
  gtb = GeoIO.load(gpkg; layer=level, kwargs...)

  transform = if !isempty(subregions)
    # fetch query params
    qcols = ["NAME_$(qlevel)" for qlevel in 1:length(subregions)]
    query = zip(qcols, subregions)

    # filter layer by subregions 
    Filter(row -> all(row[col] == val for (col, val) in query))
  else
    Identity()
  end

  gtb |> transform
end

"""
    GADM.codes()

Table with all ISO 3166 Alpha 3 country codes.
"""
codes() = CODETABLE

end
