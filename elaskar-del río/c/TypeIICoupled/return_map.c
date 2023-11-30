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

    FILE *time_evol, *Fmap;
    time_evol = fopen("../datafiles/evolution_typeII_coulped_x.dat", "w");
    Fmap = fopen("../datafiles/fmap_typeII_coulped_x.dat", "w");

    unsigned long int seed = (unsigned long int)time(NULL);

    Parameters *p = malloc(sizeof(Parameters));

    p->b = 0.14;
    p->mu = 0.005;
    p->gamma = 0.02;

    double xmin, xmax, Nx;
    xmin = -10;
    xmax = 10;
    Nx = 100;

    double x, dx;
    double Fx;
    unsigned int N;
    N = 500;
    dx = (xmax - xmin) / (double)(Nx - 1);
    x = xmin;

    for (unsigned int i = 0; i < Nx; i++) {
        Fx = LMBKx(x, p);
        fprintf(Fmap, "%5.15f  %5.15f\n", x, Fx);
        x += dx;
    }

    // gsl_rng *r;
    // const gsl_rng_type *Tgen;
    // gsl_rng_env_setup();
    // Tgen = gsl_rng_default;
    // r = gsl_rng_alloc(Tgen);
    // gsl_rng_set(r, seed);

    // double xrng_min, xrng_max;
    // xrng_min = -3;
    // xrng_max = 3;

    // double x0, xn;
    // x0 = gsl_ran_flat(r, xrng_min, xrng_max);

    // for (unsigned int i = 0; i < N; i++) {
    //     xn = LMBKx(x0, p);
    //     fprintf(time_evol, '%5.15f  %5.15f\n', i, xn);
    //     x0 = xn;
    // }


    // free(r);
    fclose(time_evol);
    fclose(Fmap);

    return 0;
}