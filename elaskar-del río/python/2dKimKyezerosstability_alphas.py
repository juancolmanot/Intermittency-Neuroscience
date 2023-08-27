import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.animation import FuncAnimation

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


N = 100

x0 = np.linspace(0, 1, N)
y0 = np.linspace(0, 1, N)

X0, Y0 = np.meshgrid(x0, y0)
values = np.zeros_like(X0)

alphas = np.linspace(0.1, 0.9, 100)
beta_i = 0.5

fig, ax = plt.subplots()
cm = ax.pcolormesh(X0, Y0, values, cmap='gray', vmin=0, vmax=1)
colorbar = plt.colorbar(cm)

def update(frame):
    ax.clear()
    for i in range(X0.shape[0]):
        for j in range(X0.shape[1]):
            icond = [X0[i, j], Y0[i, j]]
            sol = fsolve(Ffp, icond, args=(alphas[frame], beta_i))
            jx0 = Jac([sol[0], sol[1]], alphas[frame], beta_i)
            lambdas = np.linalg.eig(jx0)[0]
            if np.any(lambdas < -1) or np.any(lambdas > 1):
                values[i, j] = 1
            elif np.all(lambdas < 1) and np.all(lambdas > -1):
                values[i, j] = 0
        
    ax.pcolormesh(X0, Y0, values, cmap='gray', vmin=0, vmax=1)
    ax.set_xlabel('x0')
    ax.set_ylabel('y0')
    ax.set_title('x* - stability')
    
    parameter_annotation = f'alpha: {round(alphas[frame], 6)}'
    
    if hasattr(update, 'annotation'):
        update.annotation.remove()
        
    update.annotation = ax.annotate(parameter_annotation, xy=(1, 1.05), xycoords='axes fraction', ha='center')


ani = FuncAnimation(fig, update, frames=100, blit=False)

plt.show()