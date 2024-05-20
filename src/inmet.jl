# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides functions to load data from the INMET API.
Please check their docstrings for more details:

- `INMET.stations`
"""
module INMET

using Meshes
using Unitful
using GeoTables

import INMET as INMETData

"""
    INMET.stations(kind=:automatic)

Return INMET stations of given kind. There are two kinds of stations: `:automatic` and `:manual`.
"""
function stations(kind=:automatic)
  df = INMETData.stations(kind)
  names = propertynames(df)
  cnames = [:VL_LONGITUDE, :VL_LATITUDE, :VL_ALTITUDE]
  fnames = setdiff(names, cnames)
  feats = df[:, fnames]
  coords = ustrip.(df[:, cnames])
  points = map(eachrow(coords)) do row
    x, y, z = row
    Point(x, y, z)
  end
  georef(feats, PointSet(points))
end

end
