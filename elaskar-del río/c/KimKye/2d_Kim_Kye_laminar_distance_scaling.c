#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include "../../../../../cursos/modulosc/mt64.h"
#include "../../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1;
    fp1 = fopen("../datafiles/two_dimensional_eps_lavg.dat", "w");
    
    double alpha_c = 0.674149344;
    double epsilon;
    double expeps = -5.05;
    double beta = 0.5;
    unsigned int n_mapa = 14;
    unsigned int n_eps = 100;
    
    unsigned int seed = (unsigned int)time(NULL);
    init_genrand64((unsigned long long) seed);

    double distance_n, distance_n1;
    double c = 1e-5;

    double cocient_i, no_eject;
    unsigned int transient = 1000;
    unsigned int eject_count, eject_target;
    unsigned int reinject_count, reinject_target;
    unsigned int iterations, start_laminar;
    unsigned int reinjected;
    eject_target = 2000;
    reinject_target = 2000;

    unsigned int n_bins_l;
    double *laminar_l;
    double *l_bins, *pl;
    double lmin, lmax;
    double lexp;

    laminar_l = calloc(eject_target, sizeof(double));

    /* state variables */
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2,  sizeof(double));
    double* xn2 = calloc(2,  sizeof(double));
    double x0, y0;

    epsilon = pow(10.0, expeps);

    x0 = genrand64_real3();
    y0 = genrand64_real3();

    for (unsigned int i = 0; i < n_eps; i++) {

        printf("i: %d, epsilon : %.12E, alpha_i: %5.15f\n", i, epsilon, alpha_c - epsilon);
        printf("Initial conditions: (%5.15f, %5.15f)\n", x0, y0);
        xn[0] = x0;
        xn[1] = y0;
        xn1[0] = xn1[1] = xn2[0] = xn2[1] = 0;

        eject_count = 0;
        reinject_count = 0;
        iterations = 0;
        start_laminar = 0;
        no_eject = 0;
        reinjected = 0;
        lexp = 0;

        while (eject_count < eject_target) {
            
            iterations++;
            map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);
            distance_n = (fabs(xn[0] - xn1[0]) / sqrt(2)) + (fabs(xn[1] - xn1[1]) / sqrt(2));
            map_2d_n(xn2, xn1, n_mapa, alpha_c - epsilon, beta);
            distance_n1 = (fabs(xn1[0] - xn2[0]) / sqrt(2)) + (fabs(xn1[1] - xn2[1]) / sqrt(2));
            
            if (iterations > transient) {
                if (distance_n > c && distance_n1 < c) {
                    reinject_count++;
                    start_laminar = iterations;
                    // printf("reinjected: %d\n", reinject_count);
                }
                else if (distance_n < c && distance_n1 > c && reinject_count > 0) {
                    laminar_l[eject_count] = iterations - start_laminar;
                    eject_count++;
                    // printf("ejected: %d\n", eject_count);
                }
            } 
            
            if (iterations % (int)1e7 == 0 && iterations >= (int) 1e7) {
                cocient_i = (double) iterations / 1e7;
                printf("%f  %d\n", cocient_i, eject_count);
                if (eject_count < cocient_i) {
                    no_eject = 1;
                    break;
                }
            }

            xn[0] = xn1[0];
            xn[1] = xn1[1];
            xn1[0] = xn2[0];
            xn1[1] = xn2[1];
        }

        printf("ejections: %d, reinjections: %d\n", eject_count, reinject_count);

        if (no_eject == 0) {
            lmin = min(laminar_l, eject_count);
            lmax = max(laminar_l, eject_count);

            n_bins_l = (unsigned int) (lmax - lmin);

            l_bins = calloc(n_bins_l, sizeof(double));
            pl = calloc(n_bins_l, sizeof(double)); 

            l_bins = linspace(lmin, lmax + 1, n_bins_l + 1);

            for (unsigned int i = 0; i < n_bins_l; i++) {
                for (unsigned int j = 0; j < eject_target; j++) {
                    if (l_bins[i] < laminar_l[j] && l_bins[i + 1] > laminar_l[j]) {
                        pl[i]++;
                    }
                }
                pl[i] /= (double) eject_count;
                lexp += l_bins[i] * pl[i];
            }
            fprintf(fp1, "%5.15f  %5.15f\n", epsilon, lexp);
            printf("%5.15f  %5.15f\n", log(epsilon), log(lexp));
        }
        else {
            printf("El sistema no presenta intermitencia para estas condiciones iniciales.\n");
            printf("%5.15f  %5.15f\n", log(epsilon), log(0.0));
            fprintf(fp1, "%5.15f  %5.15f\n", epsilon, 0.0);
        }
        expeps+=0.0025;
        epsilon = pow(10.0, expeps);
    }
    free(xn);
    free(xn1);
    free(l_bins);
    free(pl);
    fclose(fp1);
    return 0;
}