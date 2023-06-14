import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation

def F(x, a, eps):

    return a * x**2 + x + eps

def mod_c(a, b):

    a1 = a[0]
    a2 = a[1]
    b1 = b[0]
    b2 = b[1]

    return np.sqrt((b1 - a2)**2 + (b2 - a2)**2)

def c(a, b):
    
    a1 = a[0]
    a2 = a[1]
    b1 = b[0]
    b2 = b[1]

    return [b1 - a1, b2 - a2]

def fixed_point(a, eps):

    xf = np.sqrt(eps / a)

    return [xf, xf]

def tan_point(eps):

    return [0, eps]

N = 200
a = 2
eps = np.linspace(0, 2, N)

fig, ax = plt.subplots(1,1)

x = np.linspace(-1, 1, 100)

def update(frame):

    x1 = list(map(lambda x: F(x, a, eps[frame]), x))

    fp = fixed_point(a, eps[frame])
    tp = tan_point(eps[frame])
    cv = c(tp, fp)

    ax.clear()
    ax.grid()
    ax.plot(x, x1, color='blue', label=f'eps = {round(eps[frame], 2)}')
    ax.plot(x, x, color='black')
    ax.plot(0, 0, 'ro')
    ax.plot(tp[0], tp[1], 'ro', label=f'|c| = {round(eps[frame], 2)}')
    ax.arrow(0, 0, tp[0], tp[1], head_width=0.05, head_length=0.1, fc='k', ec='k')
    ax.set_xlabel('x')
    ax.set_ylabel('F(x)')
    ax.legend()

ani = FuncAnimation(fig, update, frames=N, blit=False)

plt.show()