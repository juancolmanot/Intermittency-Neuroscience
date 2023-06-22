#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1;
    FILE *fp2;

    fp1 = fopen("datafiles/Two_Dimensional_Rotations_Evolution_xy.dat", "w");
    fp2 = fopen("datafiles/Two_Dimensional_Rotations_Evolution_uv.dat", "w");
    
    unsigned int n_iterations = 5000;
    unsigned int n_map = 14;
    double alpha = 0.674103;
    double beta = 0.5;
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));
    double* xt = malloc(2 * sizeof(double));
    double* xt1 = malloc(2 * sizeof(double));

    double pi = 4 * atan(1);
    double theta = 0;

    xn[0] = 0.9;
    xn[1] = 0.1;
    xn1[0] = xn1[1] = 0;

    for (unsigned int j = 0; j < n_iterations; j++) {        
        /* Classic variables */
        map_2d_n(xn1, xn, n_map, alpha, beta);
        fprintf(fp1, "%d %f %f %f %f\n", j, xn[0], xn[1], xn1[0], xn1[1]);
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    
    for (unsigned int i = 0; i < 8; i++) {

        theta = theta + pi * i * 0.25;

        xn[0] = 0.9;
        xn[1] = 0.1;
        xt[0] = xt[1] = 0;
        xt1[0] = xt1[1] = 0;
        for (unsigned int j = 0; j < n_iterations; j++) {        
            /* Rotated variables */
            // rotated_n_map(xt1, xt, n_map, alpha, beta, theta);
            map_2d_n(xn1, xn, n_map, alpha, beta);
            rotated_variables(xn, xt, theta);
            rotated_variables(xn1, xt1, theta);
            fprintf(fp2, "%d %f %f %f %f\n", j, xt[0], xt[1], xt1[0], xt1[1]);   
            xn[0] = xn1[0];
            xn[1] = xn1[1];
        }
        fprintf(fp2, "\n");
    }

    fclose(fp1);
    fclose(fp2);

    return 0;
}