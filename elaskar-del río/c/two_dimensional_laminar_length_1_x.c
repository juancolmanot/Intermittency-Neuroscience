#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Files to store things */
    FILE *fp, *fp1, *fp2;

    fp = fopen("datafiles/two_dimensional_evolution_2.dat", "w");
    fp1 = fopen("datafiles/two_dimensional_error_evol_2.dat", "w");
    fp2 = fopen("datafiles/two_dimensional_lavg.dat", "w");

    /* Hyper parameters */
    unsigned int N = 1000000;
    unsigned int n_map = 14;
    double c = 1e-4;

    /* Map parameters */
    unsigned int n_eps = 200;
    double alpha_c = 0.77826511;
    double beta = 0.3;
    double alpha_i;
    double *epsilon = calloc(n_eps, sizeof(double)); //8.99999e-6;
    epsilon = linspace(8.99974e-6, 1e-5, n_eps);
    
    /* statistical variables */
    unsigned int reinjection_counter = 0;
    unsigned int ejection_counter = 0;
    unsigned int iterations = 0;
    unsigned int start_laminar = 0;

    /* laminar length metrics */
    double l_avg = 0;
    double l_var = 0;
    double l_std = 0;

    /* State variables */
    double* xn = calloc(2 , sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xerr = calloc(2, sizeof(double));
    double* x1err = calloc(2, sizeof(double));

    for (unsigned int i = 0; i < n_eps; i++) {

        alpha_i = alpha_c - epsilon[i];

        reinjection_counter = 0;
        ejection_counter = 0;
        iterations = 0;
        start_laminar = 0;

        l_avg = 0;
        l_var = 0;
        l_std = 0;

        xn[0] = 0.77;
        xn[1] = 0.57;
        xn1[0] = xn1[1] = 0;
        xerr[0] = xerr[1] = x1err[0] = x1err[1] = 0;
        
        for (unsigned int j = 0; j < N; j+=1) {

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
                // printf("%d   %d   %d\n", ejection_counter, iterations - start_laminar, (iterations - start_laminar) *  (iterations - start_laminar));
            }
            iterations++;
            
            // fprintf(fp, "%d %.8E %.8E %.8E %.8E\n", j + 1, xn[0], xn[1], xn1[0], xn1[1]);
            // fprintf(fp1, "%d %.8E %.8E %.8E %.8E\n", j, xerr[0], xerr[1], x1err[0], x1err[1]);

            xn[0] = xn1[0];
            xn[1] = xn1[1];

            xerr[0] = x1err[0];
            xerr[1] = x1err[1];
        }
        
        l_avg = l_avg / (double) ejection_counter;
        l_var = l_var / ejection_counter;
        l_var = l_var - (l_avg * l_avg);
        l_std = sqrt(l_var);
        //printf("%.8E    %.8E    %.8E    %.8E\n", epsilon[i], l_avg, l_var, l_std);
        fprintf(fp2, "%.8E    %.8E    %.8E    %.8E    %.8E    %.8E\n", log(epsilon[i]), log(l_avg), epsilon[i], l_avg, l_var, l_std);
    }

    fclose(fp);
    fclose(fp1);
    fclose(fp2);

   return 0;
}