#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "../../../../../cursos/modulosc/lorenz.h"

int main(void) {

    FILE *evolution = fopen("../datafiles/evolution_lorenz_167.dat", "w");

    unsigned long int seed = (unsigned long int)time(NULL);

    Parameters *p = malloc(sizeof(Parameters));

    p->a = 10.0;
    p->b = 167;
    p->c = 8.0 / 3.0;

    double rel_err = 1e-14, abs_err = 1e-12;
    double h = 1e-6;
    const gsl_odeiv2_step_type *integrator = gsl_odeiv2_step_rkf45;
    gsl_odeiv2_step *s = gsl_odeiv2_step_alloc(integrator, 3);
    gsl_odeiv2_control *c = gsl_odeiv2_control_y_new(abs_err, rel_err);
    gsl_odeiv2_evolve *e = gsl_odeiv2_evolve_alloc(3);

    gsl_odeiv2_system sys = {lorenz, jaclorenz, 3, p};

    double t = 0.0, t1 = 1000.0, t2 = 2000.0;
    gsl_rng *rng = gsl_rng_alloc(gsl_rng_default);
    gsl_rng_set(rng, seed);
    double x[3];

    x[0] = (double)gsl_ran_flat(rng, 0.0, 1.0);
    x[1] = (double)gsl_ran_flat(rng, 0.0, 1.0);
    x[2] = (double)gsl_ran_flat(rng, 0.0, 1.0);

    while (t < t2) {
        int status = gsl_odeiv2_evolve_apply(e, c, s, &sys, &t, t2, &h, x);

        if (status != GSL_SUCCESS) {
            printf("error, return value=%d\n", status);
            break;
        }

        if (t > 1975) {
            fprintf(evolution, "%5.15f  %5.15f  %5.15f  %5.15f  %5.15f\n", t, x[0], x[1], x[2], h);    
        }
    }

    gsl_odeiv2_evolve_free(e);
    gsl_odeiv2_control_free(c);
    gsl_odeiv2_step_free(s);
    gsl_rng_free(rng);
    fclose(evolution);
    return 0;
}