#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1, *fp2, *fp3;
    fp1 = fopen("datafiles/two_dimensional_test_evolution.dat", "w");
    fp2 = fopen("datafiles/two_dimensional_test_err_reinject.dat", "w");
    fp3 = fopen("datafiles/two_dimensional_test_lavg.dat", "w");

    unsigned int i, j, k;
    double alpha_c = 0.674103;
    double beta = 0.5;
    double alpha_i = 0;
    unsigned int n_mapa = 14;
    double epsilon, depsilon;
    unsigned int neps = 5000;
    unsigned int transient = 1000;

    epsilon = 1e-12;
    depsilon = 2e-13;

    unsigned int ejections_target = 10;
    unsigned int reinjections_target = 10;
    double c = 1e-5;

    /* Statistical variables */
    unsigned int reinjection_counter_x = 0;
    unsigned int ejection_counter_x = 0;
    unsigned int reinjection_counter_y = 0;
    unsigned int ejection_counter_y = 0;
    unsigned int iterations = 0;
    unsigned int iterations_absolute = 0;
    unsigned int start_laminar_x = 0;
    unsigned int start_laminar_y = 0;

    /* state variables */
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2,  sizeof(double));
    double* xn2 = calloc(2,  sizeof(double));
    double* xerr = calloc(2,  sizeof(double));
    double* x1err = calloc(2,  sizeof(double));


    /* laminar lengths */
    double laminar_avg_x = 0;
    double laminar_avg_y = 0;

    unsigned int seed = (unsigned int)time(NULL);

    init_genrand64((unsigned long long) seed);

    for (unsigned int i = 0; i < neps; i++) {

        xn[0] = 0.8; //genrand64_real3(); //.8;
        xn[1] = 0.7; //genrand64_real3(); //.7;

        xn1[0] = xn1[1] = 0;
        xn2[0] = xn2[1] = 0;
    
        xerr[0] = xerr[1] = 0;
        x1err[0] = x1err[1] = 0;

        reinjection_counter_x = 0;
        ejection_counter_x = 0;
        reinjection_counter_y = 0;
        ejection_counter_y = 0;
        iterations = 0;
        iterations_absolute = 0;
        start_laminar_x = 0;
        start_laminar_y = 0;

        laminar_avg_x = 0;
        laminar_avg_y = 0;

        map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);

        printf("epsilon = %5.15f\n", epsilon);

        while (ejection_counter_x < ejections_target || ejection_counter_y < ejections_target) {
            
            iterations_absolute++;
            iterations++;

            rel_err(xn, xn1, xerr);
            map_2d_n(xn2, xn1, n_mapa, alpha_c - epsilon, beta);
            rel_err(xn1, xn2, x1err);
            
            if (reinjection(x1err[0], xerr[0], c) && iterations > transient && reinjection_counter_x < reinjections_target) {
                reinjection_counter_x++;
                start_laminar_x = iterations;
            }
            else if (ejection(x1err[0], xerr[0], c) && reinjection_counter_x > 0 && iterations > transient  && ejection_counter_x < ejections_target) {     
                if (iterations - start_laminar_x > 1) {
                    ejection_counter_x++;
                    laminar_avg_x += (iterations - start_laminar_x);
                }
                else {
                    reinjection_counter_x-=1;
                }
            }

            if (reinjection(x1err[1], xerr[1], c) && iterations > transient && reinjection_counter_y < reinjections_target) {
                reinjection_counter_y++;
                start_laminar_y = iterations;
            }
            else if (ejection(x1err[1], xerr[1], c) && reinjection_counter_y > 0 && iterations > transient  && ejection_counter_y < ejections_target) {     
                if (iterations - start_laminar_y > 1) {
                    ejection_counter_y++;
                    laminar_avg_y += (iterations - start_laminar_y);
                }
                else {
                    reinjection_counter_x-=1;
                }
            }
            xn[0] = xn1[0];
            xn[1] = xn1[1];

            xn1[0] = xn2[0];
            xn1[1] = xn2[1];

            if (iterations % 1000000 == 0) {

                xn[0] = genrand64_real3();
                xn[1] = genrand64_real3();
                map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);
                xn2[0] = xn2[1] = 0;
                iterations = 0;
            }

            if ((ejection_counter_x == 0 || ejection_counter_y == 0) && iterations_absolute > 10e7) {
                ejection_counter_x = 1;
                ejection_counter_y = 1;
                break;
            }
        }
    
        printf("neps = %d\n", i);
        printf("reinjection counter x: %d, ejection counter x: %d\n", reinjection_counter_x, ejection_counter_x);
        printf("laminar avg x: %f\n", laminar_avg_x / (double) ejection_counter_x);
        printf("reinjection counter y: %d, ejection counter y: %d\n", reinjection_counter_y, ejection_counter_y);
        printf("laminar avg y: %f\n", laminar_avg_y / (double) ejection_counter_y);
        fprintf(fp3, "%5.15f   %5.15f   %5.15f\n", epsilon, laminar_avg_x / (double) ejection_counter_x, laminar_avg_y / (double) ejection_counter_y);
        if (i % 1000 == 0 && i != 0) {
            depsilon = depsilon * 1e2;
        }
        epsilon += depsilon;

    }
    free(xn);
    free(xn1);
    free(xn2);
    free(xerr);
    free(x1err);
    fclose(fp1);
    fclose(fp2);
    return 0;
}