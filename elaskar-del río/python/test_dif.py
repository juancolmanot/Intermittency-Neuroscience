import os
import sys
import numpy as np

data_python = []

with open("datafiles/Two_Dimensional_Evolution.dat", "r") as pythonfile:
    
    for line in pythonfile:
        data_python.append(line.strip().split())


pythonfile.close()

data_c = []

with open("../c/datafiles/Two_Dimensional_Evolution.dat", "r") as cfile:
    
    for line in cfile:
        data_c.append(line.strip().split())

cfile.close()

with open("datafiles/test_diff.dat", "w") as diff:

    size = 1300

    x_py = np.zeros((2,1300))
    x_c = x_py
    x_diff = x_py

    for i in range(1300):
        x_py[:, i] = [data_python[i][1], data_python[i][2]]
        x_c[:, i] = [data_c[i][1], data_c[i][2]]
        x_diff[:, i] = [x_py[0, i] - x_c[0, i], x_py[1, i] - x_c[1, i]]
        diff.write('{:.4E} {:.4E}\n'.format(x_diff[0, i], x_diff[1, i]))

