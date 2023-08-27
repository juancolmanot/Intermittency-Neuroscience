import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
from mpl_toolkits.axes_grid1 import make_axes_locatable


def F(x, *params):
    alpha = params[0]
    beta = params[1]
    
    x1 = (4 * alpha * x[0] + beta * x[1]) * (1 - x[0])
    y1 = (4 * alpha * x[1] + beta * x[0]) * (1 - x[1])
    
    return x1, y1

def mapn(x, *params):
    alpha = params[0]
    beta = params[1]
    n = params[2]
    
    xi, yi = x[0], x[1]
    
    for i in range(n):
        xn, yn = F([xi, yi], alpha, beta)
        xi, yi = xn, yn
        
    return xi, yi

N = 200
n_transient = 200
n_steady = 500


alphas = np.linspace(0.1, 0.9, N)
beta_i = 0.5

fig, ax = plt.subplots()

Nicond = 50

x0 = np.linspace(0, 1, Nicond)
y0 = np.linspace(0, 1, Nicond)

X0, Y0 = np.meshgrid(x0, y0)
values = np.zeros_like(X0)

for ix, x0i in enumerate(x0):
    print("ix:", ix)
    for iy, y0i in enumerate(y0):
        x_inf = np.zeros((N, n_steady))
        y_inf = np.zeros((N, n_steady))
        
        for j in range(N):
            xn = [x0i, y0i]
            xn1 = [0, 0]
            
            for i in range(n_transient):
                xn1 = F(xn, alphas[j], beta_i)
                xn = xn1

            for i in range(n_steady):
                xn1 = F(xn, alphas[j], beta_i)
                x_inf[j, i] = xn1[0]
                y_inf[j, i] = xn1[1]
                xn = xn1
        
        if np.any(x_inf > 1):
            values[ix, iy] = 1
        
        else:
            values[ix, iy] = 0

ax.pcolormesh(X0, Y0, values, cmap='gray')
ax.set_xlabel("X0")
ax.set_ylabel("Y0")          

plt.show()