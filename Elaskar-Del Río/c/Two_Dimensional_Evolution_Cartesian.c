#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE* fp = fopen("datafiles/Two_Dimensional_Evolution_Cartesian.dat", "w");

    unsigned int i;
    double alpha_c = 0.674149344;
    double beta = 0.5;
    unsigned int n_mapa = 14;
    unsigned int n_iterations = 1000;

    /* state variables */
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));

    /* Distance from origin */
    double d;

    xn[0] = 0.9;
    xn[1] = 0.1;
    xn1[0] = xn1[1] = 0;

    for (i = 0; i < n_iterations; i++) {
    
        map_2d_n(xn1, xn, n_mapa, alpha_c, beta);

        xn[0] = xn1[0];
        xn[1] = xn1[1];

        d = sqrt(xn[0] * xn[0] + xn[1] * xn[1]);
        fprintf(fp, "%f %f %f\n", xn[0], xn[1], d);
    }

    fclose(fp);
    return 0;
}