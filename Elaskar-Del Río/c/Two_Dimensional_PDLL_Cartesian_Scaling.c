#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE* fp = fopen("datafiles/Two_Dimensional_PDLL_Cartesian_Scaling.dat", "w");

    unsigned int i, j, k;
    double alpha_c = 0.7782561;
    double beta = 0.3;
    double alpha_i = 0;
    unsigned int n_mapa = 14;
    unsigned int n_eps = 20;
    double* epsilon;

    epsilon = linspace(-22, -19, n_eps);

    unsigned int reinjections_target = 1e4;
    double c = 1e-4;

    /* Statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int iterations = 0;
    unsigned int start_laminar = 0;

    /* state variables */
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));
    double* xn2 = malloc(2 * sizeof(double));
    double r, r1, r2;
    double rerr, r1err;

    /* laminar lengths */
    unsigned int n_bins_l;
    double* lengths = malloc(reinjections_target * sizeof(double));
    double* l_pd;
    double* l_avg;
    double* l_bins;
    double l_min;
    double l_max;
    double l_exp = 0;

    for (i = 0; i < n_eps; i++) {

        alpha_i = alpha_c - exp(epsilon[i]);
    
        xn[0] = 0.4;
        xn[1] = 0.8;
        xn1[0] = xn1[1] = 0;
        xn2[0] = xn2[1] = 0;
        rerr =  r1err = 0;

        reinjection_counter = 0;
        iterations = 0;
        start_laminar = 0;
        while (reinjection_counter < reinjections_target) {
            iterations++;
            r = distance(xn);
            map_2d_n(xn1, xn, n_mapa, alpha_i, beta);
            r1 = distance(xn1);
            rerr = rel_err_scalar(r, r1);
            map_2d_n(xn2, xn1, n_mapa, alpha_i, beta);
            r2 = distance(xn2);
            r1err = rel_err_scalar(r1, r2);
            if (reinjection(r1err, rerr, c)) {
                reinjection_counter++;
                start_laminar = iterations;
                if (reinjection_counter % 2500 == 0) {
                    printf("%d  %d\n", i, reinjection_counter);
                }
            }
            else if (ejection(r1err, rerr, c) && reinjection_counter > 0) {
                lengths[reinjection_counter - 1] = iterations - start_laminar;

            }
            xn[0] = xn2[0];
            xn[1] = xn2[1];
        }

        l_min = min(lengths);
        l_max = max(lengths);

        n_bins_l = (unsigned int) l_max;

        l_avg = malloc(n_bins_l * sizeof(double));
        l_pd = malloc(n_bins_l * sizeof(double));

        l_bins = linspace_discrete(l_min, l_max, n_bins_l);

        l_exp = 0;

        for (j = 0; j < n_bins_l - 1; j++) {
            for (k = 0; k < reinjections_target; k++) {
                if (lengths[k] > l_bins[j] && lengths[k] <= l_bins[j + 1]) {
                    l_avg[j] = l_avg[j] + lengths[k];
                    l_pd[j] = l_pd[j] + 1;
                }
            }
            if (l_pd[j] != 0) {
                l_avg[j] = l_avg[j] / l_pd[j];
            }
            else if (l_pd[j] == 0) {
                l_avg[j] = 0;
            }
            l_pd[j] = l_pd[j] / (double)reinjections_target;
            l_exp = l_exp + l_pd[j] * l_avg[j];
        }

        fprintf(fp, "%f %f  %f  %f\n", epsilon[i], l_exp, log(alpha_c - alpha_i), log(l_exp));
        free(l_avg);
        free(l_pd);
        free(l_bins);
    
    }

    fclose(fp);
    return 0;
}