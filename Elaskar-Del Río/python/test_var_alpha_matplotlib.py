import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import plot_functions as pf
# import matplotlib.colors as colors
# import matplotlib.markers as markers
import maps

# colores = list(colors.BASE_COLORS.keys())
# marks = list(markers.MarkerStyle.markers.keys())

N = 100
alpha_c = 0.674103 #7782651
# alpha_min =  alpha_c - np.exp(-22)
# alpha_max =  alpha_c - np.exp(-19)

alpha = np.linspace(-7, -3.8, N)

n_map = 14
b = 0.5
n_i = 2000

n = np.linspace(0, n_i, n_i + 1)
x = np.zeros((2, n_i + 1))
x1 = np.zeros((2, n_i + 1))

# fig, ax = plt.subplots(1,1)

fig, ax = plt.subplots(1, 1)


# idx_color = j % (len(colores) - 1)
# idx_marker = j % (len(marks) - 1)
# ax.plot(x[0,:], x1[1, :], linestyle='None', marker='.', markersize='2', color='black') #, label=f'x_n[{j%len(marks)}]')

# line, = ax.plot([], [])

def update(frame):
    
    a = alpha[frame]
    a = alpha_c - np.exp(a)
    print(frame)

    x[:, :] = 0
    x1[:, :] = 0

    x_n1 = [0, 0]
    x_n = [0.7, 0.9]

    for i in range(n_i + 1):
        x_n1 = maps.mapa_n(x_n, n_map, a, b)
        x[:, i] = x_n
        x1[:, i] = x_n1
        x_n = x_n1

    ax.clear()
    ax.grid()
    ax.set_xlim([0.2, 0.5])
    ax.set_ylim([0.79, 0.93])
    ax.plot(x[0, 10:], x[1, 10:])

    # line.set_data(x, x1)

    # return line, 

ani = FuncAnimation(fig, update, frames=N, blit=False)


   
plt.show()

