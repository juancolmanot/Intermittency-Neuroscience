#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "../../../../../cursos/modulosc/lorenz.h"

int main(void) {

    FILE *evolution = fopen("../datafiles/evolution_Lorenz.dat", "w");

    unsigned long int seed = (unsigned long int)time(NULL);

    Lorenzparams *params;

    params->sigma = 10.0;
    params->rho = 166.2;
    params->beta = 8.0 / 3.0;

    gsl_odeiv2_system sys_lorenz = {lorenz, jaclorenz, 3, &params};

    unsigned int N = 1000;
    double rel_err = 1e-12, abs_err = 1e-10;
    double h = 1e-6;
    const gsl_odeiv2_step_type *integrator = gsl_odeiv2_step_rkf45;

    gsl_odeiv2_driver *driver = gsl_odeiv2_driver_alloc_y_new(&lorenz, integrator, h, abs_err, rel_err);

    double t = 0.0, t1 = 100.0;
    double ti = t;
    gsl_rng *rng = gsl_rng_alloc(gsl_rng_default);
    gsl_rng_set(rng, seed);
    double x[3];

    x[0] = 1.0; //(double)gsl_ran_flat(rng, 0.0, 1.0);
    x[1] = 1.0; //(double)gsl_ran_flat(rng, 0.0, 1.0);
    x[2] = 1.0; //(double)gsl_ran_flat(rng, 0.0, 1.0);

    while (ti < t1) {
        int status = gsl_odeiv2_driver_apply(driver, &t, ti, x);

        if (status != GSL_SUCCESS) {
            printf("error, return value=%d\n", status);
            break;
        }
        printf("5.15f  5.15f  5.15f  5.15f  5.15f\n", t, x[0], x[1], x[2], h);
        // fprintf(evolution, "5.15f  5.15f  5.15f  5.15f  5.15f\n", t, x[0], x[1], x[2], h);
        ti += h;
    }

    gsl_odeiv2_driver_free(driver);
    gsl_rng_free(rng);
    fclose(evolution);
    return 0;
}