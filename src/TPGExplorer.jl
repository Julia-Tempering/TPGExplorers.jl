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

# dispatch step on the type of replica.state
Pigeons.step!(explorer::TPGExplorer, replica, shared) = 
    Pigeons.step!(explorer, replica, shared, replica.state)
Pigeons.step!(explorer, replica, shared, state) = 
    throw(ArgumentError("TPGExplorer only supports sampling from TuringLogPotentials"))

# dispatch on the type of shared.tempering
Pigeons.step!(explorer::TPGExplorer, replica, shared, ::DynamicPPL.TypedVarInfo) = 
    run_PG!(explorer::TPGExplorer, replica, shared, shared.tempering)
run_PG!(explorer::TPGExplorer, replica, shared, tempering) = 
    throw(ArgumentError("TPGExplorer only supports NonReversiblePT tempering"))

# main method
function run_PG!(
    explorer::TPGExplorer, replica, shared, ::Pigeons.NonReversiblePT
    )
    vi      = replica.state
    rng     = replica.rng
    model   = shared.tempering.path.target.model
    β       = Pigeons.find_log_potential(replica, shared.tempering, shared).beta
    tpg     = TemperedPG(β, explorer.n_particles, explorer.ess_threshold)
    sampler = DynamicPPL.Sampler(tpg, model)
    state   = last(DynamicPPL.initialstep(rng, model, sampler, vi))
    for _ in 2:explorer.n_refresh
        state = last(AbstractMCMC.step(rng, model, sampler, state))
    end
    error("""TODO: update vi=replica.state with state.vi:
    - replica.state=$(replica.state)
    - state.vi=$(state.vi)
    """)
end
