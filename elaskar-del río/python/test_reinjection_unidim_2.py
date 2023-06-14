import numpy as np
import matplotlib.pyplot as plt
import maps

def rel_err(x, x1):

    xerr = abs((x1[0] - x[0]) / x[0])
    yerr = abs((x1[1] - x[1]) / x[1])

    return [xerr, yerr]

def reinject(x, x1, c):

    if (x > c and x1 <= c):
        return True
    
    else:
        return False
    
def eject(x, x1, c):

    if (x <= c and x1 > c):
        return True
    
    else:
        return False
    

alpha = 0.674103
beta = 0.5
n_mapa = 14

c = [1e-4, 1e-4]

reinjections_target = 5000

# RPD(x) and l(x)

lengths_x = np.zeros(reinjections_target)
x_reinjected = np.zeros(reinjections_target)

reinjection_counter = 0
iterations = 0
start_laminar = 0

xn = [0.6, 0.7]
xn1 = [0.0, 0.0]
xerr = [0.0, 0.0]
x1err = [0.0, 0.0]

while (reinjection_counter < reinjections_target):

    iterations += 1

    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    xerr = rel_err(xn, xn1)
    xn = xn1
    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    x1err = rel_err(xn, xn1)

    if (reinject(xerr[0], x1err[0], c[0])):
        start_laminar = iterations
        reinjection_counter += 1
        x_reinjected[reinjection_counter - 1] = xn[0]

    elif (eject(xerr[0], x1err[0], c[0])):
        lengths_x[reinjection_counter - 1] = iterations - start_laminar

    xn = xn1

# Laminar lengths
# ==================================================
n_bins_l = 100

l_count = np.zeros(n_bins_l)
l_avg = np.zeros(n_bins_l)
l_bins = np.linspace(1, n_bins_l, n_bins_l)

for l in lengths_x:
    for i in range(len(l_bins) -1):
        if (l < l_bins[i + 1] and l >= l_bins[i]):
            l_count[i] += 1
            l_avg[i] += l

# Reinjection points
# ==================================================
n_bins_x = 100

x_count = np.zeros(n_bins_x)
x_avg = np.zeros(n_bins_x)
min_x = np.min(x_reinjected)
max_x = np.max(x_reinjected)
x_bins = np.linspace(min_x, max_x, n_bins_x)

for x in x_reinjected:
    for i in range(len(x_bins) -1):
        if (x < x_bins[i + 1] and x >= x_bins[i]):
            x_count[i] += 1
            x_avg[i] += x

for i in range(n_bins_l):

    if (l_count[i] != 0):
        l_avg[i] = l_avg[i] / l_count[i]
    else:
        l_avg[i] = 0

    if (x_count[i] != 0):    
        x_avg[i] = x_avg[i] / x_count[i]

    else:
        x_avg[i] = 0

x_avg = x_avg / reinjection_counter

fig, ax = plt.subplots(1, 2)

ax[0].plot(l_bins, l_avg, color='black')
ax[0].set_xlabel('x')
ax[0].set_ylabel('l(x)')

ax[1].plot(x_bins, x_avg, color='black')
ax[1].set_xlabel('x')
ax[1].set_ylabel('x-avg')

plt.show()

