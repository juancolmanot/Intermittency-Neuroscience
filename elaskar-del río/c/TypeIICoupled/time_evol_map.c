#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <time.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "../../../../../cursos/modulosc/typeII_coupled_map.h"
//#include "../../../../../cursos/modulosc/gsl_utilities.h"

int main(void) {

    FILE *time_evol;
    time_evol = fopen("../datafiles/evolution_typeII_coupled.dat", "w");

    unsigned long int seed = (unsigned long int)time(NULL);

    Parameters *p = malloc(sizeof(Parameters));

    p->b = 0.14;
    p->mu = 0.005;
    p->gamma = 0.02;
    p->eps = 0.01;

    unsigned int N;
    N = 500;
    
    gsl_rng *r;
    const gsl_rng_type *Tgen;
    gsl_rng_env_setup();
    Tgen = gsl_rng_default;
    r = gsl_rng_alloc(Tgen);
    gsl_rng_set(r, seed);

    double xrng_min, xrng_max;
    xrng_min = -3;
    xrng_max = 3;

    double *x0, *xn;
    x0 = calloc(2, sizeof(double));
    xn = calloc(2, sizeof(double));
    
    x0[0] = gsl_ran_flat(r, xrng_min, xrng_max);
    x0[1] = gsl_ran_flat(r, xrng_min, xrng_max);

    for (unsigned int i = 0; i < N; i++) {
        xn = LMBK(x0, p);
        fprintf(time_evol, "%d %5.15f %5.15f\n", i, xn[0], xn[1]);
        x0[0] = xn[0];
        x0[1] = xn[1];
    }

    free(x0);
    free(xn);
    free(r);
    fclose(time_evol);
    
    return 0;
}