#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Files to store things */
    FILE *fp;

    fp = fopen("datafiles/two_dimensional_laminar_scaling_1.dat", "w");
    
    /* Hyper parameters */
    unsigned long long seed = 8342;
    unsigned int valid_count = 0;
    unsigned int N = 10000000;
    unsigned int n_map = 14;
    double c = 1e-4;

    /* Map parameters */
    unsigned int n_eps = 400;
    unsigned int n_tries = 50;
    double alpha_c = 0.77862511;
    double beta = 0.3;
    double alpha_i;
    double *epsilon = calloc(n_eps, sizeof(double));
    double min_eps = 1e-11;
    double max_eps = 1e-4;

    epsilon = linspace(min_eps, max_eps, n_eps);

    /* statistical variables */
    unsigned int reinjection_counter;
    unsigned int ejection_counter;
    unsigned int iterations;
    unsigned int start_laminar;

    /* laminar length metrics */
    double l_avg;

    /* mean length of the mean lengths */
    double l_exp;

    /* State variables */
    double* xn = calloc(2 , sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xerr = calloc(2, sizeof(double));
    double* x1err = calloc(2, sizeof(double));

    init_genrand64(seed);

    for (unsigned int k = 0; k < n_eps; k++) {

        l_exp = 0;
        alpha_i = alpha_c - epsilon[k];
        printf("Progress %5.2f%%\n", (double) k * 100 / (double)n_eps);

        for (unsigned int i = 0; i < n_tries; i++) {

            reinjection_counter = 0;
            ejection_counter = 0;
            iterations = 0;
            start_laminar = 0;

            l_avg = 0;

            xn[0] = genrand64_real3();
            xn[1] = genrand64_real3();
            xn1[0] = xn1[1] = 0;
            xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;
            
            for (unsigned int j = 0; j < N; j++) {

                map_2d_n(xn1, xn, n_map, alpha_i, beta);
                rel_err(xn, xn1, x1err);

                if (xerr[0] > c && x1err[0] < c && iterations > 2) {
                    reinjection_counter++;
                    start_laminar = iterations;
                }
                else if (xerr[0] < c && x1err[0] > c && iterations > 2 && reinjection_counter > 0) {
                    ejection_counter++;
                    l_avg += (double) (iterations - start_laminar);
                }
                iterations++;
                
                xn[0] = xn1[0];
                xn[1] = xn1[1];

                xerr[0] = x1err[0];
                xerr[1] = x1err[1];
            }
            
            if (ejection_counter > 0) {
                valid_count++;
                l_avg = l_avg / (double) ejection_counter;
                l_exp += l_avg;
            }
        }

        l_exp = l_exp / (double)valid_count;
        fprintf(fp, "%.8E    %.8E    %.8E    %.8E\n", epsilon[k], l_exp, log(epsilon[k]), (l_exp));
    }
    
    return 0;
}