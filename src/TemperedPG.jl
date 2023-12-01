struct HijackedResampler{F<:Real,R}
    β::F
    resampler::R
end
(h::HijackedResampler)(x...)=h.resampler(x...)
function TemperedPG(β::Real, nparticles::Int, outer_resampler_args...)
    outer_resampler = AdvancedPS.ResampleWithESSThreshold(
        HijackedResampler(β, AdvancedPS.DEFAULT_RESAMPLER),
        outer_resampler_args...
    )
    Turing.PG(nparticles, outer_resampler)
end
function DynamicPPL.observe(
    spl::DynamicPPL.Sampler{<:Turing.PG{S,<:AdvancedPS.ResampleWithESSThreshold{<:HijackedResampler}}},
    dist::Distribution,
    value,
    vi
    ) where {S}
    β = spl.alg.resampler.resampler.β
    Libtask.produce(β * logpdf(dist, value))
    return 0, vi
end
