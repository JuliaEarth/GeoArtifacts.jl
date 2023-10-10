# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GeoArtifacts

using GeoStatsImages

include("gadm.jl")
include("inmet.jl")

export GADM, INMET, GeoStatsImages

end
