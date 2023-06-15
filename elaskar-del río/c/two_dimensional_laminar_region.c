#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Files to store things */
    FILE *fp, *fp1, *fp2;

    fp = fopen("datafiles/two_dimensional_laminar_region.dat", "w");
    
    /* Hyper parameters */
    unsigned long long seed = (unsigned long long)rand();
    printf("%d\n", seed);
    unsigned int valid_count = 0;
    unsigned int N = 10000000;
    unsigned int n_map = 14;

    /* Laminar region */
    double lbr = 0.815;
    double ubr = 0.823;

    /* Map parameters */
    unsigned int n_tries = 50;
    double alpha_c = 0.674149344;
    double beta = 0.5;
    double alpha_i;
    double epsilon = 1e-3;
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

    init_genrand64(seed);

    xn[0] = genrand64_real3();
    xn[1] = genrand64_real3();
    xn1[0] = 0;
    xn1[1] = 0;

    for (unsigned int i = 0; i < N; i++) {

        map_2d_n(xn1, xn, n_map, alpha_i, beta);

        if (xn[0] > ubr || xn[0] < lbr && xn[0] > xn1[0]) {
            if (xn1[0] < ubr && xn1[0] > lbr) {
                reinjection_counter++;
                start_laminar = i;
            }
        }

        else if (xn[0] < ubr && xn[0] > lbr && xn[0] > xn1[0]) {
            if (xn1[0] > ubr || xn1[0] < lbr) {
                ejection_counter++;
                l_avg += (double) i - start_laminar;
                printf("%d    %d\n", ejection_counter, i - start_laminar);
            }
        }

        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    l_avg = l_avg / (double) ejection_counter;
    printf("<l> : %d\n", (unsigned int)l_avg);

    return 0;
}