# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides a single function `NaturalEarth.get` to download data from the
NaturalEarth database.  Please check its docstring for more details.
"""
module NaturalEarth

using GeoIO

import NaturalEarth as NE

"""
    NaturalEarth.get(name::String; version = v"5.1.2")
    NaturalEarth.get(name::String, scale::Int; version = v"5.1.2")

Load a NaturalEarth dataset as a `GeoTable`.

The `name` should not include the `ne_` prefix, and if providing a `scale`
should also not include a scale. No suffix should be added.

# Examples

```julia
NaturalEarth.get("admin_0_countries", 110)
NaturalEarth.get("110m_admin_0_countries")
```
"""
function get(args...; kwargs...)
  table = NE.naturalearth(args...; kwargs...)
  GeoIO.asgeotable(table)
end

end
