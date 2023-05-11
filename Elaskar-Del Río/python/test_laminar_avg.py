import numpy as np
import matplotlib.pyplot as plt
from matplotlib.animation import FuncAnimation
import maps
import stats
import intfunc

alpha = 0.674103
beta = 0.5

n_reinjection = 15000
n_lengths = 100
reinjection_counter = 0

xn = [0.7, 0.3]
xn1 = [0, 0]
xn2 = [0, 0]

x_err = [0, 0]

n_mapa = 14

lengths = np.zeros(n_reinjection)
lengths_bins = np.linspace(1, n_lengths, n_lengths)

reinjection_threshold = [10e-5, 10e-4]

start_iteration = 0
end_iteration = 0

i = 0
r = 0

N = 1000
x_threshold = np.ones((2, N))
x_threshold[0, :] = reinjection_threshold[0]
x_threshold[1, :] = reinjection_threshold[1]

x_err_n = np.zeros((2, N))

fig, ax = plt.subplots(2,1)

# while (reinjection_counter < n_reinjection):
    
#     i += 1

#     xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
#     xn2 = maps.mapa_n(xn1, n_mapa, alpha, beta)
#     xn1_err = [stats.rel_err(xn[0], xn1[0]), stats.rel_err(xn[1], xn1[1])]
#     xn2_err = [stats.rel_err(xn1[0], xn2[0]), stats.rel_err(xn1[1], xn2[1])]

#     reinject = intfunc.reinjection(xn1_err, xn2_err, reinjection_threshold)
#     eject = intfunc.ejection(xn1_err, xn2_err, reinjection_threshold)

#     if (reinject):
#         reinjection_counter += 1
#         start_iteration = i
        
#     elif (eject):
#         end_iteration = i
#         lengths[reinjection_counter] = end_iteration - start_iteration
        
#     xn = xn1


N = 1000
xn = [0.7, 0.3]
x_err_n = np.zeros((2, N))

def update(frame):

    if (frame >= N):
        n_start = frame - 20
        n_end = frame + N
    elif (frame < N):
        n_start = N - 20
        n_end = N

    print(frame, N, n_start, n_end)

    nshift = n_end - n_start

    for i in range(n_start, n_end):
        xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
        xn1_err = [stats.rel_err(xn[0], xn1[0]), stats.rel_err(xn[1], xn1[1])]

        x_err_n[:, i] = [xn1_err[0], xn1_err[1]]

        xn = xn1

    x_err_n = np.roll(x_err_n, nshift)
    x_err_n[n_start::] = np.zeros(nshift)

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