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

N = 4000
n_transient = 500
n_steady = 250
ntries = 10

alphas = np.linspace(0.1, 0.85, N)
beta_i = 0.5

x_inf1 = np.zeros((N, n_steady))
y_inf1 = np.zeros((N, n_steady))

x_inf2 = np.zeros((N, n_steady))
y_inf2 = np.zeros((N, n_steady))

fig, ax = plt.subplots(1, 2)
# rc('font', family='Times New Roman')

# for i in range(ntries):
x_inf1 = np.zeros((N, n_steady))
y_inf1 = np.zeros((N, n_steady))
for j in range(N):
    
    x01, y01 = np.random.uniform(0.001, 0.99999, 2)
    x02 = np.random.uniform(0.1, 0.99999)
    y02 = x02
    
    xn_1 = [x01, y01]
    xn1_1 = [0, 0]
    
    xn_2 = [x02, y02]
    xn1_2 = [0, 0]

    for i in range(n_transient):
        xn1_1 = F(xn_1, alphas[j], beta_i)
        xn_1 = xn1_1

    for i in range(n_steady):
        xn1_1 = F(xn_1, alphas[j], beta_i)
        x_inf1[j, i] = xn1_1[0]
        y_inf1[j, i] = xn1_1[1]
        xn_1 = xn1_1
        
    for i in range(n_transient):
        xn1_2 = F(xn_2, alphas[j], beta_i)
        xn_2 = xn1_2

    for i in range(n_steady):
        xn1_2 = F(xn_2, alphas[j], beta_i)
        x_inf2[j, i] = xn1_2[0]
        y_inf2[j, i] = xn1_2[1]
        xn_2 = xn1_2
    
    ax[0].scatter(np.ones(n_steady) * alphas[j], x_inf1[j, :], s=0.01, color='black', marker='.')
    ax[1].scatter(np.ones(n_steady) * alphas[j], x_inf2[j, :], s=0.01, color='black', marker='.')
    ax[1].set_xlabel(r'$\alpha$', fontsize=16, fontstyle='italic', color='black', fontweight='bold')
    ax[0].set_xlabel(r'$\alpha$', fontsize=16, fontstyle='italic', color='black', fontweight='bold')
    ax[0].set_ylabel(r'xn*', fontsize=18, fontstyle='italic', color='black')
    #ax[1].set_ylabel(r'xn*', fontsize=18, fontstyle='italic', color='black')
    # ax.scatter(np.ones(n_steady) * alphas[j], x_inf1[j, :], s=0.01, color='black', marker='.')
    

#ax[0].set_title("Diagrama de bifurcación - beta = 0.3")
# ax.scatter(np.ones(n_steady) * alphas[j], x_inf2[j, :], s=0.02, color='blue', marker='.')


# ax[1].scatter(np.ones(n_steady) * alphas[j], y_inf1[j, :], s=0.02, color='red', marker='.')
# ax[1].scatter(np.ones(n_steady) * alphas[j], y_inf2[j, :], s=0.02, color='blue', marker='.')
# ax[1].set_xlabel(r'$\alpha$', fontsize=14, fontstyle='italic', color='black', fontweight='bold')
# ax[1].set_ylabel("yn", fontsize=12, fontstyle='italic', color='black', fontweight='bold')
# ax[0, 1].scatter(np.ones(n_steady) * alphas[j], x_inf1[j, :], s=0.02, color='red', marker='.')
# ax[0, 1].scatter(np.ones(n_steady) * alphas[j], x_inf2[j, :], s=0.02, color='blue', marker='.')
# ax[1, 1].scatter(np.ones(n_steady) * alphas[j], y_inf1[j, :], s=0.02, color='red', marker='.')
# ax[1, 1].scatter(np.ones(n_steady) * alphas[j], y_inf2[j, :], s=0.02, color='blue', marker='.')
# ax[1, 1].set_xlabel(r'$\alpha$', fontsize=14, fontstyle='italic', color='black', fontweight='bold')

# ax[0].axvline(x=0.674149344, color='red', linestyle='--')
# ax[1].axvline(x=0.77826511, color='red', linestyle='--')
ax[0].set_xlim(0.6, 0.85)
ax[0].set_ylim(0, 1)
ax[1].set_xlim(0.6, 0.85)
ax[1].set_ylim(0, 1)
# ax[1].set_xlim(0, 1)
# ax[1].set_ylim(0, 1)
# ax[0, 1].set_xlim(0.5, 1)
# ax[0, 1].set_ylim(0, 1)
# ax[1, 1].set_xlim(0.5, 1)
# ax[1, 1].set_ylim(0, 1)
# ax.set_ylabel('xn*', fontsize=16, fontstyle='italic', color='black')
# ax.set_xlabel(r'$\alpha$', fontsize=16, fontstyle='italic', color='black')
fig.suptitle("Diagramas de bifurcación xn* (Kim, Kye, 2001) - atractores diferentes", fontsize=16, fontstyle='italic', color='black')
# ax.set_xlim(0.6, 0.85)
# ax.set_ylim(0, 1)
plt.show()