# A Pigeons explorer leveraging the Turing Particle Gibbs sampler

## Usage

```julia
using TPGExplorers
using Pigeons

target = Pigeons.toy_turing_unid_target()
pigeons(target=target,explorer=TPGExplorer())
```
If `traces` are required, you need to use our specialized extractor
```julia
pigeons(
    target    = target,
    explorer  = TPGExplorer(),
    record    = [traces],
    extractor = TPGExtractor()
)
```