# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GeoArtifacts

include("gadm.jl")
include("naturalearth.jl")
include("inmet.jl")
include("geostatsimages.jl")

export GADM, NaturalEarth, INMET, GeoStatsImages

end
