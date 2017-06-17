# POMDPGallery

A gallery of models written for [POMDPs.jl](https://github.com/JuliaPOMDP/POMDPs.jl) with visualizations.

For instructions on how to add new models, see [INSTRUCTIONS.md](INSTRUCTIONS.md).

## [LaserTag](https://github.com/zsunberg/LaserTag.jl)

LaserTag problem from Somani, A., Ye, N., Hsu, D., & Lee, W. (2013). DESPOT : Online POMDP Planning with Regularization. Advances in Neural Information Processing Systems. Retrieved from http://papers.nips.cc/paper/5189-despot-online-pomdp-planning-with-regularization. Versions with continuous and discrete observations.


![LaserTag](problems/LaserTag/out.gif)

```julia
try Pkg.clone("https://github.com/zsunberg/LaserTag.jl.git") end
Pkg.build("LaserTag")
Pkg.add("Reel")

using POMDPs
POMDPs.add("QMDP")

using LaserTag
using POMDPToolbox
using ParticleFilters
using QMDP

using Reel

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


## [VDPTag](https://github.com/zsunberg/VDPTag.jl)

Van Der Pol Tag. The agent tries to catch a target that moves according to the [Van Der Pol equations](https://en.wikipedia.org/wiki/Van_der_Pol_oscillator#Two-dimensional_form). An observation with a noisy bearing to the target can be obtained for a cost, and the agent always moves one unit, but may choose any direction.


![VDPTag](problems/VDPTag/out.gif)

```julia
try Pkg.clone("https://github.com/zsunberg/VDPTag.jl") end
Pkg.build("VDPTag");        using VDPTag
Pkg.add("Reel");            using Reel
Pkg.add("Plots");           using Plots
Pkg.add("GR");              
Pkg.add("ParticleFilters"); using ParticleFilters
Pkg.add("ProgressMeter");   using ProgressMeter
Pkg.add("POMDPToolbox");    using POMDPToolbox

pomdp = VDPTagPOMDP()
filter = SIRParticleFilter(pomdp, 1000, rng=MersenneTwister(100))
policy = ManageUncertainty(pomdp, 0.01)

hr = HistoryRecorder(max_steps=100, rng=MersenneTwister(1), show_progress=true)
hist = simulate(hr, pomdp, policy, filter)

gr()
frames = Frames(MIME("image/png"), fps=2)
@showprogress "Creating gif..." for i in 1:length(hist)
    push!(frames, plot(pomdp, view(hist, 1:i)))
end
write("out.gif", frames)
```



