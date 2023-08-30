#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1;
    fp1 = fopen("datafiles/two_dimensional_distance.dat", "w");
    
    double alpha_c = 0.674149343;
    double beta = 0.5;
    double epsilon = 0;
    unsigned int n_mapa = 14;
    unsigned int N = 100000;
    unsigned int transient = 100;
    
    unsigned int seed = (unsigned int)time(NULL);
    init_genrand64((unsigned long long) seed);

    double distance_x, distance_y;
    
    /* state variables */
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2,  sizeof(double));
    double x0, y0;

    x0 = genrand64_real3();
    y0 = genrand64_real3();
    
    printf("Initial conditions: (%5.15f, %5.15f)\n", x0, y0);

    xn[0] = x0;
    xn[1] = y0;

    xn1[0] = xn1[1] = 0;

    for (unsigned int i = 0; i < N; i++) {
        map_2d_n(xn1, xn, n_mapa, alpha_c - epsilon, beta);
        distance_x = fabs(xn[0] - xn1[0]) / sqrt(2);
        distance_y =  fabs(xn[1] - xn1[1]) / sqrt(2);
        if (i > transient){
            fprintf(fp1, "%d  %5.15f  %5.15f  %5.15f  %5.15f\n",
                    i, distance_x, distance_y, xn[0], xn[1]);
        }
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    free(xn);
    free(xn1);
    fclose(fp1);
    return 0;
}