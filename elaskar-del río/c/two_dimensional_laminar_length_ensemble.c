#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Files to store things */
    FILE *fp, *fp1, *fp2;

    fp = fopen("datafiles/two_dimensional_evolution_ensemble.dat", "w");
    fp1 = fopen("datafiles/two_dimensional_error_evol_ensemble.dat", "w");

    /* Hyper parameters */
    unsigned long long seed = 8342;
    unsigned int valid_count = 0;
    unsigned int N = 10000000;
    unsigned int n_map = 14;
    double c = 1e-4;

    /* Map parameters */
    unsigned int n_tries = 50;
    double alpha_c = 0.674149344;
    double beta = 0.5;
    double alpha_i;
    double epsilon = 8.9998e-6;
    alpha_i = alpha_c - epsilon;
    
    /* statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int ejection_counter = 0;
    unsigned int iterations = 0;
    unsigned int start_laminar = 0;

    /* laminar length metrics */
    double l_avg = 0;
    double l_var = 0;
    double l_std = 0;

    /* mean length of the mean lengths */
    double l_exp = 0;

    /* State variables */
    double* xn = calloc(2 , sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xerr = calloc(2, sizeof(double));
    double* x1err = calloc(2, sizeof(double));

    init_genrand64(seed);

    for (unsigned int i = 0; i < n_tries; i++) {

        reinjection_counter = 0;
        ejection_counter = 0;
        iterations = 0;
        start_laminar = 0;

        l_avg = 0;
        l_var = 0;
        l_std = 0;

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
                l_var += (double) ((iterations - start_laminar) * (iterations - start_laminar));
            }
            iterations++;
            
            // fprintf(fp, "%d %.8E %.8E %.8E %.8E\n", j + 1, xn[0], xn[1], xn1[0], xn1[1]);
            // fprintf(fp1, "%d %.8E %.8E %.8E %.8E\n", j, xerr[0], xerr[1], x1err[0], x1err[1]);

            xn[0] = xn1[0];
            xn[1] = xn1[1];

            xerr[0] = x1err[0];
            xerr[1] = x1err[1];
        }
        
        if (ejection_counter > 0) {
            valid_count++;
            l_avg = l_avg / (double) ejection_counter;
            l_exp += l_avg;
            l_var = l_var / ejection_counter;
            l_var = l_var - (l_avg * l_avg);
            l_std = sqrt(l_var);
            printf("%d    %.8E    %.8E    %.8E\n", ejection_counter, l_avg, l_var, l_std);
        }
    }

    l_exp = l_exp / (double)valid_count;
    printf("%f    %f\n", l_exp, log(l_exp));
    
    fclose(fp);
    fclose(fp1);

   return 0;
}