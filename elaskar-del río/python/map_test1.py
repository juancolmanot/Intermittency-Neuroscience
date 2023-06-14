import os
import sys
import numpy as np
import matplotlib.pyplot as plt
import ipdb

if not os.path.exists("datafiles"):
    os.makedirs("datafiles")

# Map definition

def mapa(xn, *args):
    
    alfa = args[0]
    beta = args[1]

    xn1 = 4 * alfa * xn[0] * (1 - xn[0]) + beta * xn[1] * (1 - xn[0])
    yn1 = 4 * alfa * xn[1] * (1 - xn[1]) + beta * xn[0] * (1 - xn[1])

    return [xn1, yn1]

def mapa_n(xn, n, *args):

    alfa = args[0]
    beta = args[1]

    xn_aux = xn
    
    for i in range(n):
        xn1 = mapa(xn_aux, alfa, beta)
        xn_aux = xn1

    return xn1


x_n1 = [0, 0]
x_n = [0.7, 0.9]

N = 1000

n = np.linspace(0, N, N + 1)
x = np.zeros((2, N + 1))
x1 = np.zeros((2, N + 1))

a = 0.674103
b = 0.5

n_map = 14

for i in range(N + 1):
    x_n1 = mapa_n(x_n, n_map, a, b)
    x[:, i] = x_n
    x1[:, i] = x_n1
    x_n = x_n1
    
fig, ax = plt.subplots(2,2)
plt.ylim(0.7, 1)
ax[0, 0].plot(n, x[0, :], linestyle='None', marker='.', markersize=0.5, color='black')
plt.grid()
ax[0, 1].plot(n, x1[0, :], linestyle='None', marker='.', markersize=0.5, color='black')
plt.grid()
ax[1, 0].plot(n, x[1, :], linestyle='None', marker='.', markersize=0.5, color='black')
plt.grid()
ax[1, 1].plot(n, x1[1, :], linestyle='None', marker='.', markersize=0.5, color='black')
plt.grid()


plt.show()