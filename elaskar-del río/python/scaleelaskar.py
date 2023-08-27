import numpy as np
import matplotlib.pyplot as plt

eps = [0.0000000001500000124, 0.0000000002500000207, 0.000000001249999992, 0.000000002250000075, 0.000000004250000019]

eps1 = np.array([-22.62038574, -22.10956012, -20.50012229, -19.91233559, -19.27634685])
eps12 = eps1 * 0.5

lavg = [12.63067349, 12.40484153, 11.63801508, 11.34846347, 11.03296846]


fig, ax = plt.subplots()

ax.set_xlabel(r'log $\alpha_c - \alpha$', fontsize=16, fontstyle='italic', color='black')
ax.set_ylabel('log <l>', fontsize=16, fontstyle='italic', color='black')
ax.plot(eps1, lavg, marker='o', color='red', label='numérica')
ax.plot(eps1, -eps12, marker='o', color='blue', label='- 0.5 * eps')
ax.legend()

plt.show()