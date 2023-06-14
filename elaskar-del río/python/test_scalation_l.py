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
    

alpha = 0.77826511
beta = 0.3
n_mapa = 14

c = [1e-4, 1e-4]

reinjections_target = 10000

n_eps = 20
epsilon = np.linspace(-24, -19, n_eps)
l_expected = np.zeros(n_eps)

for i, eps in enumerate(epsilon):

    alpha_i = alpha - np.exp(eps)

    lengths_x = np.zeros(reinjections_target)
    reinjection_counter = 0
    iterations = 0
    start_laminar = 0

    xn = [0.6, 0.7]
    xn1 = [0.0, 0.0]
    xerr = [0.0, 0.0]
    x1err = [0.0, 0.0]

    while (reinjection_counter < reinjections_target):

        iterations += 1

        xn1 = maps.mapa_n(xn, n_mapa, alpha_i, beta)
        xerr = rel_err(xn, xn1)
        xn = xn1
        xn1 = maps.mapa_n(xn, n_mapa, alpha_i, beta)
        x1err = rel_err(xn, xn1)

        if (reinject(xerr[0], x1err[0], c[0])):
            start_laminar = iterations
            reinjection_counter += 1
            if (reinjection_counter % 100 == 0):
                print(eps, alpha_i, reinjection_counter)

        elif (eject(xerr[0], x1err[0], c[0])):
            lengths_x[reinjection_counter - 1] = iterations - start_laminar

        xn = xn1

    # Laminar lengths
    # ==================================================
    n_bins_l = 200

    l_count = np.zeros(n_bins_l)
    l_avg = np.zeros(n_bins_l)
    l_bins = np.linspace(1, n_bins_l, n_bins_l)

    for l in lengths_x:
        for j in range(len(l_bins) -1):
            if (l < l_bins[j + 1] and l >= l_bins[j]):
                l_count[j] += 1
                l_avg[j] += l

    l_count = l_count / reinjections_target

    for j in range(n_bins_l):

        l_expected[i] += l_avg[j] * l_count[j]


l_expected = np.log(l_expected)

fig, ax = plt.subplots()

ax.plot(epsilon, l_expected, color='black')
ax.set_xlabel('ln(ac - a)')
ax.set_ylabel('ln <l>')

plt.show()

