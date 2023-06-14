import os
import numpy as np
import matplotlib.pyplot as plt

if not os.path.exists("datafiles"):
    os.makedirs("datafiles")


def mapa(xn, *args):

    alfa = args[0]
    beta = args[1]

    xn1 = 4 * alfa * xn[0] * (1 - xn[0]) + beta * xn[1] * (1 - xn[0])
    yn1 = 4 * alfa * xn[1] * (1 - xn[1]) + beta * xn[0] * (1 - xn[1])

    return [xn1, yn1]


x0 = np.random.uniform(0, 1, 2)

with open("datafiles/test.dat", "w") as file:
    file.write("xn, yn, xn1, yn1\n")
    for i in range(40):
        xn_1 = mapa(x0, 0.674103, 0.5)
        file.write(f"{x0[0]},{x0[1]},{xn_1[0]},{xn_1[1]}\n")
        x0[0] = xn_1[0]
        x0[1] = xn_1[1]

