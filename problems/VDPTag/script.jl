using VDPTag2
using Plots
using Reel
using ProgressMeter
using ParticleFilters
using StaticArrays
using POMDPs
using Random
using POMDPModelTools
using POMDPPolicies
using POMDPModels
using POMDPSimulators

frames = Frames(MIME("image/png"), fps=2)

# pomdp = VDPTagPOMDP()
pomdp = VDPTagPOMDP(mdp=VDPTagMDP(barriers=CardinalBarriers(0.2, 2.8)))
policy = ManageUncertainty(pomdp, 0.01)
# policy = ToNextML(mdp(pomdp))

rng = MersenneTwister(5)

hr = HistoryRecorder(max_steps=30, rng=rng)
filter = SIRParticleFilter(pomdp, 200, rng=rng)
hist = POMDPs.simulate(hr, pomdp, policy, filter)

gr()
@showprogress "Creating gif..." for i in 1:n_steps(hist)
    push!(frames, plot(pomdp, view(hist, 1:i)))
end

filename = string("_vdprun.gif")
write(filename, frames)
println(String(pwd()) * "/" * filename)
