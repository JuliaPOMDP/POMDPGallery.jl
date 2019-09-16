using POMDPs
using RockSample 
using SARSOP # load a  POMDP Solver
using POMDPGifs # to make gifs
import Cairo, Fontconfig

pomdp = RockSamplePOMDP(rocks_positions=[(2,3), (4,4), (4,2)], 
                        sensor_efficiency=10.0,
                        discount_factor=0.95, 
                        good_rock_reward = 20.0)

solver = SARSOPSolver(precision=1e-3)

policy = solve(solver, pomdp)

sim = GifSimulator(filename="out.gif", max_steps=30)
simulate(sim, pomdp, policy);