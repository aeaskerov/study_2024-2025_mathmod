using DifferentialEquations
using Plots

# Вариант №59
people = Float64[500000, 500000]

# Первый случай
a = [0.0, 3.0]
function syst(du, u, p, t)
    du[1] = -0.45*u[1] - 0.86*u[2] + sin(t+1)
    du[2] = -0.49*u[1] - 0.73*u[2] + cos(t+2)
end

prob = ODEProblem(syst, people, a)
sol = solve(prob, dtmax=0.1)
A1 = [u[1] for u in sol.u]
A2 = [u[2] for u in sol.u]
T = [t for t in sol.t]

plt = plot(title=:"Модель боевых действий - первый случай")
plot!(plt, T, A1, label=:"Численность армии X")
plot!(plt, T, A2, label=:"Численность армии Y", color=:pink)
savefig("3_1.png")

# Второй случай
a = [0.0, 0.0001]
function syst(du, u, p, t)
    du[1] = -0.17*u[1] - 0.65*u[2] + sin(2*t) + 2
    du[2] = -0.31*u[1]*u[2] - 0.28*u[2] + cos(t) + 2  
end

prob = ODEProblem(syst, people, a)
sol = solve(prob, dtmax=0.1)
A1 = [u[1] for u in sol.u]
A2 = [u[2] for u in sol.u]
T = [t for t in sol.t]

plt = plot(title=:"Модель боевых действий - второй случай", legend=:topright)
plot!(plt, T, A1, label=:"Численность армии X")
plot!(plt, T, A2, label=:"Численность армии Y", color=:pink)
savefig("3_2.png")
