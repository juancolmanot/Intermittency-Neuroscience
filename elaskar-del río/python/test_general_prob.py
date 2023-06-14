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

iterations_target = 10000
x = np.zeros(iterations_target)

iterations = 0

xn = [0.6, 0.7]
xn1 = [0.0, 0.0]
xerr = [0.0, 0.0]
x1err = [0.0, 0.0]

while (iterations < iterations_target):

    iterations += 1

    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    x[iterations - 1] = xn[0]

    xn = xn1


# Reinjection points
# ==================================================
n_bins_x = 500

x_count = np.zeros(n_bins_x)
min_x = np.min(x)
max_x = np.max(x)
x_bins = np.linspace(min_x, max_x, n_bins_x)

for x in x:
    for i in range(len(x_bins) -1):
        if (x < x_bins[i + 1] and x >= x_bins[i]):
            x_count[i] += 1


x_count = x_count / iterations_target

fig, ax = plt.subplots()


ax.plot(x_bins, x_count, color='black')
ax.set_xlabel('x')
ax.set_ylabel('p(x)')

plt.show()

