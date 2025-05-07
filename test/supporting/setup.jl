using Test
using Distributions
using DynamicPPL
using LinearAlgebra
using MPIPreferences
using Pigeons
using SplittableRandoms
using Turing

using TPGExplorers

# path to Pigeons test scripts
pigeons_test_supporting_path = joinpath(dirname(dirname(pathof(Pigeons))),"test","supporting")
pigeons_test_mpi_utils_path = joinpath(pigeons_test_supporting_path, "mpi_test_utils.jl")
pigeons_test_turing_models_path = joinpath(pigeons_test_supporting_path, "turing_models.jl")
