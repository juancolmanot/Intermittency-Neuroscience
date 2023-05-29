#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <omp.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE* fp = fopen("datafiles/Two_Dimensional_PDLL_Scaling_x.dat", "w");

    unsigned int i, j, k;
    double alpha_c = 0.7782561;
    double beta = 0.3;
    double alpha_i = 0;
    unsigned int n_mapa = 14;
    unsigned int n_eps = 20;
    double* epsilon;

    epsilon = linspace(-1e-6, 1e-6, n_eps);

    unsigned int reinjections_target = 1e5;
    double c = 1e-4;

    /* Statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int iterations = 0;
    unsigned int start_laminar = 0;

    /* seeds */

    unsigned int* seeds = calloc(n_eps, sizeof(double));

    for (unsigned int i = 0; i < n_eps; i++) {

        seeds[i] = (unsigned int)rand();
    }

    /* laminar lengths */
    double* l_exp = calloc(n_eps, sizeof(double));

    #pragma omp parallel for
    for (i = 0; i < n_eps; i++) {

        /* state variables */
        double* xn = calloc(2, sizeof(double));
        double* xn1 = calloc(2,  sizeof(double));
        double* xn2 = calloc(2,  sizeof(double));
        double* xerr = calloc(2,  sizeof(double));
        double* x1err = calloc(2,  sizeof(double));

        init_genrand64((unsigned long long) seeds[i]);

        double* lengths = calloc(reinjections_target, sizeof(double));

        alpha_i = alpha_c + epsilon[i];
    
        xn[0] = genrand64_real3();
        xn[1] = genrand64_real3();
        xn1[0] = xn1[1] = 0;
        xn2[0] = xn2[1] = 0;

        reinjection_counter = 0;
        iterations = 0;
        start_laminar = 0;
        while (reinjection_counter < reinjections_target) {
            
            iterations++;

            map_2d_n(xn1, xn, n_mapa, alpha_i, beta);
            rel_err(xn, xn1, xerr);
            map_2d_n(xn2, xn1, n_mapa, alpha_i, beta);
            rel_err(xn1, xn2, x1err);

            if (reinjection(x1err[0], xerr[0], c)) {
                reinjection_counter++;
                start_laminar = iterations;
                if (reinjection_counter % (unsigned int)(reinjections_target * 0.25) == 0) {
                    int thread_n = omp_get_thread_num();
                    printf("Thread %d: %d  %d\n", thread_n, i, reinjection_counter);
                }
            }
            else if (ejection(x1err[0], xerr[0], c) && reinjection_counter > 0) {
                lengths[reinjection_counter - 1] = iterations - start_laminar;

            }
            xn[0] = xn2[0];
            xn[1] = xn2[1];

            xn1[0] = xn1[1] = xn2[0] = xn2[1] = 0;

            if (iterations % 1000000 == 0) {
                xn[0] = genrand64_real3();
                xn[1] = genrand64_real3();
            }

        }

        unsigned int n_bins_l;

        n_bins_l = (unsigned int) max(lengths);

        double* l_pd = calloc(n_bins_l,  sizeof(double));
        double* l_avg = calloc(n_bins_l,  sizeof(double));
        
        for (j = 0; j < n_bins_l - 1; j++) {
            for (k = 0; k < reinjections_target; k++) {
                if (lengths[k] > j + 1 && lengths[k] <= j + 2) {
                    l_avg[j] += lengths[k];
                    l_pd[j] += 1;
                }
            }
            if (l_pd[j] != 0) {
                l_avg[j] = l_avg[j] / l_pd[j];
            }
            else if (l_pd[j] == 0) {
                l_avg[j] = 0;
            }
            l_pd[j] = l_pd[j] / (double)reinjections_target;
            l_exp[i] += l_pd[j] * l_avg[j];
        }
        free(lengths);
        free(l_avg);
        free(l_pd);
        free(xn);
        free(xn1);
        free(xn2);
        free(xerr);
        free(x1err);
    }

    for (unsigned int i = 0; i < n_eps; i++) {

        fprintf(fp, "%5.15f %5.15f\n", epsilon[i], l_exp[i]);
    }
    free(l_exp);
    free(seeds);
    
    fclose(fp);
    return 0;
}