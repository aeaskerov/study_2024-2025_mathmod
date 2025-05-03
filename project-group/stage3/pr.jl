using LinearAlgebra
using Plots
using FFTW

# Number of bodies in the oscillatory system
N = 3

# Masses of bodies in the oscillatory system
m = [1, 2, 1]

# Spring stiffness in the oscillatory system
k = [1, 1, 1, 1]

# Initial displacements of bodies at time t = 0
R0 = [-0.2, 0, -0.3]

# Initial velocities of bodies at time t = 0
v0 = [1, -3, 0]

# Calculate matrix elements
omega = zeros(N+1, N)
for alpha in 1:N+1
    for beta in 1:N
        omega[alpha, beta] = k[alpha] / m[beta]
    end
end

# Calculate OMEGA matrix elements according to equation (8)
OMEGA = zeros(N, N)
for i in 1:N
    if i == 1
        OMEGA[i, i] = omega[1, 1] + omega[2, 1]
        OMEGA[1, 2] = -omega[2, 1]
    elseif i < N
        OMEGA[i, i-1] = -omega[i, i]
        OMEGA[i, i] = omega[i, i] + omega[i+1, i]
        OMEGA[i, i+1] = -omega[i+1, i]
    else  # i == N
        OMEGA[i, i-1] = -omega[i, i]
        OMEGA[i, i] = omega[i, i] + omega[i+1, i]
    end
end

# Calculate eigenvalues and eigenvectors of OMEGA matrix
# In Julia, eigen returns values and vectors
eigen_result = eigen(OMEGA)
Sigma = eigen_result.vectors
Teta = diagm(sqrt.(eigen_result.values))  # sqrt of eigenvalues for frequencies

# Calculate SigmaV
SigmaV = zeros(N, N)
for i in 1:N
    for j in 1:N
        SigmaV[j, i] = -Teta[i, i] * Sigma[j, i]
    end
end

# Solve system of equations (18) and (19)
C1 = inv(Sigma) * R0
C2 = inv(SigmaV) * v0

# Calculate vector C coordinates
C = sqrt.(C1.^2 .+ C2.^2)

# Calculate normal oscillation phases according to equations (21), (22)
alpha = zeros(N)
for i in 1:N
    if C[i] == 0
        alpha[i] = 0
    else
        alpha[i] = atan(C2[i], C1[i])  # Используем atan с двумя аргументами (atan2)
        if C1[i] < 0 && C2[i] == 0
            alpha[i] = pi
        elseif C1[i] < 0 && C2[i] < 0
            alpha[i] = alpha[i] - pi
        elseif C1[i] < 0 && C2[i] > 0
            alpha[i] = alpha[i] + pi
        elseif C1[i] > 0 && C2[i] < 0
            alpha[i] = alpha[i] + 2*pi
        end
    end
end

# Number of time grid nodes
N1 = 2^13

# Right boundary of the time interval
Tmax = 80

# Time grid coordinates
t = [(j-1)/(N1-1)*Tmax for j in 1:N1]

# Calculate displacements of bodies at time grid nodes
X = zeros(N, N1)
for j in 1:N1
    s = zeros(N)
    for i in 1:N
        s = s .+ C[i] * Sigma[:, i] .* cos.(Teta[i, i] * t[j] + alpha[i])
    end
    X[:, j] = s
end

# Calculate velocities of bodies at time grid nodes
Xv = zeros(N, N1)
for j in 1:N1
    s = zeros(N)
    for i in 1:N
        s = s .+ C[i] * Sigma[:, i] .* Teta[i, i] .* sin.(Teta[i, i] * t[j] + alpha[i])
    end
    Xv[:, j] = -s
end

# Visualize time-dependent displacements and velocities
# Plot displacements over time
p1 = plot(t, X[1, :], label="Тело 1", linecolor=:black, linestyle=:solid)
plot!(p1, t, X[2, :], label="Тело 2", linecolor=:black, linestyle=:dash)
plot!(p1, t, X[3, :], label="Тело 3", linecolor=:black, linestyle=:dot)
title!(p1, "Смещения от времени")
xlabel!(p1, "Время")
ylabel!(p1, "Смещение")
display(p1)
savefig(p1, "смещения_от_времени.png")  # Сохраняем график в файл

# Plot velocities over time
p2 = plot(t, Xv[1, :], label="Тело 1", linecolor=:black, linestyle=:solid)
plot!(p2, t, Xv[2, :], label="Тело 2", linecolor=:black, linestyle=:dash)
plot!(p2, t, Xv[3, :], label="Тело 3", linecolor=:black, linestyle=:dot)
title!(p2, "Скорости от времени")
xlabel!(p2, "Время")
ylabel!(p2, "Скорость")
display(p2)
savefig(p2, "скорости_от_времени.png")  # Сохраняем график в файл

# Plot phase trajectories for each body
p3 = plot(X[1, :], Xv[1, :], label="Тело 1", title="Фазовая траектория - Тело 1")
xlabel!(p3, "Смещение")
ylabel!(p3, "Скорость")
display(p3)
savefig(p3, "фазовая_траектория_тело1.png")  # Сохраняем график в файл

p4 = plot(X[2, :], Xv[2, :], label="Тело 2", title="Фазовая траектория - Тело 2")
xlabel!(p4, "Смещение")
ylabel!(p4, "Скорость")
display(p4)
savefig(p4, "фазовая_траектория_тело2.png")  # Сохраняем график в файл

p5 = plot(X[3, :], Xv[3, :], label="Тело 3", title="Фазовая траектория - Тело 3")
xlabel!(p5, "Смещение")
ylabel!(p5, "Скорость")
display(p5)
savefig(p5, "фазовая_траектория_тело3.png")  # Сохраняем график в файл

# Calculate displacement spectra using FFT
c1 = fft(X[1, :])
c2 = fft(X[2, :])
c3 = fft(X[3, :])

# Calculate spectral density of displacements
Cm1 = abs.(c1[2:N1÷2]) ./ (N1/2)
Cm2 = abs.(c2[2:N1÷2]) ./ (N1/2)
Cm3 = abs.(c3[2:N1÷2]) ./ (N1/2)

# Calculate frequencies of spectral harmonics
Freq = [(j-1)/Tmax for j in 2:N1÷2]

# Visualize spectral densities of displacements
p6 = plot(Freq, Cm1, label="Тело 1", linecolor=:black, linestyle=:solid, yaxis=:log)
plot!(p6, Freq, 10 .* Cm2, label="Тело 2", linecolor=:black, linestyle=:dash, yaxis=:log)
plot!(p6, Freq, 500 .* Cm3, label="Тело 3", linecolor=:black, linestyle=:dot, yaxis=:log)
xlims!(p6, (0, 2.5))
ylims!(p6, (10^-3, 2000))
title!(p6, "Спектральная плотность")
xlabel!(p6, "Частота")
ylabel!(p6, "Амплитуда")
display(p6)
savefig(p6, "спектральная_плотность.png")  # Сохраняем график в файл

