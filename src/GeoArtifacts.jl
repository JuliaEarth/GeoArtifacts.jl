# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GeoArtifacts

include("gadm.jl")
include("naturalearth.jl")
include("geobr.jl")
include("inmet.jl")

function __init__()
  # make sure datasets are always downloaded
  # without user interaction from DataDeps.jl
  ENV["DATADEPS_ALWAYS_ACCEPT"] = true
end

export GADM, NaturalEarth, GeoBR, INMET

end
