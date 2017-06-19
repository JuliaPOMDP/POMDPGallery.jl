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
