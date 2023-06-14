import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import maps
import stats
import intfunc

alpha = 0.674103
beta = 0.5

xn = [0.7, 0.3]
xn1 = [0, 0]
x_err = [0, 0]
n_mapa = 14

reinjection_threshold = [10e-5, 10e-4]

i = 0

N = 1000
nshift = 100
x_threshold = np.ones((2, N))
x_threshold[0, :] = reinjection_threshold[0]
x_threshold[1, :] = reinjection_threshold[1]

x_err_n = np.zeros((2, N))

fig, ax = plt.subplots(2,1)


def update(frame):

    global xn, xn1, x_err_n, alpha, beta, n_mapa, xn1_err, nshift
    x_err_n = np.roll(x_err_n, nshift)
    x_err_n[N - nshift::] = 0
    for i in range(N - nshift, N):

        xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
        xn1_err = [stats.rel_err(xn[0], xn1[0]), stats.rel_err(xn[1], xn1[1])]

        x_err_n[:, i] = [xn1_err[0], xn1_err[1]]

        xn = xn1


    n = np.linspace(frame, frame + N, N)

    for i in range(len(ax)):
        ax[i].clear()
        ax[i].grid()
        ax[i].scatter(n, x_err_n[i, :], s=0.5, color='black')
        ax[i].plot(n, x_threshold[i], marker=None, linewidth=1, color='red')
        ax[i].set_yscale('log')
        ax[i].set_xlabel('n')

    ax[0].set_ylabel('x')
    ax[1].set_ylabel('y')

def data_gen():

    frame = 0

    while True:
        yield frame
        frame += 1


ani = FuncAnimation(fig, update, frames=data_gen, blit=False, interval=200)

plt.show()