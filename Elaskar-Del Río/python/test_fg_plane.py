import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D

x = np.linspace(-5, 5, 100)
y = np.linspace(-5, 5, 100)
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# X, Y = np.meshgrid(x, y)

# X1 = X
# Y1 = Y

# ax.plot_surface(X, Y, X1)
# ax.plot_surface(X, Y, Y1)
ax.plot(x, y, x, color='black')
ax.set_xlabel('x')
ax.set_ylabel('y')
ax.set_zlabel('x1, y1')

plt.show()