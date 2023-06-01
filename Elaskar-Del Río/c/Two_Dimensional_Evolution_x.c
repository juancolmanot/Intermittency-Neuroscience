#include <stdlib.h>
#include <stdio.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp = fopen("datafiles/Two_Dimensional_Evolution_x.dat", "w");

    unsigned int N = 10000;
    unsigned long long seed = rand();
    unsigned int n_map = 14;
    double alpha_c, beta;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double epsilon, alpha_i;

    alpha_c = 0.674149344;
    beta = 0.5;

    epsilon = 2e-5;

    alpha_i = alpha_c - epsilon;

    init_genrand64(seed);

    xn[0] = genrand64_real3();
    xn[1] = genrand64_real3();
    xn1[0] = xn1[1] = 0;

    for (unsigned int i = 0; i < N; i++) {

        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        fprintf(fp, "%d %5.15f %5.15f  %5.15f  %5.15f\n", i, xn[0], xn[1], xn1[0], xn1[1]);

        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    free(xn);
    free(xn1);
    fclose(fp);
    return 0;
}

