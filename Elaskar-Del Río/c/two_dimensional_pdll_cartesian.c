#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE* fp = fopen("datafiles/Two_Dimensional_PDLL_Cartesian.dat", "w");

    unsigned int i, j;
    double alpha_c = 0.7782561;
    double beta = 0.3;
    unsigned int n_mapa = 14;

    unsigned int reinjections_target = 1e6;
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
    unsigned int n_bins_l = 100;
    double* lengths = malloc(reinjections_target * sizeof(double));
    double* l_pd = malloc(n_bins_l * sizeof(double));
    double* l_avg = malloc(n_bins_l * sizeof(double));
    double* l_bins = malloc(n_bins_l * sizeof(double));
    double l_min;
    double l_max;
    double l_exp = 0;

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
        map_2d_n(xn1, xn, n_mapa, alpha_c, beta);
        r1 = distance(xn1);
        rerr = rel_err_scalar(r, r1);
        map_2d_n(xn2, xn1, n_mapa, alpha_c, beta);
        r2 = distance(xn2);
        r1err = rel_err_scalar(r1, r2);

        if (reinjection(r1err, rerr, c)) {
            reinjection_counter++;
            start_laminar = iterations;
            if (reinjection_counter % 100000 == 0) {
                printf("%d\n", reinjection_counter);
            }
        }
        else if (ejection(r1err, rerr, c)) {
            lengths[reinjection_counter - 1] = iterations - start_laminar;

        }

        xn[0] = xn2[0];
        xn[1] = xn2[1];
    }

    l_min = min(lengths);
    l_max = max(lengths);

    n_bins_l = (unsigned int) l_max;

    l_bins = linspace(l_min, l_max, n_bins_l);

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
        l_exp = l_exp + l_pd[i] * l_avg[i];
        fprintf(fp, "%f %f  %f  %f\n", l_bins[i] + 1, l_pd[i], l_avg[i], l_exp);
    }

    fclose(fp);
    return 0;
}