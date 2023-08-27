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

def Ffp(x, *params):
    alpha = params[0]
    beta = params[1]
    
    xfp = (4 * alpha * x[0] + beta * x[1]) * (1 - x[0]) - x[0]
    yfp = (4 * alpha * x[1] + beta * x[0]) * (1 - x[1]) - x[1]

    return xfp, yfp

def mapnfp(x, *params):
    alpha = params[0]
    beta = params[1]
    n = params[2]
    
    xi, yi = x[0], x[1]
    
    for i in range(n):
        xn, yn = Ffp([xi, yi], alpha, beta)
        xi, yi = xn, yn
        
    return xi, yi

def Jac(x, *params):
    alpha = params[0]
    beta = params[1]
    
    j = np.zeros((2, 2))
    j[0, 0] = 4 * alpha * (1 - 2 * x[0]) - beta * x[1]
    j[1, 1] = 4 * alpha * (1 - 2 * x[1]) - beta * x[0]
    j[0, 1] = beta * (1 - x[0])
    j[1, 0] = beta * (1 - x[1])
    
    return j


N = 400

x0 = np.linspace(0, 1, N)
y0 = np.linspace(0, 1, N)

X0, Y0 = np.meshgrid(x0, y0)
values = np.zeros_like(X0)

alpha_i = 0.45
beta_i = 0.5

for i in range(X0.shape[0]):
    for j in range(X0.shape[1]):
        icond = [X0[i, j], Y0[i, j]]
        sol = fsolve(Ffp, icond, args=(alpha_i, beta_i))
        jx0 = Jac([sol[0], sol[1]], alpha_i, beta_i)
        lambdas = np.linalg.eig(jx0)[0]
        if np.any(lambdas < -1) or np.any(lambdas > 1):
            values[i, j] = 1
        elif np.all(lambdas < 1) and np.all(lambdas > -1):
            values[i, j] = 0
        
fig, ax = plt.subplots()
cm = ax.pcolormesh(X0, Y0, values, cmap='gray')
# plt.colorbar(cm)

plt.rcParams['font.family'] = 'arial'
plt.rcParams['font.size'] = 14

font_props = {'weight': 'bold', 'size':14}

ax.set_xlabel('x0', **font_props)
ax.set_ylabel('y0', **font_props)
ax.set_title('x* - stability', **font_props)

plt.show()