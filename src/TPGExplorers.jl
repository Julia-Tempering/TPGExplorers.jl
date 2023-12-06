module TPGExplorers

using AbstractMCMC: AbstractMCMC
using AdvancedPS: AdvancedPS
using Distributions: Distribution, logpdf
using DocStringExtensions
using DynamicPPL: DynamicPPL
using Libtask: Libtask
using Turing: Turing
using Pigeons: Pigeons
using Random: AbstractRNG

include("TemperedPG.jl")

export TPGExplorer
include("TPGExplorer.jl")

end # module TPGExplorers
