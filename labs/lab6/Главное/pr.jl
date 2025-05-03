using DifferentialEquations, Plots

a = 0.01
b = 0.02
N = 17854
I0 = 199
R0 = 35
S0 = N - I0 - R0
x0 = [S0; I0; R0]
tspan = (0.0, 200.0)

#cлучай, когда I(0)<=I*
function syst(dx, x, p, t)
    dx[1] = 0
    dx[2] = -b*x[2]
    dx[3] = b*x[2]
end

prob = ODEProblem(syst, x0, tspan)
sol = solve(prob, dtmax = 0.05)

S = [x[1] for x in sol.u]
I = [x[2] for x in sol.u]
R = [x[3] for x in sol.u]
T = [t for t in sol.t]

p = plot(T, S, label = "S(t)")
plot!(p, T, I, label = "I(t)", color=:purple)
plot!(p, T, R, label = "R(t)", color=:pink)
savefig("6_1.png")

#cлучай, когда I(0)>I*
function syst(dx, x, p, t)
    dx[1] = -a*x[1]
    dx[2] = a*x[1] - b*x[2]
    dx[3] = b*x[2]
end

prob = ODEProblem(syst, x0, tspan)
sol = solve(prob, dtmax = 0.05)

S = [x[1] for x in sol.u]
I = [x[2] for x in sol.u]
R = [x[3] for x in sol.u]
T = [t for t in sol.t]

p = plot(T, S, label = "S(t)")
plot!(p, T, I, label = "I(t)", color=:purple)
plot!(p, T, R, label = "R(t)", color=:pink)
savefig("6_2.png")
