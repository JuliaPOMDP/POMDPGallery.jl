using RoombaPOMDPs
using POMDPGifs
using Random
using ParticleFilters
using POMDPPolicies
using ARDESPOT
using POMDPs
using Gtk
using Cairo
using POMDPTools


## Old deprecated Tutorial


# rng = MersenneTwister(2)
# speed = 2.0
# as = vec([RoombaAct(v, om) for v in (0.0, speed), om in (-1.0, 0.0, 1.0)])
# m = RoombaPOMDP(sensor=Bumper(), mdp=RoombaMDP(config=1, aspace=as, contact_pen=-0.1));

# default = FunctionPolicy(x->[speed, 0.0])
# bounds = IndependentBounds(DefaultPolicyLB(default), 10.0, check_terminal=true)
# solver = DESPOTSolver(K=20, T_max=1.0, bounds=bounds, rng=rng)
# planner = solve(solver, m)

# spf = SimpleParticleFilter(m, BumperResampler(5000), rng=rng)
# filter = RoombaParticleFilter(spf, 2.0, 0.5);

# makegif(m, planner, filter, filename="out.gif", rng=rng, max_steps=100, show_progress=true)


## New Tutorial

### Defining Sensor
sensor = Lidar() #Defining a sensor
config = 1 # Different room configuration
problem = RoombaPOMDP(sensor=sensor, mdp=RoombaMDP(config=config));
### Defining ParticleFilters
num_particles = 10000
v_noise_coefficient = 2.0
om_noise_coefficient = 0.5

belief_updater = RoombaParticleFilter(problem, num_particles, v_noise_coefficient, om_noise_coefficient);

mutable struct ToEnd <: Policy
    ts::Int64 # to track the current time-step.
end
# extract goal for heuristic controller
goal_xy = get_goal_xy(problem)

# define a new function that takes in the policy struct and current belief,
# and returns the desired action
function POMDPs.action(p::ToEnd, b::ParticleCollection{RoombaState})
    
    # spin around to localize for the first 25 time-steps
    if p.ts < 25
        p.ts += 1
        return RoombaAct(0.,1.0) # all actions are of type RoombaAct(v,om)
    end
    p.ts += 1

    # after 25 time-steps, we follow a proportional controller to navigate
    # directly to the goal, using the mean belief state
    
    # compute mean belief of a subset of particles
    s = mean(b)
    
    # compute the difference between our current heading and one that would
    # point to the goal
    goal_x, goal_y = goal_xy
    x,y,th = s[1:3]
    ang_to_goal = atan(goal_y - y, goal_x - x)
    del_angle = wrap_to_pi(ang_to_goal - th)
    
    # apply proportional control to compute the turn-rate
    Kprop = 1.0
    om = Kprop * del_angle
    
    # always travel at some fixed velocity
    v = 5.0
    
    return RoombaAct(v, om)
end
# first seed the environment
Random.seed!(2)

# reset the policy
p = ToEnd(0) # here, the argument sets the time-steps elapsed to 0


# run the simulation
c = @GtkCanvas()
win = GtkWindow(c, "Roomba Environment", 600, 600)
for (t, step) in enumerate(stepthrough(problem, p, belief_updater, max_steps=100))
    @guarded draw(c) do widget
        
        # the following lines render the room, the particles, and the roomba
        ctx = getgc(c)
        set_source_rgb(ctx,1,1,1)
        paint(ctx)
        render(ctx, problem, step)
        
        # render some information that can help with debugging
        # here, we render the time-step, the state, and the observation
        move_to(ctx,300,400)
    end
    show(c)
    sleep(0.1) # to slow down the simulation
end