    #include <stdlib.h>
    #include <stdio.h>
    #include <math.h>
    #include <string.h>
    #include "../../../../cursos/modulosc/linear_algebra.h"
    #include "../../../../cursos/modulosc/intermittency.h"

    void rel_err(double* x, double* x1, double* xerr) {

        xerr[0] = fabs((x1[0] - x[0]) / x[0]);
        xerr[1] = fabs((x1[1] - x[1]) / x[1]);
    }

    int main() {

        FILE* fp = fopen("datafiles/Two_Dimensional_Scalation_l.dat", "w");

        unsigned int i, j, k;
        unsigned int n_eps = 20;
        double alpha_c = 0.77826511;
        double beta = 0.3;
        double alpha_i;
        double* epsilon;
        unsigned int n_mapa = 14;

        epsilon = linspace(alpha_c * (1 - 0.05), alpha_c * (1 - 0.01), n_eps);

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
        double* xerr = malloc(2 * sizeof(double));
        double* x1err = malloc(2 * sizeof(double));

        /* laminar lengths */
        unsigned int n_bins_l;
        double* l_pd;
        double* l_avg;
        double* l_bins;
        double* lengths = malloc(reinjections_target * sizeof(double));
        double l_min;
        double l_max;
        double l_exp = 0;

        for (k = 0; k < n_eps; k++){
            alpha_i = epsilon[k];

            xn[0] = 0.4;
            xn[1] = 0.8;
            xn1[0] = xn1[1] = 0;
            xn2[0] = xn2[1] = 0;
            xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;

            reinjection_counter = 0;
            iterations = 0;
            start_laminar = 0;

            while (reinjection_counter < reinjections_target) {

                iterations++;
                map_2d_n(xn1, xn, n_mapa, alpha_i, beta);
                rel_err(xn, xn1, xerr);
                map_2d_n(xn2, xn1, n_mapa, alpha_i, beta);
                rel_err(xn1, xn2, x1err);

                if (reinjection(x1err[0], xerr[0], c, 0)) {
                    reinjection_counter++;
                    start_laminar = iterations;
                    if (reinjection_counter % 2000 == 0) {
                        printf("%d  %d\n", k, reinjection_counter);
                    }
                }
                else if (ejection(x1err[0], xerr[0], c, 0)) {
                    lengths[reinjection_counter - 1] = iterations - start_laminar;
                }

                xn[0] = xn2[0];
                xn[1] = xn2[1];
            }

            l_min = min(lengths);
            l_max = max(lengths);
            n_bins_l = (unsigned int)l_max;
        

            for (i = 0; i < n_bins_l; i++) {
                for (j = 0; j < reinjections_target; j++) {
                    if (lengths[j] > l_bins[i] && lengths[j] <= l_bins[i + 1]) {
                        l_avg[i] = l_avg[i] + lengths[j];
                        l_pd[i] = l_pd[i] + 1;
                    }
                }
                if (l_pd[i] != 0) {
                    l_avg[i] = l_avg[i] / l_pd[i];

                }
                else if (l_pd[i] == 0) {
                    l_avg[i] = 0;
                }
                l_pd[i] = l_pd[i] / (double)reinjections_target;
            }

            l_exp = 0;
            for (i = 0; i < n_bins_l; i++) {
                l_exp = l_exp + l_avg[i] * l_pd[i];
            }

            fprintf(fp, "%f %f\n", epsilon[k], l_exp);
            free(l_avg);
            free(l_pd);
            free(l_bins);

        }
        
        fclose(fp);
        return 0;
    }