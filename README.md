# A Pigeons explorer leveraging the Turing Particle Gibbs sampler

## Usage

```julia
using TPGExplorers
using Pigeons

# test
target = Pigeons.toy_turing_unid_target()
pigeons(target=target,explorer=TPGExplorer())
```