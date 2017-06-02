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

pomdp = gen_lasertag(rng=MersenneTwister(1))
policy = solve(QMDPSolver(), pomdp)
filter = SIRParticleFilter(pomdp, 10000)
recorder = HistoryRecorder(max_steps=50, rng=MersenneTwister(2))

hist = simulate(recorder, pomdp, policy, filter)

frames = Frames(MIME("image/png"), fps=2)
it = eachstep(hist, "a,r,sp,o,bp")
@showprogress "Creating gif..." for arspobp in it
    push!(frames, LaserTagVis(pomdp, arspobp...))
end
write("out.gif", frames)
