#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE* fp1 = fopen("datafiles/Two_Dimensional_RPD_Cartesian.dat", "w");
    FILE* fp2 = fopen("datafiles/Two_Dimensional_RPD_Cartesian_reinjected.dat", "w");

    unsigned int i, j;
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
    double r, r1, r2;
    double rerr, r1err;

    /* reinjected points array */
    unsigned int n_bins = 500;
    double* r_reinjected = malloc(reinjections_target * sizeof(double));
    double* r_rpd = malloc(n_bins * sizeof(double));
    double* r_bins = malloc(n_bins * sizeof(double));
    double r_min = 0;
    double r_max = 0;

    xn[0] = 0.4;
    xn[1] = 0.8;
    xn1[0] = xn1[1] = 0;
    xn2[0] = xn2[1] = 0;
    rerr = r1err = 0;
    r = distance(xn);
    r1 = distance(xn1);
    r2 = distance(xn2);

    reinjection_counter = 0;
    iterations = 0;

    while (reinjection_counter < reinjections_target) {
    
        iterations++;
        map_2d_n(xn1, xn, n_mapa, alpha_c, beta);
        r = distance(xn);
        r1 = distance(xn1);
        rerr = rel_err_scalar(r, r1);
        map_2d_n(xn2, xn1, n_mapa, alpha_c, beta);
        r2 = distance(xn2);
        r1err = rel_err_scalar(r1, r2);

        if (reinjection(r1err, rerr, c)) {
            r_reinjected[reinjection_counter] = r2;
            fprintf(fp2, "%d    %f\n", iterations, r2);
            reinjection_counter++;
            if (reinjection_counter % 10000 == 0) {
                printf("%d\n", reinjection_counter);
            }
        }

        xn[0] = xn2[0];
        xn[1] = xn2[1];
    }

    r_max = max(r_reinjected);
    r_min = min(r_reinjected);

    r_bins = linspace(r_min, r_max, n_bins);

    for (i = 0; i < n_bins - 1; i++) {
        for (j = 0; j < reinjections_target; j++) {
            if (r_reinjected[j] > r_bins[i] && r_reinjected[j] <= r_bins[i + 1]) {
                r_rpd[i] = r_rpd[i] + 1;
            }
        }
        r_rpd[i] = r_rpd[i] / (double)reinjections_target;
        fprintf(fp1, "%f  %f\n", r_bins[i], r_rpd[i]);
    }

    fclose(fp1);
    fclose(fp2);
    return 0;
}