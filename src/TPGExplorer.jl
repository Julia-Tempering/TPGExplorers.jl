"""
$SIGNATURES

An Pigeons explorer that extends the Particle Gibbs sampler implemented in Turing
to sample from tempered versions of a TuringLogPotential. 

In normal circumstance, there should not be a need for tuning,
however the following optional keyword parameters are available:
$FIELDS
"""
@kwdef struct TPGExplorer
    """
    Number of MCMC steps taken within each exploration step.
    """
    n_refresh::Int = 3

    """
    Number of particles to use.
    """
    n_particles::Int = 10

    """
    ESS threshold for resampling
    """
    ess_threshold::Float64 = 0.5
end

# avoid the default Pigeons method which `link`s the vi by default
function Pigeons.initialization(
    inp::Pigeons.Inputs{T, V, E}, rng::AbstractRNG, ::Int
    ) where {T <: Pigeons.TuringLogPotential, V, E <: TPGExplorer}
    DynamicPPL.VarInfo(rng, inp.target.model)
end

# avoid the default Pigeons method which calls the default `initialization` (and thus `link`s)
function Pigeons.sample_iid!(
    log_potential::Pigeons.TuringLogPotential, replica, ::Pigeons.Shared{T,E}
    ) where {T, E <: TPGExplorer}
    replica.state = DynamicPPL.VarInfo(replica.rng, log_potential.model)

end

# dispatch step on the type of replica.state
Pigeons.step!(explorer::TPGExplorer, replica, shared) = 
    Pigeons.step!(explorer, replica, shared, replica.state)
Pigeons.step!(explorer, replica, shared, state) = 
    throw(ArgumentError("TPGExplorer only supports sampling from TuringLogPotentials"))

# dispatch on the type of shared.tempering
Pigeons.step!(explorer::TPGExplorer, replica, shared, ::DynamicPPL.TypedVarInfo) = 
    run_TPG!(explorer::TPGExplorer, replica, shared, shared.tempering)
run_TPG!(explorer::TPGExplorer, replica, shared, tempering) = 
    throw(ArgumentError("TPGExplorer only supports NonReversiblePT tempering"))

# extract shared parameters
function run_TPG!(
    explorer::TPGExplorer, replica, shared, ::Pigeons.NonReversiblePT
    )
    model = shared.tempering.path.target.model
    β     = shared.tempering.schedule.grids[replica.chain]
    run_TPG!(explorer, replica, model, β)
end

# main method
function run_TPG!(explorer::TPGExplorer, replica::Pigeons.Replica, model::DynamicPPL.Model, β::Real)
    rng      = replica.rng
    vi       = replica.state
    tpg      = TemperedPG(β, explorer.n_particles, explorer.ess_threshold)
    sampler  = DynamicPPL.Sampler(tpg)
    pg_state = last(DynamicPPL.initialstep(rng, model, sampler, vi))
    for _ in 2:explorer.n_refresh
        pg_state = last(AbstractMCMC.step(rng, model, sampler, pg_state))
    end
    replica.state = pg_state.vi
    return nothing
end
