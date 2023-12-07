"""
$(TYPEDEF)

The default `extract_sample` method for DynamicPPL models forces `link!!` on the
`VarInfo` state. The `extractor` hook in Pigeons lets us write our own method.
"""
struct TPGExtractor end

function Pigeons.extract_sample(
    state::DynamicPPL.TypedVarInfo,
    log_potential,
    ::TPGExtractor
    )
    result = DynamicPPL.getall(state)
    push!(result, log_potential(state))
    return result
end
