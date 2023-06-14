#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Files to store things */
    FILE *fp, *fp1;

    fp = fopen("datafiles/two_dimensional_evolution_1.dat", "w");
    fp1 = fopen("datafiles/two_dimensional_error_evol_1.dat", "w");

    /* Hyper parameters */
    unsigned int N = 100000;
    unsigned int n_map = 14;
    double c = 1e-4;

    /* Map parameters */
    double alpha_c = 0.674149344;
    double alpha_i;
    double epsilon = 8.9999e-6;
    alpha_i = alpha_c - epsilon;
    double beta = 0.5;

    /* statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int ejection_counter = 0;
    unsigned int iterations = 0;
    unsigned int start_laminar = 0;

    reinjection_counter = 0;
    ejection_counter = 0;
    iterations = 0;
    start_laminar = 0;

    /* State variables */
    double* xn = calloc(2 , sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xerr = calloc(2, sizeof(double));
    double* x1err = calloc(2, sizeof(double));

    /* laminar length metrics */
    double l_avg = 0;
    double l_var = 0;
    double l_std = 0;

    xn[0] = 0.77;
    xn[1] = 0.57;
    xn1[0] = xn1[1] = 0;
    xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;    

    for (unsigned int j = 0; j < N; j+=2) {
        iterations++;
        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        if (j > 1000) {
            fprintf(fp, "%d %.8E %.8E %.8E %.8E\n", j, xn[0], xn[1], xn1[0], xn1[1]);
        }
        rel_err(xn, xn1, xerr);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
        iterations++;
        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        rel_err(xn, xn1, x1err);
        if (j > 1000) {
            fprintf(fp, "%d %.8E %.8E %.8E %.8E\n", j + 1, xn[0], xn[1], xn1[0], xn1[1]);
            fprintf(fp1, "%d %.8E %.8E %.8E %.8E\n", j, xerr[0], xerr[1], x1err[0], x1err[1]);
        }

        if (reinjection(x1err[0], xerr[0], c)) {
            start_laminar = iterations;
        }
        else if (ejection(x1err[0], xerr[0], c)) {
            ejection_counter++;
            printf("%d    %d    %d\n", ejection_counter, iterations - start_laminar, (iterations - start_laminar) * (iterations - start_laminar));
            l_avg += iterations - start_laminar;
            l_var += (iterations - start_laminar) * (iterations - start_laminar);

        }

        xn[0] = xn1[0];
        xn[1] = xn1[1];

    }
    
    l_avg = l_avg / (double) ejection_counter;
    l_var = l_var / ejection_counter;
    l_var = l_var - (l_avg * l_avg);
    l_std = sqrt(l_var);
    printf("%f    %f    %f\n", l_avg, l_var, l_std);

    fclose(fp);
    fclose(fp1);

   return 0;
}

