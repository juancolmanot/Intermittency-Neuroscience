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
#include <gsl/gsl_math.h>
#include "../../../../../cursos/modulosc/typeII_coupled_map.h"
//#include "../../../../../cursos/modulosc/gsl_utilities.h"

int main(void) {

    /* Open file for storage of results */
    FILE *time_evol;
    time_evol = fopen("../datafiles/evolution_typeII_coupled.dat", "w");

    /* Set our seed for generating the uncorrelated white noise */
    unsigned long int seed = (unsigned long int)time(NULL);

    /* Define our parameters and asing them values */
    Parameters *p = malloc(sizeof(Parameters));

    p->b = 0.186;
    p->mu = 0.0001;
    p->gamma = 0.13;
    p->eps = 0.001;

    /* Define number of iterations to be performed */
    unsigned int N;
    N = 100000;
    
    /* Initialize random numbers generator */
    gsl_rng *r;
    const gsl_rng_type *Tgen;
    gsl_rng_env_setup();
    Tgen = gsl_rng_default;
    r = gsl_rng_alloc(Tgen);
    gsl_rng_set(r, seed);

    /* Set the maximum and minimum starting values */
    double xrng_min, xrng_max;
    xrng_min = 0;
    xrng_max = 1;

    /* Arrays for storing the nth and (n+1)th variables x and y */
    double *x0, *xn;
    x0 = calloc(2, sizeof(double));
    xn = calloc(2, sizeof(double));

    /* Variables for storing the sign and square root function to plot */
    double signx, signy, sqrt_abs_x, sqrt_abs_y;
    
    /* Initialize the state at random */
    x0[0] = gsl_ran_flat(r, xrng_min, xrng_max);
    x0[1] = gsl_ran_flat(r, xrng_min, xrng_max);

    printf("x0: %5.8f, y0: %5.8f\n", x0[0], x0[1]);

    /* Perform the time evolution */
    for (unsigned int i = 0; i < N; i++) {
        xn = LMBK(x0, p);
        signx = GSL_SIGN(xn[0]);
        signy = GSL_SIGN(xn[1]);
        sqrt_abs_x = sqrt(fabs(xn[0]));
        sqrt_abs_y = sqrt(fabs(xn[1]));
        fprintf(time_evol, "%d %5.15f %5.15f %5.15f %5.15f\n", \
            i, xn[0], xn[1], signx * sqrt_abs_x, signy * sqrt_abs_y);
        x0[0] = xn[0];
        x0[1] = xn[1];
    }

    free(x0);
    free(xn);
    free(r);
    fclose(time_evol);
    
    return 0;
}