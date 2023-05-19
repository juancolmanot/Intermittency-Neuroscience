#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

void rel_err(double* x, double* x1, double* xerr) {
    
    xerr[0] = abs((x1[0] - x[0]) / x[0]);
    xerr[1] = abs((x1[1] - x[1]) / x[1]);

}

int main() {

    /* Open file to data*/

    FILE* fp = fopen("datafiles/Two_Dimensional_Scalation_l.dat", "w");

    /* Hyper parameters and variables */
    unsigned int i, j, k;
    unsigned int n_eps = 2e1;
    double alpha_c = 0.77826511;
    double beta = 0.3;
    unsigned int n_mapa = 14;
    double alpha_i;

    /* Parameters for reinjection and intermittency */
    unsigned int reinjections_target = 1e4;
    unsigned int n_bins_l = 1e2;
    double c = 1e-4;
    double* l_expected = malloc(n_eps * sizeof(double));
    double* epsilon = malloc(n_eps * sizeof(double));

    /* Statistical variables */
    double* lengths_x = malloc(reinjections_target * sizeof(double));
    unsigned int reinjection_counter = 0;
    unsigned int iterations = 0;
    unsigned int start_laminar = 0;

    /* state variables */
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));
    double* xerr = malloc(2 * sizeof(double));
    double* x1err = malloc(2 * sizeof(double));

    /* length arrays */
    double* l_count = malloc(n_bins_l * sizeof(double));
    double* l_avg = malloc(n_bins_l * sizeof(double));
    double* l_bins = malloc(n_bins_l * sizeof(double));
    double min_l;
    double max_l;

    epsilon = linspace(-24, -19, n_eps);

    for (i = 0; i < n_eps; i++) {

        alpha_i = alpha_c; // - exp(epsilon[i]);

        xn[0] = 0.4;
        xn[1] = 0.8;
        xn1[0] = xn1[1] = 0;
        xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;

        while (reinjection_counter < reinjections_target) {
        
            iterations++;
            printf("a --- %f  %f\n", xn[0], xn1[0], xn[1], xn1[1]);
            map_2d_n(xn1, xn, n_mapa, alpha_i, beta);
            printf("b --- %f  %f\n", xn[0], xn1[0], xn[1], xn1[1]);
            rel_err(xn, xn1, xerr);
            xn = xn1;
            printf("c --- %f  %f\n", xn[0], xn1[0], xn[1], xn1[1]);
            map_2d_n(xn1, xn, n_mapa, alpha_i, beta);
            printf("d --- %f  %f\n", xn[0], xn1[0], xn[1], xn1[1]);
            rel_err(xn, xn1, x1err);

            if (reinjection(x1err[0], xerr[0], c, 0)) {
                start_laminar = iterations;
                reinjection_counter++;
                if (reinjection_counter % 100 == 0) {
                    printf("%f  %f  %d\n", epsilon[i], alpha_i, reinjection_counter);
                }
            }
            else if (ejection(x1err[0], xerr[0], c, 0)) {
                lengths_x[reinjection_counter - 1] = iterations - start_laminar;
            }

            xn = xn1;
            printf("e --- %f  %f\n", xn[0], xn1[0], xn[1], xn1[1]);
        }

        memset(l_count, 0, sizeof l_count);
        memset(l_avg, 0, sizeof l_avg);
        memset(l_bins, 0, sizeof l_bins);

        min_l = min(lengths_x);
        max_l = max(lengths_x);

        l_bins = linspace(min_l, max_l, n_bins_l);

        for (j = 0; j < reinjections_target; j++) {
            for (k = 0; k < n_bins_l - 1; k++) {
                    if (lengths_x[j] < l_bins[k + 1] && lengths_x[j] >= l_bins[k]) {
                        l_count[k] = l_count[k] + 1;
                        l_avg[k] = l_avg[k] + lengths_x[j];
                    }
            }
        }

        for (j = 0; j < n_bins_l; j++) {
            l_count[j] = l_count[j] * (1 / reinjections_target);

            if (l_count[j] != 0) {
                l_avg[j] = l_avg[j] / l_count[j];
            }
            else {
                l_avg[j] = 0;
            }
        
            l_expected[i] = l_expected[i] + (l_avg[j] * l_count[j]);
        }
    }

    for (i = 0; i < n_eps; i++) {
        fprintf(fp, "%f %f\n", epsilon[i], l_expected[i]);
    }
    
    fclose(fp);
    return 0;

}