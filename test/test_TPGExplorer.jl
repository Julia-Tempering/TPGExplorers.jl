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

    @testset "check no vi is linked" begin
        @test !any(DynamicPPL.islinked(r.state, SampleFromPrior()) for r in pt.replicas)
    end

    @testset "check against SliceSampler" begin
        pt_ss = pigeons(target=target, n_chains=7, record=record, n_rounds = 8)
        @test abs(stepping_stone(pt)-stepping_stone(pt_ss)) < 0.3
        @test abs(Pigeons.global_barrier(pt)-Pigeons.global_barrier(pt_ss)) < 0.06
        @test n_tempered_restarts(pt) > n_tempered_restarts(pt_ss)/3
    end
end
