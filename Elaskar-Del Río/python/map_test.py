import os
import sys
import numpy as np
import matplotlib.pyplot as plt

if not os.path.exists("datafiles"):
    os.makedirs("datafiles")

# Map definition

def mapa(xn, *args):
    
    alfa = args[0]
    beta = args[1]

    xn1 = 4 * alfa * xn[0] * (1 - xn[0]) + beta * xn[1] * (1 - xn[0])
    yn1 = 4 * alfa * xn[1] * (1 - xn[1]) + beta * xn[0] * (1 - xn[1])

    return [xn1, yn1]

x_n1 = [0, 0]
x_n = x_n = [0.5, 0.5]

a = 0.7
b = 0.5

k = 0
i = 0
while (k == 0):
    
    i += 1
    x_n1 = mapa(x_n, a, b)
    if any(np.isinf(x) for x in x_n1):
        k = 1
        print(f"Explotó con a = {a}, en i = {i}, xn1 = {x_n1[0]}, yn1 = {x_n1[1]}")
        # sys.exit()
    
    elif (i == 10000 and not any(np.isinf(x) for x in x_n1)):
        print(i, x_n1)
        a += 0.001
        x_n1 = [0, 0]
        x_n = [0.5, 0.5]
        x_n1 = mapa(x_n, a, b)
        i = 0
        print(f"No explotó con a = {a}\n")

    
    x_n = x_n1
    

