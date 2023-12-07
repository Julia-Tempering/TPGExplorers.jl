# Turing hello world
@model function hello_world(x, y)
    # Assumptions
    σ2 ~ InverseGamma(2, 3)
    σ = sqrt(σ2)
    μ ~ Normal(0, σ)

    # Observations
    x ~ Normal(μ, σ)
    y ~ Normal(μ, σ)
end
hello_world_model = hello_world(-8.0, 8.0)
