def mapa(xn, *args):
    
    alfa = args[0]
    beta = args[1]

    xn1 = 4 * alfa * xn[0] * (1 - xn[0]) + beta * xn[1] * (1 - xn[0])
    yn1 = 4 * alfa * xn[1] * (1 - xn[1]) + beta * xn[0] * (1 - xn[1])

    return [xn1, yn1]

def mapa_n(xn, n, *args):

    alfa = args[0]
    beta = args[1]

    xn_aux = xn
    
    for i in range(n):
        xn1 = mapa(xn_aux, alfa, beta)
        xn_aux = xn1

    return xn1