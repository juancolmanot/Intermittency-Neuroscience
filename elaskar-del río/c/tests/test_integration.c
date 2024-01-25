#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_linalg.h>
#include "../../../../../cursos/modulosc/lorenz.h"
#include "../../../../../cursos/modulosc/gsl_integration.h"

int main(void) {

    FILE *evol = fopen("../datafiles/evol_test.dat", "w");

    Parameters *p = malloc(sizeof(Parameters));

    p->a = 10.0;
    p->b = 166.07;
    p->c = 8.0 / 3.0;

    int size = 3;
    double rel_err = 1e-14, abs_err = 1e-12;
    double h = 1e-6;
    const gsl_odeiv2_step_type *integrator = gsl_odeiv2_step_rkf45;
    gsl_odeiv2_system sys = {lorenz, jaclorenz, size, p};

    double t = 0.0, t1 = 10.0;
    double x[3];

    x[0] = 2.0;
    x[1] = -1.0;
    x[2] = 150.0;

    double *xt = calloc(4, sizeof(double));

    xt = x_t_sol(x, t, t1, h, rel_err, abs_err, integrator, sys, size);

    printf("%5.5f %5.5f %5.5f %5.5f\n", xt[0], xt[1], xt[2], xt[3]);

    fclose(evol);
    return 0;
}