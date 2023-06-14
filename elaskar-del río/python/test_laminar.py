import numpy as np
import matplotlib.pyplot as plt
import maps

alpha = 0.77826511
beta = 0.3

N = 20000

xn = [0.7, 0.3]
xn1 = [0, 0]

n_mapa = 14

n = np.linspace(1, N, N + 1)
x_err = np.zeros((2, N + 1))
x = np.zeros((2, N + 1))
x1 = np.zeros((2, N + 1))
for i in range(N + 1):

    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    err_x = abs((xn1[0] - xn[0]) / xn[0])
    err_y = abs((xn1[1] - xn[1]) / xn[1])
    x_err[:, i] = [err_x, err_y]
    x[:, i] = xn
    x1[:, i] = xn1
    xn = xn1

fig, ax = plt.subplots(2,2)
fig.set_size_inches(10,8)
fig.suptitle('Relative error with respect to previous iteration\n alpha = 0.77826511 beta = 0.3')
ax[0, 0].scatter(n, x_err[0, :], s=0.2, color='black')
ax[0, 0].set_xlabel('n')
ax[0, 0].set_ylabel('x_{err}')
ax[0, 0].grid()
ax[0, 0].set_yscale('log')
ax[0, 1].scatter(n, x_err[1, :], s=0.2, color='black')
ax[0, 1].set_xlabel('n')
ax[0, 1].set_ylabel('y_{err}')
ax[0, 1].grid()
ax[0, 1].set_yscale('log')
ax[1, 0].scatter(n, x[0, :], s=0.2, color='black')
ax[1, 0].set_xlabel('n')
ax[1, 0].set_ylabel('x')
ax[1, 0].grid()
ax[1, 1].scatter(n, x[1, :], s=0.2, color='black')
ax[1, 1].set_xlabel('n')
ax[1, 1].set_ylabel('y')
ax[1, 1].grid()

fig.savefig('int-2.pdf')

# plt.show()