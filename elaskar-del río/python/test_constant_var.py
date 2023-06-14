import os
import sys
import numpy as np
import matplotlib.pyplot as plt
import maps

x_n1 = [0, 0]
x_n = [0.7, 0.9]

N = 10000
n_mapa = 14

n = np.linspace(0, N, N + 1)
x = np.zeros((2, N + 1))
x1 = np.zeros((2, N + 1))
x_err = np.zeros((2, N + 1))

a = 0.674103
b = 0.5

for i in range(N + 1):
    x_n1 = maps.mapa_n(x_n, n_mapa, a, b)
    x[:, i] = x_n
    x1[:, i] = x_n1
    xn_rel = (x_n1[0] - x_n[0]) / x_n[0]
    yn_rel = (x_n1[1] - x_n[1]) / x_n[1]
    x_err[:, i] = [xn_rel, yn_rel]
    x_n = x_n1

fig, ax = plt.subplots(2, 3)
ax[0, 0].plot(x[0, :], x1[0, :], linestyle='None', marker='.', markersize='0.5', color='black')
ax[0, 0].plot(n, n, linestyle='-', linewidth=0.5, color='red')
ax[0, 0].set_xlim([0.2, 0.5])
ax[0, 0].set_ylim([0.2, 0.5])
ax[0, 0].grid()
ax[0, 1].plot(x[1, :], x1[1, :], linestyle='None', marker='.', markersize='0.5', color='black')
ax[0, 1].plot(n, n, linestyle='-', linewidth=0.5, color='red')
ax[0, 1].set_xlim([0.775, 0.935])
ax[0, 1].set_ylim([0.775, 0.935])
ax[0, 1].grid()
ax[1, 0].plot(x[0, :], x1[0, :] / x[0, :], linestyle='None', marker='.', markersize='0.5', color='black')
ax[1, 0].plot(n, np.ones(N + 1), linestyle='-', linewidth=0.5, color='red')
ax[1, 0].set_xlim([0.2, 0.5])
ax[1, 0].set_ylim([0.95, 1.05])
ax[1, 0].grid()
ax[1, 1].plot(x[1, :], x1[1, :] / x[1, :], linestyle='None', marker='.', markersize='0.5', color='black')
ax[1, 1].plot(n, np.ones(N + 1), linestyle='-', linewidth=0.5, color='red')
ax[1, 1].set_xlim([0.775, 0.935])
ax[1, 1].set_ylim([0.99, 1.01])
ax[1, 1].grid()
ax[0, 2].plot(x[0, :], abs(x_err[0, :]), linestyle='None', marker='.', markersize='0.5', color='black')
ax[0, 2].set_xlim([0.2, 0.5])
ax[0, 2].set_yscale('log')
# ax[0, 2].set_ylim([0.95, 1.05])
ax[0, 2].grid()
ax[1, 2].plot(x[1, :], abs(x_err[1, :]), linestyle='None', marker='.', markersize='0.5', color='black')
ax[1, 2].set_xlim([0.775, 0.935])
# ax[1, 2].set_ylim([0.99, 1.01])
ax[1, 2].set_yscale('log')
ax[1, 2].grid()
plt.show()