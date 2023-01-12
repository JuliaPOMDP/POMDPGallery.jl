using LaserTag
using POMDPGifs
using QMDP
using Random
using ParticleFilters
using Reel
using POMDPTools


rng = MersenneTwister(7)

m = gen_lasertag(rng=rng, robot_position_known=true)
policy = solve(QMDPSolver(verbose=true), m)
filter = SIRParticleFilter(m, 10000, rng=rng)

hr = HistoryRecorder(max_steps=1000, rng=rng)
hist = simulate(hr, m, policy, filter)


# @show makegif(m, policy, filter, filename="out.gif", rng=rng)

frames = Frames(MIME("image/png"), fps=2)
for i in 1:n_steps(hist)-1
    s = state_hist(hist)[i+1]
    o = observation_hist(hist)[i]
    a = action_hist(hist)[i+1]
    b = belief_hist(hist)[i+1]
    r = reward_hist(hist)[i+1]
    push!(frames, LaserTagVis(p, s=s, a=a, o=o, b=b, r=r))
end

write("out.gif", frames)