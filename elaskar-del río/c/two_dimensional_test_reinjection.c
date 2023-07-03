#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1, *fp2, *fp3, *fp4, *fp5;
    fp1 = fopen("datafiles/two_dimensional_test_evolution_x.dat", "w");
    fp2 = fopen("datafiles/two_dimensional_test_evolution_y.dat", "w");
    fp3 = fopen("datafiles/two_dimensional_test_lavg_x.dat", "w");
    fp4 = fopen("datafiles/two_dimensional_test_lavg_y.dat", "w");
    fp5 = fopen("datafiles/two_dimensional_test_lavg_xy.dat", "w");

    unsigned int i, j, k;
    double alpha_c = 0.674103;
    double beta = 0.5;
    double alpha_i = 0;
    unsigned int n_mapa = 14;
    double epsilon, depsilon;
    unsigned int neps = 100;
    unsigned int nexp = 1;
    unsigned int transient = 1000;

    unsigned int ejections_target = 10;
    unsigned int reinjections_target = 10;
    double cx, cy;
    cx = 1e-4;
    cy = 1e-4;

    unsigned int n_exp_succesfull = 0;

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

    double x0, y0;

    x0 = 0.3;
    y0 = 0.5;

    /* laminar lengths */
    double laminar_avg_x = 0;
    double laminar_avg_y = 0;
    double laminar_exp_x = 0;
    double laminar_exp_y = 0;

    double *lengths = calloc(2 * neps, sizeof(double));
    double *epsilons = calloc(neps, sizeof(double));

    epsilon = 1e-11;
    depsilon = 1e-12;

    unsigned int seed = (unsigned int)time(NULL);

    init_genrand64((unsigned long long) seed);

    for (unsigned int i = 0; i < neps; i++) {

        laminar_exp_x = 0;

        printf("x - n: %d  epsilon = %5.15f\n", i, epsilon);

        for (unsigned int j = 0; j < nexp; j++) {

            printf("x - experiment = %d\n", j);
            
            xn[0] = x0; //genrand64_real3(); //
            xn[1] = y0; // genrand64_real3(); //.7;

            xn1[0] = xn1[1] = 0;
            xn2[0] = xn2[1] = 0;
        
            xerr[0] = xerr[1] = 0;
            x1err[0] = x1err[1] = 0;

            reinjection_counter_x = 0;
            ejection_counter_x = 0;
            iterations = 0;
            iterations_absolute = 0;
            start_laminar_x = 0;
        
            laminar_avg_x = 0;
        
            map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);

            while (ejection_counter_x < ejections_target) {
                
                iterations_absolute++;
                iterations++;

                fprintf(fp1, "%d   %5.15f   %5.15f\n", iterations_absolute, xn[0], xerr[0]);

                distance_line(xn, xn1, xerr);
                map_2d_n(xn2, xn1, n_mapa, alpha_c - epsilon, beta);
                distance_line(xn1, xn2, x1err);
                
                if (reinjection(x1err[0], xerr[0], cx) && iterations > transient && reinjection_counter_x < reinjections_target) {
                    reinjection_counter_x++;
                    start_laminar_x = iterations;
                }
                else if (ejection(x1err[0], xerr[0], cx) && reinjection_counter_x > 0 && iterations > transient  && ejection_counter_x < ejections_target) {     
                    if (iterations - start_laminar_x > 2) {
                        ejection_counter_x++;
                        laminar_avg_x += (iterations - start_laminar_x);
                    }
                    else {
                        reinjection_counter_x-=1;
                    }
                }
                
                xn[0] = xn1[0];
                xn[1] = xn1[1];

                xn1[0] = xn2[0];
                xn1[1] = xn2[1];

                // if (iterations % 1000000 == 0) {

                //     xn[0] = genrand64_real3();
                //     xn[1] = genrand64_real3();
                //     map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);
                //     xn2[0] = xn2[1] = 0;
                //     iterations = 0;
                // }

                if (ejection_counter_x == 0 && iterations_absolute > 10e7) {
                    ejection_counter_x = 1;
                    break;
                }

            }
            if (laminar_avg_x != 0) {
                laminar_exp_x += laminar_avg_x / (double) ejection_counter_x;
                n_exp_succesfull++;
            }
            printf("reinjection counter x: %d, ejection counter x: %d\n", reinjection_counter_x, ejection_counter_x);
            printf("laminar avg exp x: %f\n", laminar_avg_x / (double) ejection_counter_x);
        }
        lengths[i] = laminar_exp_x / (double) n_exp_succesfull;
        fprintf(fp3, "%5.15f   %5.15f\n", epsilon, laminar_exp_x / (double) n_exp_succesfull);
        if (i % 20 == 0 && i != 0) {
            depsilon = depsilon * 1e1;
        }
        epsilons[i] = epsilon;
        epsilon += depsilon;
    }
    epsilon = 1e-11;
    depsilon = 1e-12;
    
    n_exp_succesfull = 0;

    for (unsigned int i = 0; i < neps; i++) {
        
        laminar_exp_x = 0;

        printf("x - n: %d  epsilon = %5.15f\n", i, epsilon);

        for (unsigned int j = 0; j < nexp; j++) {
            xn[0] = x0; //genrand64_real3(); //.8;
            xn[1] = y0; //genrand64_real3(); //.7;

            xn1[0] = xn1[1] = 0;
            xn2[0] = xn2[1] = 0;
        
            xerr[0] = xerr[1] = 0;
            x1err[0] = x1err[1] = 0;

            reinjection_counter_y = 0;
            ejection_counter_y = 0;
            iterations = 0;
            iterations_absolute = 0;
            start_laminar_y = 0;
            laminar_avg_y = 0;

            map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);
            printf("y - experiment = %d\n", j);

            while (ejection_counter_y < ejections_target) {
                
                iterations_absolute++;
                iterations++;

                fprintf(fp2, "%d   %5.15f   %5.15f\n", iterations_absolute, xn[1], xerr[1]);

                distance_line(xn, xn1, xerr);
                map_2d_n(xn2, xn1, n_mapa, alpha_c - epsilon, beta);
                distance_line(xn1, xn2, x1err);
                
                if (reinjection(x1err[1], xerr[1], cy) && iterations > transient && reinjection_counter_y < reinjections_target) {
                    reinjection_counter_y++;
                    start_laminar_y = iterations;
                }
                else if (ejection(x1err[1], xerr[1], cy) && reinjection_counter_y > 0 && iterations > transient  && ejection_counter_y < ejections_target) {     
                    if (iterations - start_laminar_y > 2) {
                        ejection_counter_y++;
                        laminar_avg_y += (iterations - start_laminar_y);
                    }
                    else {
                        reinjection_counter_y-=1;
                    }
                }

                xn[0] = xn1[0];
                xn[1] = xn1[1];

                xn1[0] = xn2[0];
                xn1[1] = xn2[1];

                // if (iterations % 1000000 == 0) {

                //     xn[0] = genrand64_real3();
                //     xn[1] = genrand64_real3();
                //     map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);
                //     xn2[0] = xn2[1] = 0;
                //     iterations = 0;
                // }

                if (ejection_counter_y == 0 && iterations_absolute > 10e7) {
                    ejection_counter_y = 1;
                    break;
                }
            }
            
            printf("reinjection counter y: %d, ejection counter y: %d\n", reinjection_counter_y, ejection_counter_y);
            printf("laminar avg y: %f\n", laminar_avg_y / (double) ejection_counter_y);
            if (laminar_avg_y != 0) {
                laminar_exp_y += laminar_avg_y / (double) ejection_counter_y;
                n_exp_succesfull++;
            }
        }
        lengths[i + neps] = laminar_exp_y / (double) n_exp_succesfull;
        fprintf(fp4, "%5.15f   %5.15f\n", epsilon, laminar_exp_y / (double) n_exp_succesfull);
        if (i % 20 == 0 && i != 0) {
            depsilon = depsilon * 1e1;
        }
        epsilon += depsilon;
    }

    for (unsigned int i = 0; i < neps; i++){
        fprintf(fp5, "%5.15f   %5.15f\n", epsilons[i], lengths[i] * lengths[i + neps]);
    }

    free(xn);
    free(xn1);
    free(xn2);
    free(xerr);
    free(x1err);
    fclose(fp1);
    fclose(fp2);
    fclose(fp3);
    fclose(fp4);
    return 0;
}