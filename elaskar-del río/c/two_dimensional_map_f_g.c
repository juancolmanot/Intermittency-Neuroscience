#include <stdlib.h>
#include <stdio.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp = fopen("datafiles/two_dimensional_map_f_g.dat", "w");


    unsigned int N = 2000;
    unsigned int n_map = 14;
    unsigned int seed = 34852;
    double p_alfa, p_beta;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xn_aux = calloc(2, sizeof(double));
    double* xn1_aux = calloc(2, sizeof(double));

    double *x, *y;

    x = calloc(N, sizeof(double));
    y = calloc(N, sizeof(double));

    x = linspace(0, 1, N);
    y = linspace(0, 1, N);

    srand(seed);

    p_alfa = 0.77826511;
    p_beta = 0.3;

    xn1[0] = xn1[1] = xn1_aux[0] = xn1_aux[1] = 0;

    for (unsigned int i = 0; i < N; i++) {
        
        xn[0] = x[i];
        xn[1] = y[i];
        
        map_2d_n(xn1, xn, n_map, p_alfa, p_beta);

        fprintf(fp, "%.4E %.4E %.4E %.4E\n", xn[0], xn[1], xn1[0], xn1[1]);

    }

    fclose(fp);
    printf("Finished\n");
    return 0;
}

