include(pigeons_test_mpi_utils_path)
include(pigeons_test_turing_models_path)

@testset "Parallelism invariance" begin
    record = vcat(record_default(), [swap_acceptance_pr, index_process, round_trip, energy_ac1])
    n_mpis = set_n_mpis_to_one_on_windows(2)
    for model in [flip_model_unidentifiable(), flip_mixture()]    
        pigeons(;
            target = TuringLogPotential(model),
            explorer = TPGExplorer(n_particles=4),
            n_rounds = 4,
            n_chains = 4,
            checked_round = 3,
            multithreaded = true,
            record=record,
            checkpoint = true,
            on = ChildProcess(
                    dependencies = [Distributions, DynamicPPL, LinearAlgebra, TPGExplorers, pigeons_test_turing_models_path],
                    n_local_mpi_processes = n_mpis,
                    n_threads = 2,
                    mpiexec_args = extra_mpi_args()))
        @test true
    end
end
