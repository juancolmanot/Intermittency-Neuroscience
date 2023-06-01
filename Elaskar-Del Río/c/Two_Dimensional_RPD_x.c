#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE* fp = fopen("datafiles/Two_Dimensional_RPD_x_test.dat", "w");

    unsigned int i, j;
    double alpha_c = 0.674149344;
    double beta = 0.5;
    double alpha_i = 0;
    unsigned int n_mapa = 14;
    double epsilon = 2e-5;

    alpha_i = alpha_c - epsilon;

    unsigned int reinjections_target = 1e6;
    double c = 1e-4;

    /* Statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int iterations = 0;

    /* state variables */
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2,  sizeof(double));
    double* xn2 = calloc(2,  sizeof(double));
    double* xerr = calloc(2,  sizeof(double));
    double* x1err = calloc(2,  sizeof(double));

    /* reinjected points */
    double* x_reinjected = calloc(reinjections_target, sizeof(double));
    unsigned int n_bins = 500;
    double * x_bins = calloc(n_bins, sizeof(double));
    double x_min, x_max;
    double* x_avg = calloc(n_bins, sizeof(double));
    double* x_rpd = calloc(n_bins, sizeof(double));
    double x_exp = 0;

    unsigned int seed = (unsigned int)rand();

    init_genrand64((unsigned long long) seed);

    xn[0] = genrand64_real3();
    xn[1] = genrand64_real3();

    xn1[0] = xn1[1] = 0;
    xn2[0] = xn2[1] = 0;
    xerr[0] = xerr[1] = 0;
    x1err[0] = x1err[1] = 0;

    reinjection_counter = 0;
    iterations = 0;

    while (reinjection_counter < reinjections_target) {

        iterations++;

        map_2d_n(xn1, xn, n_mapa, alpha_i, beta);
        rel_err(xn, xn1, xerr);
        map_2d_n(xn2, xn1, n_mapa, alpha_i, beta);
        rel_err(xn1, xn2, x1err);

        if (reinjection(x1err[0], xerr[0], c)) {
            if (reinjection_counter % (unsigned int) (reinjections_target * 0.2) == 0) {
                printf("iterations: %d  reinjections: %d\n", iterations, reinjection_counter);
                printf("completed: %5.15f%%\n", (double)reinjection_counter * 100/ (double)reinjections_target);
            }
            reinjection_counter++;
            x_reinjected[reinjection_counter - 1] = xn[0];
        }

        xn[0] = xn2[0];
        xn[1] = xn2[1];

        xn1[0] = xn1[1] = xn2[0] = xn2[1] = 0;

        // if (iterations % 1000000 == 0) {

        //     xn[0] = genrand64_real3();
        //     xn[1] = genrand64_real3();
        // }

    }

    x_max = max(x_reinjected, reinjections_target);
    x_min = min(x_reinjected, reinjections_target);

    x_bins = linspace(x_min, x_max, n_bins);

    for (i = 0; i < n_bins - 1; i++) {
        for (j = 0; j < reinjections_target; j++) {
            if (x_reinjected[j] <= x_bins[i + 1] && x_reinjected[j] > x_bins[i]) {
                x_avg[i] += x_reinjected[j];
                x_rpd[i] += 1;
            }
        }
        if (x_rpd[i] == 0) {
            x_avg[i] = 0;
        }
        else {
            x_avg[i] /= x_rpd[i];
            x_rpd[i] /= (double)reinjections_target; 
        }
        x_exp += x_avg[i] * x_rpd[i];
        fprintf(fp, "%5.15f %5.15f %5.15f %5.15f\n", x_bins[i], x_avg[i], x_rpd[i], x_exp);
        if (x_avg[i] != 0) {
            printf("%d  %f\n", i, x_avg[i]);
        }
    }
    
    free(xn);
    free(xn1);
    free(xn2);
    free(xerr);
    free(x1err);
    free(x_reinjected);
    free(x_bins);
    free(x_avg);
    free(x_rpd);
    fclose(fp);
    return 0;
}
