#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Files to store things */
    FILE *fp, *fp1;

    fp = fopen("datafiles/two_dimensional_evolution.dat", "w");
    fp1 = fopen("datafiles/two_dimensional_error_evol.dat", "w");

    /* Hyper parameters */
    unsigned int N = 100000;
    unsigned int n_map = 14;

    /* Map parameters */
    double alpha_c = 0.674149344;
    double alpha_i;
    double epsilon = 1e-2;
    alpha_i = alpha_c - epsilon;
    double beta = 0.5;

    /* State variables */
    double* xn = calloc(2 , sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xerr = calloc(2, sizeof(double));
    double* x1err = calloc(2, sizeof(double));

    xn[0] = 0.77;
    xn[1] = 0.57;
    xn1[0] = xn1[1] = 0;
    xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;    

    for (unsigned int j = 0; j < N; j+=2) {        

        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        if (j > 1000) {
            fprintf(fp, "%d %.8E %.8E %.8E %.8E\n", j, xn[0], xn[1], xn1[0], xn1[1]);
        }
        rel_err(xn, xn1, xerr);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        rel_err(xn, xn1, x1err);
        if (j > 1000) {
            fprintf(fp, "%d %.8E %.8E %.8E %.8E\n", j + 1, xn[0], xn[1], xn1[0], xn1[1]);
            fprintf(fp1, "%d %.8E %.8E %.8E %.8E\n", j, xerr[0], xerr[1], x1err[0], x1err[1]);
        }
        xn[0] = xn1[0];
        xn[1] = xn1[1];

    }
    
    fclose(fp);
    fclose(fp1);

    return 0;
}

