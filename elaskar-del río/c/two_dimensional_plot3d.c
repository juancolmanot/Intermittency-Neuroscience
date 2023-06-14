#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../modulosc/linear_algebra.h"

/* Declare function that computes the map */

static void mapa(double* x1, double* x, double alfa, double beta) {
    
    x1[0] = 4.f * alfa * x[0] * (1.f - x[0]) + beta * x[1] * (1.f - x[0]);
    x1[1] = 4.f * alfa * x[1] * (1.f - x[1]) + beta * x[0] * (1.f - x[1]);
}

int main() {

    FILE *fp = fopen("datafiles/Two_Dimensional_Plot3D.dat", "w");

    unsigned int n = 100;

    double* x = malloc(n * sizeof(double));
    double* y = malloc(n * sizeof(double));
    double x_start, x_end, y_start, y_end;
    double* xy = malloc(2 * sizeof(double));
    double* xy1 = malloc(2 * sizeof(double));
    double a, b;

    a = 0.674149344;
    b = 0.5;

    xy1[0] = xy1[1] = xy[0] = xy[1] = 0;

    x_start = y_start = -1;
    x_end = y_end = -x_start;

    x = linspace(x_start, x_end, n);
    y = linspace(y_start, y_end, n);

    for (unsigned int i = 0; i < n; i++) {
        xy[0] = x[i];
        for (unsigned int j = 0; j < n; j++) {
            xy[1] = y[j];
            mapa(xy1, xy, a, b);
            fprintf(fp, "%f %f  %f  %f\n", xy[0], xy[1], xy1[0], xy1[1]);
        }
    }

    fclose(fp);

    return 0;
}