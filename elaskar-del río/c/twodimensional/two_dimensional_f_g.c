#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp1 = fopen("datafiles/two_dimensional_f_g.dat", "w");
    FILE *fp2 = fopen("datafiles/two_dimensional_f_g_terms_x.dat", "w");
    FILE *fp3 = fopen("datafiles/two_dimensional_f_g_terms_y.dat", "w");
    
    unsigned int N = 5000;
    unsigned int n_map = 14;
    double* p_alpha = malloc(2 * sizeof(double));
    double* p_beta = malloc(2 * sizeof(double));
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));

    double x_2, y_2, *x_1, *y_1, xy;

    x_1 = calloc(2, sizeof(double));
    y_1 = calloc(2, sizeof(double));

    double *x = calloc(N, sizeof(double));
    double *y = calloc(N, sizeof(double));

    x = linspace(0, 1, N);
    y = linspace(0, 1, N);

    double epsilon = 1e-6;

    p_alpha[0] = 0.674149344;
    p_alpha[1] = 0.77826511;
    p_beta[0] = 0.5;
    p_beta[1] = 0.3;

    
    for (unsigned int i = 0; i < N; i++) {        
        
        xn[0] = x[i];
        xn[1] = y[i];
     
        map_2d_n(xn1, xn, n_map, p_alpha[1], p_beta[1]);

        x_2 = - 4 * p_alpha[0] * xn[0] * xn[0];
        y_2 = - 4 * p_alpha[0] * xn[1] * xn[1];
        x_1[0] = 4 * p_alpha[0] * xn[0];
        x_1[1] = p_beta[0] * xn[0];
        y_1[0] = p_beta[0] * xn[1];
        y_1[1] = 4 * p_alpha[0] * xn[1];
        xy = - p_beta[0] * xn[0] * xn[1];


        fprintf(fp1, "%.12E %.12E %.12E %.12E\n", xn[0], xn[1], xn1[0], xn1[1]);
        fprintf(fp2, "%.12E %.12E %.12E %.12E %.12E %.12E\n", xn[0], x_2, x_1[0], y_1[0], xy, xn1[0]);
        fprintf(fp3, "%.12E %.12E %.12E %.12E %.12E %.12E\n", xn[1], x_2, x_1[1], y_1[1], xy, xn1[1]);

    }
    
    fclose(fp1);
    fclose(fp2);
    fclose(fp3);
    return 0;
}

