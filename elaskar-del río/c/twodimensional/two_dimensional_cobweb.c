#include <stdlib.h>
#include <stdio.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp1 = fopen("datafiles/two_dimensional_f_g.dat", "w");
    FILE *fp2 = fopen("datafiles/two_dimensional_cobweb.dat", "w");


    unsigned int N = 2000;
    unsigned int n_map = 1;
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

    p_alfa = 0.674149344;
    p_beta = 0.5;

    xn1[0] = xn1[1] = xn1_aux[0] = xn1_aux[1] = 0;

    for (unsigned int i = 0; i < N; i++) {
        
        xn[0] = x[i];
        xn[1] = y[i];
        
        map_2d_n(xn1, xn, n_map, p_alfa, p_beta);

        fprintf(fp1, "%.4E %.4E %.4E %.4E\n", xn[0], xn[1], xn1[0], xn1[1]);
    }

    xn[0] = 0.7;
    xn[1] = 0.4;
    xn[0] = xn1[0] = 0;

    unsigned int n_cobweb = 10;
    double *xn_cobweb = calloc(n_cobweb, sizeof(double));
    double *xn1_cobweb = calloc(n_cobweb, sizeof(double));

    xn_cobweb[0] = xn[0];
    map_2d_n(xn1, xn, n_map, p_alfa, p_beta);
    xn1_cobweb[0] = xn1[0];

    for (unsigned int i = 1; i < n_cobweb - 1; i++) {
        
        xn_cobweb[i] = xn1_cobweb[i - 1];
        xn1_cobweb[i] = xn1_cobweb[i - 1];
        xn_cobweb[i + 1] = xn1_cobweb[i - 1];
        map_2d_n(xn1, xn, n_map, p_alfa, p_beta);
        xn1_cobweb[i + 1] = xn1[0];

    }

    for (unsigned int i = 0; i < N; i++) {
        fprintf(fp2, "%.12E   %.12E\n", xn_cobweb[i], xn1_cobweb[i]);
    }

    free(x);
    free(y);
    free(xn);
    free(xn1);
    free(xn_cobweb);
    free(xn1_cobweb);
    fclose(fp1);
    fclose(fp2);
    printf("Finished\n");
    return 0;
}

