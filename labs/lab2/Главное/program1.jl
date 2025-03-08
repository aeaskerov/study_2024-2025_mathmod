using DifferentialEquations
using Plots

k = 20.3
n = 5.2
function dr(u, p, t)
    return u/sqrt(n*n - 1)
end 

# Первый случай
r0 = k/(n + 1)
theta = (0, 2*pi)

prob = ODEProblem(dr, r0, theta)
sol = solve(prob, abstol = 1e-8, reltol = 1e-8)
r_ang = [sol.t[rand(1:size(sol.t)[1])] for i in 1:size(sol.t)[1]]

plt = plot(proj=:polar, aspect_ratio=:equal, title="Первый случай задачи о погоне", legend=:outerbottom)
plot!(plt, [r_ang[1], r_ang[2]], [0.0, sol.u[size(sol.u)[1]]], label="Путь лодки")
plot!(plt, sol.t, sol.u, label="Путь катера", color=:pink)
savefig("2_1.png")

# Второй случай
r0 = k/(n - 1)
theta = (-pi, pi)

prob = ODEProblem(dr, r0, theta)
sol = solve(prob, abstol=1e-8, reltol=1e-8)
r_ang = [sol.t[rand(1:size(sol.t)[1])] for i in 1:size(sol.t)[1]]

plt = plot(proj=:polar, aspect_ratio=:equal, title="Второй случай задачи о погоне", legend=:outerbottom)
plot!(plt, [r_ang[1], r_ang[2]], [0.0, sol.u[size(sol.u)[1]]], label="Путь лодки")
plot!(plt, sol.t, sol.u, label="Путь катера", color=:pink)
savefig("2_2.png")
