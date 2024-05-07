# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

using GeoIO

import NaturalEarth as NE

"""
    GeoArtifacts.naturalearth(name::String; fix=true, version = v"5.1.2")
    GeoArtifacts.naturalearth(name::String, scale::Int; fix=true, version = v"5.1.2")

Load a NaturalEarth dataset as a `GeoTable`.

The `name` should not include the `ne_` prefix, and if providing a `scale`
should also not include a scale. No suffix should be added.

The option `fix` can be used to fix orientation and degeneracy
issues with polygons.

# Examples

```julia
GeoArtifacts.naturalearth("admin_0_countries", 110)
GeoArtifacts.naturalearth("110m_admin_0_countries")
```
"""
naturalearth(args...; fix=true, kwargs...) = GeoIO.asgeotable(NE.naturalearth(args...; kwargs...), fix)
