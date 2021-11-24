using POMDPs
using QuickPOMDPs
using POMDPPolicies
using Compose
import Cairo
using POMDPGifs

mountaincar = QuickMDP(
    function (s, a, rng)        
        x, v = s
        vp = clamp(v + a*0.001 + cos(3*x)*-0.0025, -0.07, 0.07)
        xp = x + vp
        if xp > 0.5
            r = 100.0
        else
            r = -1.0
        end
        return (sp=(xp, vp), r=r)
    end,
    actions = [-1., 0., 1.],
    initialstate = Deterministic((-0.5, 0.0)),
    discount = 0.95,
    isterminal = s -> s[1] > 0.5,

    render = function (step)
        cx = step.s[1]
        cy = 0.45*sin(3*cx)+0.5
        car = (context(), circle(cx, cy+0.035, 0.035), fill("blue"))
        track = (context(), line([(x, 0.45*sin(3*x)+0.5) for x in -1.2:0.01:0.6]), stroke("black"))
        goal = (context(), star(0.5, 1.0, -0.035, 5), fill("gold"), stroke("black"))
        bg = (context(), rectangle(), fill("white"))
        ctx = context(0.7, 0.05, 0.6, 0.9, mirror=Mirror(0, 0, 0.5))
        return compose(context(), (ctx, car, track, goal), bg)
    end
)

energize = FunctionPolicy(s->s[2] < 0.0 ? -1.0 : 1.0)
makegif(mountaincar, energize; filename="out.gif", fps=20)
