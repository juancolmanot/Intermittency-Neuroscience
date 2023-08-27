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

N = 400

x0 = np.linspace(0, 1, N)
y0 = np.linspace(0, 1, N)

X0, Y0 = np.meshgrid(x0, y0)
valuesx = np.zeros_like(X0)
valuesy = np.zeros_like(X0)

alpha_i = 0.67
beta_i = 0.5

for i in range(X0.shape[0]):
    for j in range(X0.shape[1]):
        icond = [X0[i, j], Y0[i, j]]
        sol = fsolve(mapnfp, icond, args=(alpha_i, beta_i, 1))
        valuesx[i, j] = sol[0]
        valuesy[i, j] = sol[1]
        
        
fig, ax = plt.subplots(1, 2)
cmx = ax[0].pcolormesh(X0, Y0, valuesx, cmap='gray')
cmy = ax[1].pcolormesh(X0, Y0, valuesy, cmap='gray')

divider = make_axes_locatable(ax[1])
cax = divider.append_axes("right", size="5%", pad=0.05)

cb = plt.colorbar(cmx, cax=cax)

plt.rcParams['font.family'] = 'italic'
plt.rcParams['font.size'] = 14

font_props = {'weight': 'bold', 'size':14}

ax[0].set_xlabel('x0', **font_props)
ax[0].set_ylabel('y0', **font_props)
ax[0].set_title('x*', **font_props)

ax[1].set_xlabel('x0', **font_props)
ax[1].set_title('y*', **font_props)

fig.suptitle("Bases de atracción" + r' $\alpha$ = 0.9' + r'$\beta$ = 0.5')
plt.show()