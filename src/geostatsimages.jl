# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

"""
Provides a single function `GeoStatsImages.get` to load images
from geostatistics literature. Please check its docstring for
more details.
"""
module GeoStatsImages

using GeoStatsImages

"""
    GeoStatsImages.get(name)

Load image with given `name` from geostatistics literature.

# Examples

```julia
GeoStatsImages.get("WalkerLake")
```
"""
get(name) = geostatsimage(name)

end
