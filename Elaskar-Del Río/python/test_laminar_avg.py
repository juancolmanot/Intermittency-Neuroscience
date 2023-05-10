import numpy as np
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
prob_lengths = np.zeros(n_lengths)

reinjection_threshold = [10e-5, 10e-4]

start_iteration = 0
end_iteration = 0

i = 0
r = 0

while (reinjection_counter < n_reinjection):
    
    i += 1

    xn1 = maps.mapa_n(xn, n_mapa, alpha, beta)
    xn2 = maps.mapa_n(xn1, n_mapa, alpha, beta)
    xn1_err = [stats.rel_err(xn[0], xn1[0]), stats.rel_err(xn[1], xn1[1])]
    xn2_err = [stats.rel_err(xn1[0], xn2[0]), stats.rel_err(xn1[1], xn2[1])]

    reinject = intfunc.reinjection(xn1_err, xn2_err, reinjection_threshold)
    eject = intfunc.ejection(xn1_err, xn2_err, reinjection_threshold)

    # print("=======")
    # print(xn1_err, xn2_err, reinjection_threshold)
    # print("-------")
    # print(i, reinject, eject)

    if (reinject):
        reinjection_counter += 1
        start_iteration = i
        
    elif (eject):
        end_iteration = i
        lengths[reinjection_counter] = end_iteration - start_iteration
        
    xn = xn1

for i, l in enumerate(lengths):
    print(i, l)

# lengths = lengths.sort()
    
