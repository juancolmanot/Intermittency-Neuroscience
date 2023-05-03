def mapa(xn, *args):
    
    alpha = args[0]
    beta = args[1]

    xn1 = 4 * alpha * xn[0] * (1 - xn[0]) + beta * xn[1] * (1 - xn[0])
    yn1 = 4 * alpha * xn[1] * (1 - xn[1]) + beta * xn[0] * (1 - xn[1])

    return [xn1, yn1]

def mapa_n(xn, n, *args):

    alpha = args[0]
    beta = args[1]

    xn_aux = xn
    
    for i in range(n):
        xn1 = mapa(xn_aux, alpha, beta)
        xn_aux = xn1

    return xn1

def mapa_const(x, *args):

    alpha = args[0]
    beta = args[1]

    xn1 = 4 * alpha * x[0] * (1 - x[0]) + beta * x[1] * (1 - x[0])

    return [xn1, x[1]]