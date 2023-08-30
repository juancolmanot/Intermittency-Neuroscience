#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1, *fp2;
    
    fp1 = fopen("datafiles/two_dimensional_evolution_14_0.674149_eps.dat", "w");
    fp2 = fopen("datafiles/two_dimensional_distance_to_line_14_0.674149_eps.dat", "w");
    
    unsigned int N = 20000;
    unsigned int transient = (unsigned int) N * 0.3;
    unsigned int n_map = 14;
    double p_alpha = 0.7782651;
    double p_beta = 0.3;
    double epsilon;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));

    double distance_line_y = 0;
    double distance_line_x = 0;

    epsilon = 0;

    unsigned int seed = (unsigned int)time(NULL);

    init_genrand64(seed);

    xn[0] = genrand64_real3(); //0.8;
    xn[1] = genrand64_real3(); //0.4;
    
    xn1[0] = xn1[1] = 0;
    
    for (unsigned int i = 0; i < N; i++) {        
        map_2d_n(xn1, xn, n_map, p_alpha - epsilon, p_beta);
        
        distance_line_x = fabs(xn[0] - xn1[0]) / sqrt(2);
        distance_line_y = fabs(xn[1] - xn1[1]) / sqrt(2);

        if (i > transient) {
            fprintf(fp1, "%d %.12E %.12E %.12E %.12E\n", i * 14 - transient, xn[0], xn[1], xn1[0], xn1[1]);
            fprintf(fp2, "%d %.12E %.12E %.12E %.12E\n", i * 14 - transient, xn[0], xn[1], distance_line_x, distance_line_y);
        }

        xn[0] = xn1[0];
        xn[1] = xn1[1];

        if (i % 2000 == 0) {
            xn[0] = genrand64_real3(); //0.8;
            xn[1] = genrand64_real3(); //0.4;
    
            xn1[0] = xn1[1] = 0;
        }
    }
    
    fclose(fp1);
    return 0;
}

