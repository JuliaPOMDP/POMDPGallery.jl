using LaserTag
using POMDPGifs
using QMDP
using Random
using ParticleFilters
using Reel
using POMDPTools
using POMDPs
using TikzPictures
rng = MersenneTwister(7)

m = gen_lasertag(rng=rng, robot_position_known=true)
policy = solve(QMDPSolver(verbose=true), m)
filter = SIRParticleFilter(m, 10000, rng=rng)

hr = HistoryRecorder(max_steps=1000, rng=rng)
hist = simulate(hr, m, policy, filter)


# @show makegif(m, policy, filter, filename="out.gif", rng=rng)

frames = Frames(MIME("image/png"), fps=2)

for (s,b,a,o,r) in eachstep(hist, "s,b,a,o,r")
    push!(frames, LaserTagVis(m, s=s, a=a, o=o, b=b, r=r))
end
tp = TikzPicture(frames)
save(SVG("out.gif"), tp)


#write("out.gif", frames)
