import numpy as np

def reinjection(xn, xn1, c):

    if (xn[0] > c[0] and xn1[0] <= c[0] and xn[1] > c[1] and xn1[1] <= c[1]):

        return True
    else:
        return False
    
def ejection(xn, xn1, c):
    
    if (xn[0] <= c[0] and xn1[0] > c[0] and xn[1] <= c[1] and xn1[1] > c[1]):

        return True
    else:
        return False