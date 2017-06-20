try Pkg.clone("https://github.com/zsunberg/VDPTag.jl") end
using POMDPs
Pkg.build("VDPTag");        using VDPTag
Pkg.add("Reel");            using Reel
Pkg.add("Plots");           using Plots
Pkg.add("GR");              
Pkg.add("ParticleFilters"); using ParticleFilters
Pkg.add("ProgressMeter");   using ProgressMeter
Pkg.add("POMDPToolbox");    using POMDPToolbox
Pkg.add("Distributions");   using Distributions

pomdp = VDPTagPOMDP()
filter = SIRParticleFilter(pomdp, 1000, rng=MersenneTwister(100))

hist = sim(pomdp, updater=filter, max_steps=100, rng=MersenneTwister(1)) do b
    # Policy: move towards predicted target position; if uncertainty > 0.01, take measurement
    agent = first(particles(b)).agent
    target_particles = Array(Float64, 2, n_particles(b))
    for (i, s) in enumerate(particles(b))
        target_particles[:,i] = s.target
    end
    normal_dist = fit(MvNormal, target_particles)
    angle = action(ToNextML(mdp(pomdp)), TagState(agent, mean(normal_dist)))
    a = TagAction(sqrt(det(cov(normal_dist))) > 0.01, angle)
    return a
end

gr()
frames = Frames(MIME("image/png"), fps=2)
@showprogress "Creating gif..." for i in 1:length(hist)
    push!(frames, plot(pomdp, view(hist, 1:i)))
end
write("out.gif", frames)
