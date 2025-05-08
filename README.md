# TPGExplorers.jl

[![Build Status](https://github.com/Julia-Tempering/TPGExplorers.jl/actions/workflows/CI.yml/badge.svg?branch=main)](https://github.com/Julia-Tempering/TPGExplorers.jl/actions/workflows/CI.yml?query=branch%3Amain)
[![Coverage](https://codecov.io/gh/Julia-Tempering/TPGExplorers.jl/branch/main/graph/badge.svg)](https://codecov.io/gh/Julia-Tempering/TPGExplorers.jl)

*A Pigeons explorer leveraging the Turing Particle Gibbs sampler*.

## Overview

[Particle Gibbs (PG)](https://doi.org/10.1111/j.1467-9868.2009.00736.x) is an MCMC
algorithm that is able to sample from arbitrary (valid) programs written in any
universal probabilistic programming language (PPL), such as 
[DynamicPPL](https://github.com/TuringLang/DynamicPPL.jl)---the
language used by the Turing project. Indeed, Turing provides a 
[`PG`](https://turinglang.org/docs/usage/sampler-visualisation/index.html#pg)
sampler that implements the algorithm.

However, this generality comes at the expense of poor performance in moderately
complex models. This is due to the fact that PG is, essentially, a smart 
algorithm for selecting samples from the prior that are close to the posterior.
When the prior is far from the posterior, this process can take a long time to
produce an non-trivial effective sample size.

But this is where Pigeons can help: in a Parallel Tempering (PT) run, PG can be
used to sample from the sequence of distributions that interpolate the prior
and the posterior. We expect PG to be able to effectively draw quality
samples from the tempered distributions closer to the prior, which can then be
transported towards the posterior via the PT process.

In order to construct this sequence of distributions from a DynamicPPL program,
it suffices to "inject" an inverse temperature parameter `beta` in `[0,1]` in
the call to compute the log-density of every `~` (tilde) statement 
corresponding to an observation. This turns out to be surprisingly easy within 
DynamicPPL.



## Installation

From the Julia REPL
```julia
] add https://github.com/Julia-Tempering/TPGExplorers.jl.git
```

## Usage

The `TPGExplorer` can be used with any 
[DynamicPPL](https://github.com/TuringLang/DynamicPPL.jl) model. Follow the
instructions in the [Pigeons documentation](https://pigeons.run/stable/input-turing/)
to build a `Pigeons.TuringLogPotential` target from a DynamicPPL model. In the 
following example we use a toy target provided in Pigeons for testing purposes
```julia
using TPGExplorers
using Pigeons

target = Pigeons.toy_turing_unid_target()
pt = pigeons(target = target, explorer = TPGExplorer())
```
By default, PG runs with 10 particles. You can change this using
```julia
pt = pigeons(target = target, explorer = TPGExplorer(n_particles=20))
```
If `traces` are required, you need to use our specialized extractor
```julia
pt = pigeons(
    target    = target,
    explorer  = TPGExplorer(),
    record    = [traces],
    extractor = TPGExtractor()
)
samples = Pigeons.get_sample(pt)
```
