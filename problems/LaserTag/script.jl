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
