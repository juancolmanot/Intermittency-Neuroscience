import warnings
import numpy as np
from scipy.optimize import fsolve
import matplotlib.pyplot as plt
import maps

warnings.filterwarnings('ignore', category=RuntimeWarning)

alpha = 0.674149344
beta = 0.5

parameters = [alpha, beta]

domain_size = 40

x = np.linspace(0, 1, domain_size)
y = np.linspace(0, 1, domain_size)

X, Y = np.meshgrid(x, y)

values = np.zeros_like(X)
roots_x = np.zeros(X.shape[0] * X.shape[1])
roots_y = np.zeros(X.shape[0] * X.shape[1])

with warnings.catch_warnings():

    warnings.simplefilter('ignore', category=RuntimeWarning)
    for i in range(X.shape[0]):
        for j in range(X.shape[1]):

            x0 = [X[i, j], Y[i, j]]
            root = fsolve(maps.mapa, x0, args=(alpha, beta))
            values[i, j] = root[0] + root[1]
            roots_x[i * X.shape[0] + j] = root[0]
            roots_y[i * X.shape[0] + j] = root[1]


plt.pcolormesh(X, Y, values, cmap='viridis')
plt.scatter(roots_x, roots_y, c='red')
plt.colorbar()

plt.xlabel('X')
plt.ylabel('Y')
plt.title('Color Map')

roots_x = np.round(roots_x, decimals=4)
roots_y = np.round(roots_y, decimals=4)

roots_x_unique = list(set(roots_x))
roots_y_unique = list(set(roots_y))

print(roots_x_unique)
print(roots_y_unique)

plt.show()