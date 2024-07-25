# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides a single function `GADM.get` to download data from the GADM database.
Please check its docstring for more details.
"""
module GADM

using GeoIO
using Meshes
using GeoTables

import GeoInterface as GI
import GADM as GADMData

"""
    GADM.get(country, subregions...; depth=0, fix=true)

(Down)load GADM table and convert the result into a `GeoTable`.

The `depth` option can be used to return tables for subregions
at a given depth starting from the given region specification.

The option `fix` can be used to fix orientation and degeneracy
issues with polygons.
"""
function get(country, subregions...; depth=0, fix=true, kwargs...)
  table = GADMData.get(country, subregions...; depth, kwargs...)
  crs = GI.crs(table)
  GeoIO.asgeotable(table, crs, fix)
end

end
