# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to load data from the INMET API.
Please check their docstrings for more details:

* [`INMET.stations`](@ref)
* [`INMET.on`](@ref)
"""
module INMET

using Meshes
using Unitful
using GeoTables
using CoordRefSystems

import INMET as INMETData

"""
    INMET.stations(kind=:automatic)

Return INMET stations of given kind. There are two kinds of stations: `:automatic` and `:manual`.
"""
function stations(kind=:automatic)
  df = INMETData.stations(kind)
  georef(df, (:VL_LATITUDE, :VL_LONGITUDE, :VL_ALTITUDE), crs=LatLonAlt)
end

"""
    on(time)

Return data for all automatic stations on a given `time`.
The time can be a `Date` or a `DateTime` object. In the
latter case, minutes and seconds are ignored while the
hour information is retained (data in hourly frequency).
"""
function on(time)
  df = INMETData.on(time)
  georef(df, (:VL_LATITUDE, :VL_LONGITUDE), crs=LatLon)
end

end
