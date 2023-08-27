import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
from mpl_toolkits.axes_grid1 import make_axes_locatable
from matplotlib import rc


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

x0, y0 = np.random.uniform(0.0001, 0.9999, 2)

xn = [x0, y0]
xn1 = [0, 0]

alpha = 0.67414
beta = 0.5

N = 15000

x = np.zeros(N)
x1 = np.zeros(N)
xerr = np.zeros(N)
n = np.linspace(0, N, N)

for i in range(100):
    xn1 = mapn(xn, alpha, beta, 14)
    xn = xn1
    
    
for i in range(N):
    xn1 = mapn(xn, alpha, beta, 14)
    x[i] = xn[0]
    x1[i] = xn1[0]
    xerr[i] = np.abs((xn1[0] - xn[0]) / xn[0])
    xn = xn1
    
fig, ax = plt.subplots(2, 1)

ax[1].set_xlabel('n', fontsize=16, fontstyle='italic', color='black', fontweight='bold')
ax[0].set_ylabel('x(n+14)', fontsize=16, fontstyle='italic', color='black', fontweight='bold')
ax[1].set_ylabel('xerr', fontsize=16, fontstyle='italic', color='black', fontweight='bold')


fig.suptitle('Mapa n+14', fontsize=16, fontstyle='italic', color='black', fontweight='bold')

ax[0].scatter(n, x, s=0.5, color='black')
ax[1].scatter(n, xerr, s=0.5, color='black')
ax[1].set_yscale('log')

# ax.plot(x, x, color='red', linewidth=1)

plt.show()