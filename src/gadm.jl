# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GADM

using GeoIO
using Meshes
using GeoTables

import GADM as GADMData

"""
    GADM.get(country, subregions...; depth=0, fix=true)

(Down)load GADM table and convert the result into a `GeoTable`.

The `depth` option can be used to return tables for subregions
at a given depth starting from the given region specification.

The option `fix` can be used to fix orientation and degeneracy
issues with polygons.
"""
function get(country, subregions...; depth=0, ϵ=nothing, min=3, max=typemax(Int), maxiter=10, fix=true, kwargs...)
  table = GADMData.get(country, subregions...; depth, kwargs...)
  GeoIO.asgeotable(table, fix)
end

end
