# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GeoArtifacts

using GeoStatsImages

include("gadm.jl")
include("inmet.jl")

image(name) = geostatsimage(name)

export GADM, INMET

end
