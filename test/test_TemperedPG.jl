@testset "TemperedPG β=1 recovers PG" begin
    # Turing hello world
    @model function demo(x, y)
        # Assumptions
        σ2 ~ InverseGamma(2, 3)
        σ = sqrt(σ2)
        μ ~ Normal(0, σ)
    
        # Observations
        x ~ Normal(μ, σ)
        y ~ Normal(μ, σ)
    end
    model = demo(-8.0, 8.0)
    N     = 10
    tpg   = TPGExplorers.TemperedPG(1, N) # β=1
    res   = sample(SplittableRandom(5680), model, tpg, 1000)
    res2  = sample(SplittableRandom(5680), model, PG(N), 1000) 
    @test ess(res).nt.ess == ess(res2).nt.ess
end
