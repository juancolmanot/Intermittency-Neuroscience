import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits import mplot3d
import maps

N = 100
nmap = 14
alpha = 0.674149344
beta = 0.5

x = np.linspace(0, 1, N)
x1 = np.linspace(0, 1, N)
y = np.linspace(0, 1, N)
y1 = np.linspace(0, 1, N)

X, Y = np.meshgrid(x, y)

X1 = np.zeros_like(X)
Y1 = np.zeros_like(Y)

xn = np.zeros(2)
xn1 = np.zeros(2)

for i in range(X.shape[0]):
    for j in range(X.shape[0]):
        xn = np.array([X[i, j], Y[i, j]])
        xn1 = maps.map_n(xn, 7, alpha, beta)
        
        X1[i, j], Y1[i, j] = xn1[0], xn1[1]
        
        

fig = plt.figure()
ax1 = fig.add_subplot(121, projection='3d')
ax1.plot_surface(X, Y, X1, cmap='viridis')
ax1.set_xlabel('x')
ax1.set_ylabel('y')
ax1.set_zlabel('x1')
ax1.set_title('Map x, y, x1')

ax2 = fig.add_subplot(122, projection='3d')
ax2.plot_surface(X, Y, Y1, cmap='viridis')
ax2.set_xlabel('x')
ax2.set_ylabel('y')
ax2.set_zlabel('y1')
ax2.set_title('Map x, y, y1')

plt.show()