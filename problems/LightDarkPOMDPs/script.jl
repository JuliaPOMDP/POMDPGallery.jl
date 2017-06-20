Pkg.add("PyPlot");
try Pkg.clone("https://github.com/zsunberg/LightDarkPOMDPs.jl") end
Pkg.build("LightDarkPOMDPs")
using POMDPs
using LightDarkPOMDPs

Pkg.add("Reel");            using Reel
Pkg.add("POMDPToolbox");    using POMDPToolbox
Pkg.add("ParticleFilters"); using ParticleFilters
Pkg.add("Plots");           using Plots

pomdp = LightDark2D()
filter = SIRParticleFilter(pomdp, 10000, rng=MersenneTwister(5))
policy = FunctionPolicy(b -> -0.3*mean(b))

sim = HistoryRecorder(max_steps=30, rng=MersenneTwister(7))
hist = simulate(sim, pomdp, policy, filter)

pyplot()
frames = Frames(MIME("image/png"), fps=2)
for i in 1:length(hist)
    v = view(hist, 1:i)
    plot(pomdp, xlim=(-3, 10), ylim=(-4,8), aspect_ratio=:equal)
    plot!(v)
    b = belief_hist(v)[end]
    plt = plot!(b)
    push!(frames, plt);
    print(".")
end
println()
write("out.gif", frames);
