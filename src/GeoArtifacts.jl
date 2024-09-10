# -----------------------------------------------------------------
# Licensed under the MIT License. See LICENSE in the project root.
# -----------------------------------------------------------------

module GeoArtifacts

include("gadm.jl")
include("naturalearth.jl")
include("inmet.jl")
include("GeoBR.jl")
using .GeoBR
   try
       mun = GeoBR.municipality(code=1200179, year=2017)
       println("Success: ", typeof(mun))
   catch e
       println("Error: ", e)
       for (exc, bt) in Base.catch_stack()
           showerror(stdout, exc, bt)
           println()
       end
   end
function __init__()
  # make sure datasets are always downloaded
  # without user interaction from DataDeps.jl
  ENV["DATADEPS_ALWAYS_ACCEPT"] = true
end

export GADM, NaturalEarth, INMET, GeoStatsImages
export GeoBR

end
