#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include "../../../../../cursos/modulosc/mt64.h"
#include "../../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1, *fp2, *fp3;
    fp1 = fopen("../datafiles/two_dimensional_rpd_x.dat", "w");
    fp2 = fopen("../datafiles/two_dimensional_epd_x.dat", "w");
    fp3 = fopen("../datafiles/two_dimensional_laminar_stats.dat", "w");
    
    double alpha_c = 0.674149344;
    double epsilon = 9e-6;
    double beta = 0.5;
    unsigned int n_mapa = 14;
    
    unsigned int seed = (unsigned int)time(NULL);
    init_genrand64((unsigned long long) seed);

    double distance_n, distance_n1;
    double c = 1e-5;

    double cocient_i, no_eject;
    unsigned int eject_count, eject_target;
    unsigned int reinject_count, reinject_target;
    unsigned int iterations, start_laminar;
    unsigned int reinjected;
    eject_target = 1000;
    reinject_target = 1000;

    unsigned int n_bins_x = 200, n_bins_l;
    double *x_reinject, *x_eject, *laminar_l, *l_x_count;
    double *x_bins, *l_bins, *x_rpd, *x_epd, *l_x, *pl;
    double xmin, xmax, lmin, lmax;
    double lexp;

    x_reinject = calloc(reinject_target, sizeof(double));
    x_eject = calloc(eject_target, sizeof(double));
    laminar_l = calloc(eject_target, sizeof(double));
    x_bins = calloc(n_bins_x + 1, sizeof(double));
    x_rpd = calloc(n_bins_x + 1, sizeof(double));
    x_epd = calloc(n_bins_x + 1, sizeof(double));
    l_x = calloc(n_bins_x + 1, sizeof(double));
    l_x_count = calloc(n_bins_x + 1, sizeof(double));

    /* state variables */
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2,  sizeof(double));
    double* xn2 = calloc(2,  sizeof(double));
    double x0, y0;

    x0 = genrand64_real3();
    y0 = genrand64_real3();
    
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

        if (distance_n > c && distance_n1 < c && reinjected == 0) {
            x_reinject[reinject_count] = xn1[0];
            reinject_count++;
            start_laminar = iterations;
        }
        else if (distance_n < c && distance_n1 > c && reinject_count > 0 && reinjected == 0) {
            x_eject[eject_count] = xn[0];
            laminar_l[eject_count] = iterations - start_laminar;
            eject_count++;
            if (eject_count % 100 == 0) {
                printf("reinjections: %d, ejections: %d\n", reinject_count, eject_count);
            }
        }
        
        if (iterations % (int)1e8 == 0) {
            cocient_i = (double) iterations / 1e8;
            printf("%f  %d\n", cocient_i, eject_count);
            if (eject_count < cocient_i) {
                no_eject = 1;
                eject_count = 1;
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
        xmin = min(x_reinject, eject_count);
        xmax = max(x_reinject, eject_count);

        x_bins = linspace(xmin, xmax + 0.1, n_bins_x + 1);
        
        for (unsigned int i = 0; i < n_bins_x; i++) {
            for (unsigned int j = 0; j < reinject_target; j++) {
                if (x_bins[i] <= x_reinject[j] && x_bins[i + 1] > x_reinject[j]) {
                    x_rpd[i]++;
                    l_x[i] += laminar_l[j];
                    l_x_count[i]++;
                }
            }
            x_rpd[i] /= (double) reinject_count;
            if (l_x_count[i] != 0) {
                l_x[i] /= l_x_count[i];
            }
            else {
                l_x[i] = 0;
            }
            // printf("xin =  %5.15f, l(x) = %5.15f\n", x_bins[i], l_x[i]);
            fprintf(fp1, "%5.15f  %5.15f  %5.15f\n", x_bins[i], x_rpd[i], l_x[i]);
        }

        l_x = calloc(eject_count, sizeof(double));
        l_x_count = calloc(eject_count, sizeof(double));
        xmin = min(x_eject, eject_count);
        xmax = max(x_eject, eject_count);

        x_bins = linspace(xmin, xmax + 0.1, n_bins_x + 1);

        for (unsigned int i = 0; i < n_bins_x; i++) {
            for (unsigned int j = 0; j < eject_target; j++) {
                if (x_bins[i] <= x_eject[j] && x_bins[i + 1] > x_eject[j]) {
                    x_epd[i]++;
                    l_x[i] += laminar_l[j];
                    l_x_count[i]++;
                }
            }
            x_epd[i] /= (double) eject_count;
            if (l_x_count[i] != 0) {
                l_x[i] /= l_x_count[i];
            }
            else {
                l_x[i] = 0;
            }
            // printf("xout =  %5.15f, l(x) = %5.15f\n", x_bins[i], l_x[i]);
            fprintf(fp2, "%5.15f  %5.15f  %5.15f\n", x_bins[i], x_epd[i], l_x[i]);
        }

        lmin = min(laminar_l, eject_count);
        lmax = max(laminar_l, eject_count);

        n_bins_l = (unsigned int) (lmax - lmin);
        printf("%d  %f  %f\n", n_bins_l, lmin, lmax);
        l_bins = calloc(n_bins_l + 1, sizeof(double));
        l_bins = linspace_discrete(lmin, lmax + 1, n_bins_l + 1);
        pl = calloc(n_bins_l + 1, sizeof(double));

        for (unsigned int i = 0; i < n_bins_l; i++) {
            for (unsigned int j = 0; j < eject_target; j++) {
                if (l_bins[i] <= laminar_l[j] && l_bins[i + 1] > laminar_l[j]) {
                    pl[i]++;
                }
            }
            // printf("l[i]: %5.8f, l[i+1]: %5.8f, p[l]: %5.8f\n", l_bins[i], l_bins[i+1], pl[i]);
            pl[i] /= (double) eject_count;
            lexp += l_bins[i] * pl[i];
            fprintf(fp3, "%5.15f  %5.15f  %5.15f  %5.15f\n", l_bins[i], pl[i], lexp, pl[i] * (double) eject_count);
        }
        printf("lexp: %5.15f, log(lexp): %5.15f\n", lexp, log(lexp));
    }
    else {
        printf("El sistema no presenta intermitencia para estas condiciones iniciales.\n");
    }

    free(xn);
    free(xn1);
    free(x_reinject);
    free(x_eject);
    free(x_bins);
    free(l_bins);
    free(l_x);
    free(l_x_count);
    free(x_rpd);
    free(x_epd);
    free(pl);
    fclose(fp1);
    fclose(fp2);
    fclose(fp3);
    return 0;
}