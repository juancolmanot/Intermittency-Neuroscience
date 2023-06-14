import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import plot_functions as pf
# import matplotlib.colors as colors
# import matplotlib.markers as markers
import maps
from PIL import Image

# colores = list(colors.BASE_COLORS.keys())
# marks = list(markers.MarkerStyle.markers.keys())

N = 20
alpha_c = 0.77826511
# alpha_min =  alpha_c - np.exp(-22)
# alpha_max =  alpha_c - np.exp(-19)

alpha = np.linspace(-22, -19, N)

n_map = 14
b = 0.3
n_i = 2000

n = np.linspace(0, n_i, n_i + 1)
x = np.zeros((2, n_i + 1))
x1 = np.zeros((2, n_i + 1))

# fig, ax = plt.subplots(1,1)

fig, ax = plt.subplots(2, 1)

# idx_color = j % (len(colores) - 1)
# idx_marker = j % (len(marks) - 1)
# ax.plot(x[0,:], x1[1, :], linestyle='None', marker='.', markersize='2', color='black') #, label=f'x_n[{j%len(marks)}]')

# line, = ax.plot([], [])

def update(frame):
    
    a = alpha[frame]
    a_i = alpha_c - np.exp(a)
    # print(frame)

    x[:, :] = 0
    x1[:, :] = 0

    x_n1 = [0, 0]
    x_n = [0.7, 0.9]

    for i in range(n_i + 1):
        x_n1 = maps.mapa_n(x_n, n_map, a_i, b)
        x[:, i] = x_n
        x1[:, i] = x_n1
        x_n = x_n1

    ax[0].clear()
    ax[1].clear()
    ax[0].grid()
    ax[1].grid()
    # ax.set_xlim([0.2, 0.5])
    # ax.set_ylim([0.79, 0.93])
    ax[0].scatter(n[10:], x[0, 10:], s=0.2, label=f'a = {round(a, 2)}', color='black')
    ax[1].scatter(n[10:], x[1, 10:], s=0.2, label=f'a = {round(a, 2)}', color='black')
    ax[0].legend()
    ax[0].legend()
    # ax.set_xticklabels(ax.get_xticklabels(), fontsize=14)
    # ax.set_yticklabels(ax.get_xticklabels(), fontsize=14)
    ax[0].set_title('x and y coordinates from n+14 map\n alpha crítico = 0.77826511 - beta = 0.3')
    ax[0].set_xlabel('n', fontsize=16, labelpad=20)
    ax[1].set_xlabel('n', fontsize=16, labelpad=20)
    ax[0].set_ylabel('x', fontsize=16, labelpad=20)
    ax[1].set_ylabel('y', fontsize=16, labelpad=20)
    # line.set_data(x, x1)

    # return line, 

ani = FuncAnimation(fig, update, frames=N, blit=False)
ani.save('x-y_3.gif', writer='pillow')

   
plt.show()

