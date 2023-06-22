#include <stdlib.h>
#include <stdio.h>
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp = fopen("datafiles/two_dimensional_map_xn+14.dat", "w");


    unsigned int N = 200000;
    unsigned int n_map = 14;
    unsigned int seed = 34852;
    double p_alfa, p_beta;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double* xn_aux = calloc(2, sizeof(double));
    double* xn1_aux = calloc(2, sizeof(double));

    srand(seed);

    p_alfa = 0.7782651;
    p_beta = 0.3;
    xn[0] = xn_aux[0] = 0.75; //(float)rand() / (float)RAND_MAX;
    xn[1] = xn_aux[1] = 0.7; // (float)rand() / (float)RAND_MAX;
    xn1[0] = xn1[1] = xn1_aux[0] = xn1_aux[1] = 0;

    for (unsigned int i = 0; i < N; i++) {
        // for (unsigned int j = 0; j < n_map; j++) {
        //     mapa(xn1, xn_aux, p_alfa, p_beta);
        //     xn_aux[0] = xn1[0];
        //     xn_aux[1] = xn1[1];
        // }
        map_2d_n(xn1, xn, n_map, p_alfa, p_beta);

        fprintf(fp, "%.4E %.4E %.4E %.4E\n", xn[0], xn[1], xn1[0], xn1[1]);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    fclose(fp);
    printf("Finished\n");
    return 0;
}

