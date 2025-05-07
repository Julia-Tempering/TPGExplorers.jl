@testset "TPGExplorer" begin
    target = Pigeons.toy_turing_unid_target()
    record = push!(record_default(),round_trip)
    pt = pigeons(
        target   = target,
        explorer = TPGExplorer(n_particles=4), # enough to get traction
        n_chains = 7,
        record   = record,
        n_rounds = 8
    )
    @test n_tempered_restarts(pt) > 0

    @testset "check no vi is linked" begin
        @test !any(DynamicPPL.islinked(r.state, SampleFromPrior()) for r in pt.replicas)
    end

    @testset "check against SliceSampler" begin
        pt_ss = pigeons(target=target, n_chains=7, record=record, n_rounds = 8)
        @test isapprox(stepping_stone(pt), stepping_stone(pt_ss), rtol=0.15)
        @test isapprox(Pigeons.global_barrier(pt), Pigeons.global_barrier(pt_ss), rtol=0.1)
    end
end
