include("supporting/dppl_models.jl")

@testset "TemperedPG β=1 recovers PG" begin
    n_particles = 10
    n_samples   = 1000

    tpg  = TPGExplorers.TemperedPG(1, n_particles) # β=1
    res  = sample(SplittableRandom(5680), hello_world_model, tpg, n_samples)
    res2 = sample(SplittableRandom(5680), hello_world_model, PG(n_particles), n_samples)
    @test ess(res).nt.ess == ess(res2).nt.ess
end
