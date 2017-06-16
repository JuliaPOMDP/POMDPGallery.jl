# POMDPGallery

A gallery of models written for [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) with visualizations.

For instructions on how to add new models, see [INSTRUCTIONS.md](INSTRUCTIONS.md).

## [LaserTag](https://github.com/zsunberg/LaserTag.jl)

LaserTag problem from Somani, A., Ye, N., Hsu, D., & Lee, W. (2013). DESPOT : Online POMDP Planning with Regularization. Advances in Neural Information Processing Systems. Retrieved from http://papers.nips.cc/paper/5189-despot-online-pomdp-planning-with-regularization. Versions with continuous and discrete observations.


![LaserTag](problems/LaserTag/out.gif)

```julia
try Pkg.clone("https://github.com/zsunberg/LaserTag.jl.git") end
Pkg.build("LaserTag")

using POMDPs
POMDPs.add("QMDP")

using LaserTag
using POMDPToolbox
using ParticleFilters
using QMDP

using Reel
using ProgressMeter

rng = MersenneTwister(7)
pomdp = gen_lasertag(rng=rng)
policy = solve(QMDPSolver(), pomdp)
filter = SIRParticleFilter(pomdp, 10000)

frames = Frames(MIME("image/png"), fps=2)

print("Simulating and generating LaserTag gif")
for step in stepthrough(pomdp, policy, filter, "a,r,sp,o,bp", rng=rng)
    push!(frames, LaserTagVis(pomdp, step...))
    print('.')
end
println(" Done.")
write("out.gif", frames)
```



