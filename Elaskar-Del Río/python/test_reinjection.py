import numpy as np
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
    

def laminar_lengths(func, x0, params, threshold, ):

alpha = 0.674103
beta = 0.5
n_mapa = 14

c = [1e-4, 1e-4]

reinjections_target = 1000

lengths_x = np.zeros(reinjections_target)
lengths_y = np.zeros(reinjections_target)

reinjection_counter = [0, 0]
iterations = 0
start_laminar = [0, 0]

xn = [0.6, 0.7]
xn1 = [0.0, 0.0]
xerr = [0.0, 0.0]
x1err = [0.0, 0.0]

while (reinjection_counter[0] < reinjections_target):
    iterations += 1

    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    xerr = rel_err(xn, xn1)
    xn = xn1
    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    x1err = rel_err(xn, xn1)

    if (reinject(xerr[0], x1err[0], c[0])):
        start_laminar[0] = iterations
        reinjection_counter[0] += 1

    elif (eject(xerr[0], x1err[0], c[0])):
        lengths_x[reinjection_counter[0]] = iterations - start_laminar[0]

    if (reinject(xerr[1], x1err[1], c[1])):
        start_laminar[1] = iterations
        reinjection_counter[1] += 1

    elif (eject(xerr[1], x1err[1], c[1])):
        lengths_x[reinjection_counter[1]] = iterations - start_laminar[1]

    xn = xn1
