#include <stdlib.h>
#include <stdio.h>

static void mapa(float* x1, float* x, float alfa, float beta) {
    
    x1[0] = 4.f * alfa * x[0] * (1.f - x[0]) + beta * x[1] * (1.f - x[0]);
    x1[1] = 4.f * alfa * x[1] * (1.f - x[1]) + beta * x[0] * (1.f - x[1]);
}

int main() {

    FILE *fp;

    fp = fopen("datafiles/Two_Dimensional_Evolution.dat", "w");

    char str1[] = {"xn"};
    char str2[] = {"yn"};
    char str3[] = {"xn1"};
    char str4[] = {"yn1"};

    unsigned int n = 9;

    fprintf(fp, "%*.*s %*.*s %*.*s %*.*s\n",\
     0, n, &str1[0], n+1, n, &str2[0], n+2, n, &str3[0], n+1, n, &str4[0]);

    unsigned int N = 200000;
    unsigned int seed = 34852;
    float p_alfa, p_beta;
    float* xn = malloc(2 * sizeof(float));
    float* xn1 = malloc(2 * sizeof(float));

    srand(seed);

    p_alfa = 0.674f; /*103*/
    p_beta = 0.5f;
    xn[0] = (float)rand() / (float)RAND_MAX;
    xn[1] = (float)rand() / (float)RAND_MAX;

    for (unsigned int i = 0; i < N; i++) {
        mapa(xn1, xn, p_alfa, p_beta);
        fprintf(fp, "%.4E %.4E %.4E %.4E\n", xn[0], xn[1], xn1[0], xn1[1]);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

   fclose(fp);

   return 0;
}

