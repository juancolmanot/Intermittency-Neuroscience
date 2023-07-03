import numpy as np

def planes_system(x, p1, p2):
    
    a1, b1, c1, d1, e1 = p1[0], p1[1], p1[2], p1[3], p1[4]
    a2, b2, c2, d2, e2 = p2[0], p2[1], p2[2], p2[3], p2[4]
    x, y, x1, y1 =  x[0], x[1], x[2], x[3]
    
    plane1 = a1 * x + b1 * y + c1 * x1 + d1 * y1 + e1
    plane2 = a2 * x + b2 * y + c2 * x1 + d2 * y1 + e2
    
    return plane1, plane2
    
    

a1, b1, c1, d1, e1 = 2, -3, 1, 2, -4
a2, b2, c2, d2, e2 = 4, 1, -2, 3, 1

A = np.array([[a1, b1, c1, d1], [a2, b2, c2, d2]])
b = np.array([-e1, -e2])

solution, residuals, _, _ = np.linalg.lstsq(A, b)

x, y, x1, y1 = solution

print("Intersection Point: ")
print("x = ", x)
print("y = ", y)
print("x1 = ", x1)
print("y1 = ", y1)

values = planes_system((x, y, x1, y1), (a1, b1, c1, d1, e1), (a2, b2, c2, d2, e2))

print(values)
