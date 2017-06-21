try Pkg.clone("https://github.com/zsunberg/Powseeker.jl") end
using POMDPs
using Powseeker

Pkg.add("Reel");            using Reel
Pkg.add("POMDPToolbox");    using POMDPToolbox
Pkg.add("ParticleFilters"); using ParticleFilters
Pkg.add("Plots");           using Plots
Pkg.add("GR");              

pomdp = PowseekerPOMDP()
filter = SIRParticleFilter(pomdp, 10_000, rng=MersenneTwister(7))
policy = RandomlyCheckGPS(Topout(pomdp, 0.1), 0.2, MersenneTwister(12))

sim = HistoryRecorder(rng=MersenneTwister(94), max_steps=60, show_progress=true)
hist = simulate(sim, pomdp, policy, filter)

gr()
frames = Frames(MIME("image/png"), fps=2)
for i in 1:length(hist)
    v = view(hist, 1:i)
    plot(pomdp, xlim=(-4000,4000), ylim=(-4000,4000), aspect_ratio=:equal)
    plt = plot!(v)
    push!(frames, plt);
    print(".")
end
println()
write("out.gif", frames);
