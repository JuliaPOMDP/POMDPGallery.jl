# POMDPGallery

[![Build Status](https://travis-ci.org/JuliaPOMDP/POMDPGallery.jl.svg?branch=master)](https://travis-ci.org/JuliaPOMDP/POMDPGallery.jl)

A gallery of models written for [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) with visualizations. You should be able to copy and paste the code below each visualization to run it on your local machine.

For instructions on how to add new models, see [INSTRUCTIONS.md](INSTRUCTIONS.md).

## [ContinuumWorld](https://github.com/zsunberg/ContinuumWorld.jl)

A Continuous 2D MDP domain for demonstrating function approximation value iteration.


![ContinuumWorld](problems/ContinuumWorld/out.gif)

```julia
# XXX remove this if the test works with the manifest
# using Pkg
# Pkg.add(PackageSpec(url="https://github.com/zsunberg/ContinuumWorld.jl"))

using ContinuumWorld
using POMDPs
using GridInterpolations
using Reel
using Plots;        pyplot()

w = CWorld()

nx = 30; ny = 30
grid = RectangleGrid(range(first(w.xlim), stop=last(w.xlim), length=nx), 
                     range(first(w.ylim), stop=last(w.ylim), length=ny))
solver = CWorldSolver(max_iters=30, m=50, grid=grid)
policy = solve(solver, w)

frames = Frames(MIME("image/png"), fps=4)
for i in 1:length(solver.value_hist)
    v = solver.value_hist[i]
    push!(frames, CWorldVis(w, f=s->evaluate(v,s), g=solver.grid, title="Value iteration step $i"))
    print(".")
end
for i in 1:10
    push!(frames, CWorldVis(w, f=s->action_ind(policy, s), g=solver.grid, title="Policy"))
    print(".")
end
println()
write("out.gif", frames)
```


## [LaserTag](LaserTag problem from Somani, A., Ye, N., Hsu, D., & Lee, W. (2013). DESPOT : Online POMDP Planning with Regularization. Advances in Neural Information Processing Systems. Retrieved from http://papers.nips.cc/paper/5189-despot-online-pomdp-planning-with-regularization. Versions with continuous and discrete observations.)

LaserTag problem from Somani, A., Ye, N., Hsu, D., & Lee, W. (2013). DESPOT : Online POMDP Planning with Regularization. Advances in Neural Information Processing Systems. Retrieved from http://papers.nips.cc/paper/5189-despot-online-pomdp-planning-with-regularization. Versions with continuous and discrete observations.


![LaserTag](problems/LaserTag/out.gif)

```julia
using LaserTag
using POMDPGifs
using QMDP
using Random
using ParticleFilters

rng = MersenneTwister(7)

m = gen_lasertag(rng=rng, robot_position_known=true)
policy = solve(QMDPSolver(verbose=true), m)
filter = SIRParticleFilter(m, 10000, rng=rng)

@show makegif(m, policy, filter, filename="out.gif", rng=rng)
```



