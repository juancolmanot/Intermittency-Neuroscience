import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib.animation import FuncAnimation

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

N = 100

x0 = np.linspace(0, 1, N)
y0 = np.linspace(0, 1, N)

X0, Y0 = np.meshgrid(x0, y0)
valuesx = np.zeros_like(X0)
valuesy = np.zeros_like(X0)

alphas = np.linspace(0.1, 0.9, 100)
beta_i = 0.5

fig, ax = plt.subplots()
cmx = ax.pcolormesh(X0, Y0, valuesx, cmap='viridis')
colorbar = plt.colorbar(cmx)
# plt.rcParams['font.family'] = 'arial'
# plt.rcParams['font.size'] = 14

# font_props = {'weight': 'bold', 'size':14}


def update(frame):
    ax.clear()

    for i in range(X0.shape[0]):
        for j in range(X0.shape[1]):
            icond = [X0[i, j], Y0[i, j]]
            sol = fsolve(Ffp, icond, args=(alphas[frame], beta_i))
            valuesx[i, j] = sol[0]
            # valuesy[i, j] = sol[1]


    # ax.pcolormesh(X0, Y0, valuesx, cmap='viridis')
    cmx = ax.pcolormesh(X0, Y0, valuesx, cmap='viridis')
    # divider = make_axes_locatable(ax)
    # cax = divider.append_axes("right", size="5%", pad=0.05)
    
    # colorbar.ax.clear()
    # plt.colorbar(cmx)
    
    ax.set_xlabel('x0')
    ax.set_ylabel('y0')
    ax.set_title('x*')
    parameter_annotation = f'alpha: {round(alphas[frame], 6)}'

    if hasattr(update, 'annotation'):
        update.annotation.remove()
        
    update.annotation = ax.annotate(parameter_annotation, xy=(1, 1.05), xycoords='axes fraction', ha='center')


    # ax[1].set_xlabel('x0', **font_props)
    # ax[1].set_title('y*', **font_props)


ani = FuncAnimation(fig, update, frames=100, blit=False)

plt.show()