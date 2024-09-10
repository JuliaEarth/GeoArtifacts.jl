# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GeoArtifacts

include("gadm.jl")
include("naturalearth.jl")
include("inmet.jl")
include("geobr.jl")

function __init__()
  # make sure datasets are always downloaded
  # without user interaction from DataDeps.jl
  ENV["DATADEPS_ALWAYS_ACCEPT"] = true
end

export GADM, NaturalEarth, INMET, GeoBR

end
