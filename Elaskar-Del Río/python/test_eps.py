import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from matplotlib.animation import FuncAnimation
import plot_functions as pf
import maps
from PIL import Image

N = 20
alpha_c = 0.77826511 # 0.77826511 # 0.674103 # 0.674149344
# alpha_min =  alpha_c - np.exp(-22)
# alpha_max =  alpha_c - np.exp(-19)

alpha = np.linspace(-24, -19, N)

n_map = 14
b = 0.3 #0.3
n_i = 2000

n = np.linspace(0, n_i, n_i + 1)
x = np.zeros((2, n_i + 1))
x1 = np.zeros((2, n_i + 1))

fig, ax = plt.subplots(2,1)
ax[0] = fig.add_subplot(211, projection='3d')

def update(frame):
    
    a = alpha[frame]
    a_i = alpha_c - np.exp(a)

    x[:, :] = 0
    x1[:, :] = 0

    x_n1 = [0, 0]
    x_n = [0.7, 0.9]

    for i in range(n_i + 1):
        x_n1 = maps.mapa_n(x_n, n_map, a_i, b)
        x[:, i] = x_n
        x1[:, i] = x_n1
        x_n = x_n1

    ax.clear()
    ax.grid()
    ax[0].scatter(n[10::], x[0, 10::], x1[0, 10::], s=0.2, label=f'a = {round(a, 2)}', color='black')
    ax[0].legend()
    ax[1].scatter(x[0, 10::], x1[0, 10::], s=0.2, color='black')
    ax[0].set_title('Limit cycle from n+14 map\n alpha crítico = 0.77826511 - beta = 0.3')
    ax[0].set_xlabel('x', fontsize=16, labelpad=20)
    ax[0].set_ylabel('y', fontsize=16, labelpad=20)

ani = FuncAnimation(fig, update, frames=N, blit=False)
ani.save('x-y_3.gif', writer='pillow')

   
plt.show()

