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
using DataDeps

"""
    GADM.isvalidcode(str)

Tells whether or not `str` is a valid
ISO 3166 Alpha 3 country code. Valid
code examples are "IND", "USA", "BRA".
"""
isvalidcode(str) = match(r"\b[A-Z]{3}\b", str) !== nothing

const API_VERSIONS = ("4.1", "4.0", "3.6", "2.8")

"""
    GADM.download(country; version="4.1")

Downloads data for `country` using DataDeps.jl and returns path.
The data is provided by the API of the [GADM](https://gadm.org) project.

It is possible to choose the API version by passing it to the
`version` keyword argument as string.
The available API versions are: 4.1 (default), 4.0, 3.6 and 2.8.
"""
function download(country; version="4.1")
  if version ∉ API_VERSIONS
    throw(ArgumentError("invalid API version"))
  end

  route = if version == "2.8"
    "https://biogeo.ucdavis.edu/data/gadm2.8/gpkg"
  else
    "https://geodata.ucdavis.edu/gadm/gadm$version/gpkg"
  end

  filename = if version == "2.8"
    "$(country)_adm_gpkg.zip"
  elseif version == "3.6"
    "gadm36_$(country)_gpkg.zip"
  elseif version == "4.0"
    "gadm40_$(country).gpkg"
  else
    "gadm41_$(country).gpkg"
  end

  ID = "GADM_$country"
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
        "Geographic data for country $country provided by the https://gadm.org project.",
        "$route/$filename",
        Any,
        post_fetch_method=postfetch
      ))
      @datadep_str ID
    catch e
      if e isa HTTP.StatusError && e.status == 404
        throw(ArgumentError("country code \"$country\" not found, please provide a standard ISO 3 country code"))
      else
        throw(ErrorException("download failed due to internet and/or server issues"))
      end
    end
  end
end

"""
    GADM.dataread(path; kwargs...)

Read data in `path` returned by [`GADM.download`](@ref).
"""
function dataread(path; kwargs...)
  files = readdir(path; join=true)

  isgpkg(f) = last(splitext(f)) == ".gpkg"
  gpkg = files[findfirst(isgpkg, files)]

  GeoIO.load(gpkg; kwargs...)
end

"""
    GADM.getdataset(country; layer=0, version="4.1")

Downloads and extracts dataset of the given country code.
"""
function getdataset(country; layer=0, kwargs...)
  isvalidcode(country) || throw(ArgumentError("please provide standard ISO 3 country codes"))
  dataread(download(country; kwargs...); layer)
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
  # select layer by level
  level = length(subregions) + depth
  gtb = getdataset(country; layer=level, kwargs...)

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
