import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
from mpl_toolkits.axes_grid1 import make_axes_locatable

def zero12(alpha):
    c0 = 0.5 + 4 * alpha
    
    return 1 - 1 / c0


def zerox13(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 + c3)
    else:
        return 9

def zeroy13(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 - c3)
    else:
        return 9

def zerox14(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 - c3)
    else:
        return 9

def zeroy14(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 + c3)
    else:
        return 9

N_alpha = 500
alphas = np.linspace(0, 1, N_alpha)
beta_i = 0.5

zeros2 = np.zeros((2, N_alpha))
zeros3 = np.zeros((2, N_alpha))
zeros4 = np.zeros((2, N_alpha))

for i, alpha in enumerate(alphas):
    zeros2[:, i] = zero12(alpha)
    zeros3[0, i] = zerox13(alpha)
    zeros3[1, i] = zeroy13(alpha)
    zeros4[0, i] = zerox14(alpha)
    zeros4[1, i] = zeroy14(alpha)

fig, ax = plt.subplots(2, 1)

ax[0].scatter(alphas, np.zeros(N_alpha), s=2, label='x1*')
ax[0].scatter(alphas, zeros2[0], s=2, label='x2*')
ax[0].scatter(alphas, zeros3[0], s=2, label='x3*')
ax[0].scatter(alphas, zeros4[0], s=2, label='x4*')

ax[1].scatter(alphas, np.zeros(N_alpha), s=2, label='y1*')
ax[1].scatter(alphas, zeros2[1], s=2, label='y2*')
ax[1].scatter(alphas, zeros3[1], s=2, label='y3*')
ax[1].scatter(alphas, zeros4[1], s=2, label='y4*')

ax[0].set_title("Componentes de los puntos fijos", fontsize=14, fontstyle='italic', color='black')
ax[0].set_ylabel("x*", fontsize=12, fontstyle='italic', color='black', fontweight='bold')
#ax[0].set_xlabel("alpha", fontsize=12, fontstyle='italic', color='black', fontweight='bold')
ax[1].set_ylabel("y*", fontsize=12, fontstyle='italic', color='black', fontweight='bold')
ax[1].set_xlabel("alpha", fontsize=12, fontstyle='italic', color='black', fontweight='bold')

ax[0].legend(fontsize=10)
ax[1].legend(fontsize=10)

ax[0].set_xlim(0, 1)
ax[0].set_ylim(-0.5, 1)

ax[1].set_xlim(0, 1)
ax[1].set_ylim(-0.5, 1)

fig2, ax2 = plt.subplots()

ax2.scatter(np.zeros(N_alpha), np.zeros(N_alpha), s=2, label='x1*')
ax2.scatter(zeros2[0], zeros2[1], s=2, label='x2*')
ax2.scatter(zeros3[0], zeros3[1], s=2, label='x3*')
ax2.scatter(zeros4[0], zeros4[1], s=2, label='x4*')

ax2.set_title("Puntos fijos (x*, y*) - Valores de alfa entre 0 y 1", fontsize=14, fontstyle='italic', color='black')
ax2.set_xlabel("x*", fontsize=12, fontstyle='italic', color='black', fontweight='bold')
ax2.set_ylabel("y*", fontsize=12, fontstyle='italic', color='black', fontweight='bold')
ax2.set_xlim(-0.5, 1)
ax2.set_ylim(-0.5, 1)

plt.show()