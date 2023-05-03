import numpy as np
import matplotlib.pyplot as plt
import maps

with open("datafiles/test_var_alpha.dat", "w") as file:

    N = 5
    alpha_c = 0.674149344
    alpha_min =  alpha_c - np.exp(-15)
    alpha_max =  alpha_c - np.exp(-22)

    alpha = np.linspace(-22, -19, N)

    n_map = 14
    b = 0.5
    n_i = 1000

    for a in alpha:
        
        x_n1 = [0, 0]
        x_n = [0.7, 0.9]

        alpha_i = alpha_c - np.exp(a)

        for i in range(n_i + 1):
            x_n1 = maps.mapa_n(x_n, n_map, alpha_i, b)
            file.write('{:3d} {:.4E} {:.4E}\n'.format(i, x_n[0], x_n[1]))
            x_n = x_n1


file.close()