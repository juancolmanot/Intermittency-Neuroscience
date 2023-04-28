#include <stdlib.h>
#include <stdio.h>
#include "../../../modulosc/intermittency.h"

int main() {

    FILE *fp = fopen("datafiles/Two_Dimensional_tests.dat", "w");

    unsigned int N = 2000000;
    double alpha, beta;
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));

    alpha = 0.75;
    beta = 0.5;
    

    xn[0] = 0.7;
    xn[1] = 0.9;
    xn1[0] = xn1[1] = 0;

    for (unsigned int i = 0; i < N; i++) {
        map_2d(xn1, xn, alpha, beta);
        fprintf(fp, "%d %.4E %.4E %.4E %.4E\n", i , xn[0], xn[1], xn1[0], xn1[1]);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    fclose(fp);
    printf("Finished\n");
    return 0;
}

