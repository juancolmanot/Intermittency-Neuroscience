import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
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
    n = int(params[2])
    
    xi, yi = x[0], x[1]
    
    for i in range(n):
        xn, yn = F([xi, yi], alpha, beta)
        xi, yi = xn, yn
        
    return xi, yi

def zerox21(alpha):
    c0 = 3 + 32 * alpha + 64 * alpha**2 - np.sqrt(-15 - 256 * alpha - 1152 * alpha**2 + 4096 * alpha**4)
    c1 = 0.5 * c0
    c2 = 1 + 16 * alpha + 64 * alpha**2
    
    return c1 / c2

def zerox22(alpha):
    c0 = 3 + 32 * alpha + 64 * alpha**2 + np.sqrt(-15 - 256 * alpha - 1152 * alpha**2 + 4096 * alpha**4)
    c1 = 0.5 * c0
    c2 = 1 + 16 * alpha + 64 * alpha**2
    
    return c1 / c2

def zerox23(alpha):
    c0 = -1 + 64 * alpha**2 - np.sqrt(1 +32 * alpha - 128 * alpha**2 - 2048 * alpha**3 + 4096 * alpha**4)
    c1 = 0.5 * c0
    c2 = - 8 * alpha + 64 * alpha**2
    
    return c1 / c2

def zerox24(alpha):
    c0 = -1 + 64 * alpha**2 + np.sqrt(1 +32 * alpha - 128 * alpha**2 - 2048 * alpha**3 + 4096 * alpha**4)
    c1 = 0.5 * c0
    c2 = - 8 * alpha + 64 * alpha**2
    
    return c1 / c2

def zerox13(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = np.sqrt((-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha)))

    return c0 / (c1 + c2)

def zeroy13(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = np.sqrt((-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha)))

    return c0 / (c1 - c2)

def zerox14(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = np.sqrt((-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha)))

    return c0 / (c1 - c2)

def zeroy14(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = np.sqrt((-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha)))

    return c0 / (c1 + c2)
    
alphas = np.linspace(0.1, 0.9, 200)
beta_i = 0.5

N = 30

x = np.linspace(-0.3, 1, N)
y = np.linspace(-0.3, 1, N)

X, Y = np.meshgrid(x, y)

dX, dY = np.zeros_like(X), np.zeros_like(Y)

fig, ax = plt.subplots()


def update(frame):
    ax.clear()
    for i in range(len(x)):
        for j in range(len(y)):
            xn = [X[i, j], Y[i, j]]
            xn1 = mapn(xn, alphas[frame], beta_i, 14)
            dX[i, j] = xn1[0] - xn[0]
            dY[i, j] = xn1[1] - xn[1]
    

    ax.quiver(X, Y, dX, dY, color='b', alpha=0.6, scale=40)
    ax.scatter(0, 0, color='red', s=15, marker='o')
    ax.scatter(1 - 1 / (0.5 + 4 * alphas[frame]), 1 - 1 / (0.5 + 4 * alphas[frame]), color='red', s=15, marker='o')
    ax.scatter(zerox21(alphas[frame]), zerox21(alphas[frame]), color='red', s=15, marker='o')
    ax.scatter(zerox22(alphas[frame]), zerox22(alphas[frame]), color='red', s=15, marker='o')
    ax.scatter(zerox23(alphas[frame]), zerox24(alphas[frame]), color='red', s=15, marker='o')
    ax.scatter(zerox24(alphas[frame]), zerox23(alphas[frame]), color='red', s=15, marker='o')
    ax.scatter(zerox13(alphas[frame]), zeroy13(alphas[frame]), color='red', s=15, marker='o')
    ax.scatter(zerox14(alphas[frame]), zeroy14(alphas[frame]), color='red', s=15, marker='o')
    ax.set_xlabel('x')
    ax.set_ylabel('y')
    ax.set_title('Phase portrait')
    ax.set_xlim(-0.3, 1)
    ax.set_ylim(-0.3, 1)
    parameter_annotation = f'alpha: {round(alphas[frame], 9)}'
    
    if hasattr(update, 'annotation'):
        update.annotation.remove()
        
    update.annotation = ax.annotate(parameter_annotation,  xy=(1, 1.05), xycoords='axes fraction', ha='center')
    
    
ani = FuncAnimation(fig, update, frames=1500, blit=False)

plt.grid()
plt.show()