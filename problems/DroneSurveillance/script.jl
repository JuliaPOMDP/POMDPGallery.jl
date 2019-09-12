using DroneSurveillance
using POMDPs
# import a solver from POMDPs.jl e.g. SARSOP
using SARSOP
# for visualization
using POMDPGifs
import Cairo, Fontconfig

pomdp = DroneSurveillancePOMDP() # initialize the problem 
solver = SARSOPSolver(precision=0.1, timeout=10.0) # configure the solver
policy = solve(solver, pomdp) # solve the problem

sim = GifSimulator(filename="out.gif", max_steps=30)
simulate(sim, pomdp, policy);