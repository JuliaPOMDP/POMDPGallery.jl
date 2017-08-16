try Pkg.clone("https://github.com/zsunberg/ContinuumWorld.jl") end

using ContinuumWorld
using POMDPs
using GridInterpolations
Pkg.add("Reel");    using Reel

w = CWorld()

nx = 30; ny = 30
grid = RectangleGrid(linspace(w.xlim..., nx), linspace(w.ylim..., ny))
solver = CWorldSolver(max_iters=50, m=50, grid=grid)
policy = solve(solver, w)

frames = Frames(MIME("image/png"), fps=4)
for i in 1:length(solver.value_hist)
    v = solver.value_hist[i]
    push!(frames, CWorldVis(w, f=s->evaluate(v,s), g=solver.grid, title="Value iteration step $i"))
end
for i in 1:10
    push!(frames, CWorldVis(w, f=s->action_ind(policy, s), g=solver.grid, title="Policy"))
end
write("out.gif", frames)
