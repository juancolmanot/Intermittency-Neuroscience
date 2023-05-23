#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

void rel_err(double* x, double* x1, double* xerr) {

    xerr[0] = fabs((x1[0] - x[0]) / x[0]);
    xerr[1] = fabs((x1[1] - x[1]) / x[1]);
}

int main() {

    FILE* fp = fopen("datafiles/Two_Dimensional_RPD.dat", "w");

    unsigned int i, j, k;
    unsigned int n_eps = 20;
    double alpha_c = 0.674103;
    double beta = 0.5;
    unsigned int n_mapa = 14;

    unsigned int reinjections_target = 1e5;
    double c = 1e-4;

    /* Statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int iterations = 0;

    /* state variables */
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));
    double* xn2 = malloc(2 * sizeof(double));
    double* xerr = malloc(2 * sizeof(double));
    double* x1err = malloc(2 * sizeof(double));

    /* reinjected points array */
    unsigned int n_bins = 500;
    double* x_reinjected = malloc(reinjections_target * sizeof(double));
    double* x_rpd = malloc(n_bins * sizeof(double));
    double* x_bins = malloc(n_bins * sizeof(double));
    double x_min = 0;
    double x_max = 0;

    xn[0] = 0.4;
    xn[1] = 0.8;
    xn1[0] = xn1[1] = 0;
    xn2[0] = xn2[1] = 0;
    xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;

    reinjection_counter = 0;
    iterations = 0;

    while (reinjection_counter < reinjections_target) {
    
        iterations++;
        map_2d_n(xn1, xn, n_mapa, alpha_c, beta);
        rel_err(xn, xn1, xerr);
        // xn[0] = xn1[0];
        // xn[1] = xn1[1];
        map_2d_n(xn2, xn1, n_mapa, alpha_c, beta);
        rel_err(xn1, xn2, x1err);

        if (reinjection(x1err[0], xerr[0], c, 0)) {
            x_reinjected[reinjection_counter] = xn2[0];
            reinjection_counter++;
            if (reinjection_counter % 10000 == 0) {
                printf("%d\n", reinjection_counter);
            }
        }

        xn[0] = xn2[0];
        xn[1] = xn2[1];
    }

    x_max = max(x_reinjected);
    x_min = min(x_reinjected);

    x_bins = linspace(x_min, x_max, n_bins);

    for (i = 0; i < n_bins - 1; i++) {
        for (j = 0; j < reinjections_target; j++) {
            if (x_reinjected[j] > x_bins[i] && x_reinjected[j] <= x_bins[i + 1]) {
                x_rpd[i] = x_rpd[i] + 1;
            }
        }
        x_rpd[i] = x_rpd[i] / (double)reinjections_target;
        fprintf(fp, "%f  %f\n", x_bins[i], x_rpd[i]);
    }

    fclose(fp);
    return 0;
}