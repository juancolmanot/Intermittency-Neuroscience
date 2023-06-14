from scipy.optimize import fsolve

def system(x_states, alpha, beta):
    x = x_states[0]
    y = x_states[1]

    f = x - 4 * alpha * x * (1 - x) - beta * y * (1 - x)
    g = y - 4 * alpha * y * (1 - y) - beta * x * (1 - y)

    return (f, g)

alpha_c = 0.674149
beta = 0.5

x_states_0 = (0.5, 0.5)

x, y = fsolve(system, x_states_0, args=(alpha_c, beta))

print("x = ", x)
print("y = ", y)