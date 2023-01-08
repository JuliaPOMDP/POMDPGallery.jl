using RoombaPOMDPs
using POMDPGifs
using Random
using ParticleFilters
using POMDPPolicies
using ARDESPOT
using POMDPs

rng = MersenneTwister(2)
speed = 2.0
as = vec([RoombaAct(v, om) for v in (0.0, speed), om in (-1.0, 0.0, 1.0)])
m = RoombaPOMDP(sensor=Bumper(), mdp=RoombaMDP(config=1, aspace=as, contact_pen=-0.1));

default = FunctionPolicy(x->[speed, 0.0])
bounds = IndependentBounds(DefaultPolicyLB(default), 10.0, check_terminal=true)
solver = DESPOTSolver(K=20, T_max=1.0, bounds=bounds, rng=rng)
planner = solve(solver, m)

spf = SimpleParticleFilter(m, BumperResampler(5000), rng=rng)
filter = RoombaParticleFilter(spf, 2.0, 0.5);

makegif(m, planner, filter, filename="out.gif", rng=rng, max_steps=100, show_progress=true)
