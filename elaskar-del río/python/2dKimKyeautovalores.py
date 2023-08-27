import numpy as np
import matplotlib.pyplot as plt
from scipy.optimize import fsolve
from mpl_toolkits.axes_grid1 import make_axes_locatable

def zero12(alpha):
    return 1 - 1 / (0.5 + 4 * alpha)

def zerox13(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 + c3)
    else:
        return 10

def zeroy13(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 - c2)
    else:
        return 10

def zerox14(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 - c3)
    else:
        return 10

def zeroy14(alpha):
    c0 = 1.5 - 4 * alpha
    c1 = 0.75 - 4 * alpha + 4 * alpha * (4 * alpha - 1)
    c2 = (-1.5 + 4 * alpha) * (- 0.5 + 4 * alpha) * (0.75 + 4 * alpha + 4 * alpha * (-1 + 4 * alpha))
    if (c2 >= 0):
        c3 = np.sqrt(c2)
        return c0 / (c1 + c3)
    else:
        return 10


def zero21(alpha):
    c0 = -15 - 256 * alpha - 1152 * alpha**2 + 4096 * alpha**4
    if (c0 >= 0):    
        c1 = 3 + 32 * alpha + 64 * alpha**2 - np.sqrt(c0)
        c2 = 0.5 * c1
        c3 = 1 + 16 * alpha + 64 * alpha**2
        return c2 / c3
    else:
        return 10

def zero22(alpha):
    c0 = -15 - 256 * alpha - 1152 * alpha**2 + 4096 * alpha**4
    if (c0 >= 0):
        c1 = 3 + 32 * alpha + 64 * alpha**2 + np.sqrt(c0)
        c2 = 0.5 * c1
        c3 = 1 + 16 * alpha + 64 * alpha**2
        return c2 / c3
    else:
        return 10

def zerox23(alpha):
    c0 = 1 + 32 * alpha - 128 * alpha**2 - 2048 * alpha**3 + 4096 * alpha**4
    if (c0 >= 0):
        c1 = -1 + 64 * alpha**2 - np.sqrt(c0)
        c2 = 0.5 * c1
        c3 = - 8 * alpha + 64 * alpha**2
        return c2 / c3
    else:
        return 10
    
def zeroy23(alpha):
    c0 = 1 + 32 * alpha - 128 * alpha**2 - 2048 * alpha**3 + 4096 * alpha**4
    if (c0 >= 0):
        c1 = -1 + 64 * alpha**2 + np.sqrt(c0)
        c2 = 0.5 * c1
        c3 = - 8 * alpha + 64 * alpha**2
        return c2 / c3
    else:
        return 10
    
def zerox24(alpha):
    c0 = 1 +32 * alpha - 128 * alpha**2 - 2048 * alpha**3 + 4096 * alpha**4
    if (c0 >= 0):
        c1 = -1 + 64 * alpha**2 + np.sqrt(c0)
        c2 = 0.5 * c1
        c3 = - 8 * alpha + 64 * alpha**2
        return c2 / c3
    else:
        return 10

def zeroy24(alpha):
    c0 = 1 +32 * alpha - 128 * alpha**2 - 2048 * alpha**3 + 4096 * alpha**4
    if (c0 >= 0):
        c1 = -1 + 64 * alpha**2 - np.sqrt(c0)
        c2 = 0.5 * c1
        c3 = - 8 * alpha + 64 * alpha**2
        return c2 / c3
    else:
        return 10

def Jac(x, *params):
    alpha = params[0]
    beta = params[1]
    
    j = np.zeros((2, 2))
    j[0, 0] = 4 * alpha * (1 - 2 * x[0]) - beta * x[1]
    j[1, 1] = 4 * alpha * (1 - 2 * x[1]) - beta * x[0]
    j[0, 1] = beta * (1 - x[0])
    j[1, 0] = beta * (1 - x[1])
    
    return j


N_alpha = 500
alphas = np.linspace(0.001, 1, N_alpha)
beta = 0.3

x12 = np.zeros(N_alpha)
y12 = np.zeros(N_alpha)
x13 = np.zeros(N_alpha)
y13 = np.zeros(N_alpha)
x14 = np.zeros(N_alpha)
y14 = np.zeros(N_alpha)
x21 = np.zeros(N_alpha)
y21 = np.zeros(N_alpha)
x22 = np.zeros(N_alpha)
y22 = np.zeros(N_alpha)
x23 = np.zeros(N_alpha)
y23 = np.zeros(N_alpha)
x24 = np.zeros(N_alpha)
y24 = np.zeros(N_alpha)

eig11 = np.zeros((2, N_alpha))
eig12 = np.zeros((2, N_alpha))
eig13 = np.zeros((2, N_alpha))
eig14 = np.zeros((2, N_alpha))
eig21 = np.zeros((2, N_alpha))
eig22 = np.zeros((2, N_alpha))
eig23 = np.zeros((2, N_alpha))
eig24 = np.zeros((2, N_alpha))


for i, alphai in enumerate(alphas):
    x12[i] = zero12(alphai)
    y12[i] = x12[i]
    x13[i] = zerox13(alphai)
    y13[i] = zeroy13(alphai)
    x14[i] = zerox14(alphai)
    y14[i] = zeroy14(alphai)
    x21[i] = zero21(alphai)
    y21[i] = x21[i]
    x22[i] = zero22(alphai)
    y22[i] = x22[i]
    x23[i] = zerox23(alphai)
    y23[i] = zeroy23(alphai)
    x24[i] = zerox24(alphai)
    y24[i] = zeroy24(alphai)

    eig11[:, i] = np.linalg.eigvals(Jac([0, 0], alphai, beta))
    eig12[:, i] = np.linalg.eigvals(Jac([x12[i], y12[i]], alphai, beta))
    eig13[:, i] = np.linalg.eigvals(Jac([x13[i], y13[i]], alphai, beta))
    eig14[:, i] = np.linalg.eigvals(Jac([x14[i], y14[i]], alphai, beta))
    eig21[:, i] = np.linalg.eigvals(Jac([x21[i], y21[i]], alphai, beta))
    eig22[:, i] = np.linalg.eigvals(Jac([x22[i], y22[i]], alphai, beta))
    eig23[:, i] = np.linalg.eigvals(Jac([x23[i], y23[i]], alphai, beta))
    eig24[:, i] = np.linalg.eigvals(Jac([x24[i], y24[i]], alphai, beta))
    
fig, ax = plt.subplots(2, 1)

for i in range(2):
    # ax[1].scatter(alphas, eig11[i, :], s=0.5, color='red', label=r'$\lambda_1$'+f'{i}')
    ax[1].scatter(alphas, eig12[i, :], s=2, color='blue')
    # ax[1].scatter(alphas, eig13[i, :], s=2, color='green')
    # ax[1].scatter(alphas, eig14[i, :], s=2, color='orange')
    ax[1].scatter(alphas, eig21[i, :], s=2, color='red')
    ax[1].scatter(alphas, eig22[i, :], s=2, color='green')
    ax[1].scatter(alphas, eig23[i, :], s=2, color='brown')
    ax[1].scatter(alphas, eig24[i, :], s=2, color='cyan')


ax[1].plot(alphas, np.ones(N_alpha), color='black')
ax[1].plot(alphas, np.ones(N_alpha) * - 1, color='black')
# ax[0].scatter(alphas, np.zeros(N_alpha), s=0.5, color='red', label='x1*')
ax[0].scatter(alphas, x12, s=0.5, color='blue')
# ax[0].scatter(alphas, x13, s=0.5, color='green', label='x3*')
# ax[0].scatter(alphas, x14, s=0.5, color='orange', label='x4*')
ax[0].scatter(alphas, x21, s=0.5, color='red')
ax[0].scatter(alphas, x22, s=0.5, color='green')
ax[0].scatter(alphas, x23, s=0.5, color='brown')
ax[0].scatter(alphas, x24, s=0.5, color='cyan')


ax[0].set_ylabel('x*', fontsize=14, color='black', fontstyle='italic', fontweight='bold')
ax[1].set_xlabel(r'$\alpha$', fontsize=16, color='black', fontstyle='italic', fontweight='bold')
ax[1].set_ylabel(r'$\lambda$', fontsize=16, color='black', fontstyle='italic', fontweight='bold')
ax[1].set_xlim(0, 1)
ax[0].set_xlim(0, 1)
ax[0].set_ylim(0, 1)
ax[1].set_ylim(-2, 2)
# ax[0].legend()
# ax[1].legend()

fig.suptitle("Puntos fijos - valores propios de F2" + r' $\beta$=0.3', fontsize=14, fontstyle='italic')
plt.show()