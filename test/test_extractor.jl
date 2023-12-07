include("supporting/dppl_models.jl")

@testset "Specialized extractor" begin
    pt = pigeons(
        target   = TuringLogPotential(hello_world_model),
        explorer = TPGExplorer(),
        n_chains = 5,
        record   = [traces],
        n_rounds = 6,
        extractor = TPGExtractor()
    )
    @show sample_array(pt)[1:5]
    @test !any(DynamicPPL.islinked(r.state, SampleFromPrior()) for r in pt.replicas)
end
