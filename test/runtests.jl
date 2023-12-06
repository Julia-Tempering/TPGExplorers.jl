# test against the latest dev version of Pigeons
using Pkg; Pkg.add(name="Pigeons",rev="main")

using Test
using DynamicPPL
using Pigeons
using SplittableRandoms
using Turing

using TPGExplorers

include("test_TemperedPG.jl")
include("test_TPGExplorer.jl")
