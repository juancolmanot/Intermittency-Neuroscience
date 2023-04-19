#include <stdlib.h>
#include <stdio.h>

static void mapa(double* x1, double* x, double alfa, double beta) {
    
    x1[0] = 4.f * alfa * x[0] * (1.f - x[0]) + beta * x[1] * (1.f - x[0]);
    x1[1] = 4.f * alfa * x[1] * (1.f - x[1]) + beta * x[0] * (1.f - x[1]);
}

int main() {

    FILE *fp = fopen("datafiles/Two_Dimensional_Map_Xn+14.dat", "w");

    char colnames[4][4] = {"xn", "yn", "xn1", "yn1"};

    unsigned int n = 9;

    fprintf(fp, "%*.*s %*.*s %*.*s %*.*s\n",\
    0, n, &colnames[0], n+1, n, &colnames[1], n+2, n, &colnames[2], n+1, n, &colnames[3]);

    unsigned int N = 200000;
    unsigned int n_map = 14;
    unsigned int seed = 34852;
    double p_alfa, p_beta;
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));
    double* xn_aux = malloc(2 * sizeof(double));
    double* xn1_aux = malloc(2 * sizeof(double));

    srand(seed);

    p_alfa = 0.7782651;
    p_beta = 0.3;
    xn[0] = xn_aux[0] = 0.75; //(float)rand() / (float)RAND_MAX;
    xn[1] = xn_aux[1] = 0.7; // (float)rand() / (float)RAND_MAX;
    xn1[0] = xn1[1] = xn1_aux[0] = xn1_aux[1] = 0.f;

    for (unsigned int i = 0; i < N; i++) {
        for (unsigned int j = 0; j < n_map; j++) {
            mapa(xn1, xn_aux, p_alfa, p_beta);
            xn_aux[0] = xn1[0];
            xn_aux[1] = xn1[1];
        }
        fprintf(fp, "%.4E %.4E %.4E %.4E\n", xn[0], xn[1], xn1[0], xn1[1]);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    fclose(fp);
    printf("Finished\n");
    return 0;
}

