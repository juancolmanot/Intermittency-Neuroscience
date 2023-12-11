#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <gsl/gsl_statistics.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "../../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../../cursos/modulosc/lorenz.h"
#include "../../../../../cursos/modulosc/gsl_utilities.h"

int main(void) {

    unsigned long int seed = (unsigned long int)time(NULL);

    Parameters *p = malloc(sizeof(Parameters));

    p->a = 10.0;
    p->b = 166.1;
    p->c = 8.0 / 3.0;

    double rel_err = 1e-14, abs_err = 1e-12;
    double h = 1e-6;
    const gsl_odeiv2_step_type *integrator = gsl_odeiv2_step_rkf45;
    gsl_odeiv2_step *s = gsl_odeiv2_step_alloc(integrator, 3);
    gsl_odeiv2_control *c = gsl_odeiv2_control_y_new(abs_err, rel_err);
    gsl_odeiv2_evolve *e = gsl_odeiv2_evolve_alloc(3);

    gsl_odeiv2_system sys = {lorenz, jaclorenz, 3, p};

    double t = 0.0, t1 = 10000000.0;
    gsl_rng *rng = gsl_rng_alloc(gsl_rng_default);
    gsl_rng_set(rng, seed);
    double x[3];

    x[0] = 2.0;
    x[1] = -1.0;
    x[2] = 150.0;

    /* Passes counter */
    unsigned int counter = 0;
    unsigned int pass_target = 800000;
    unsigned int reinject_target = 10000;

    /* Laminar lengths counter */
    unsigned int laminar_start, laminar_end;

    double *yreinj, *yreinj_prev, *laminar_lengths;

    yreinj = calloc(reinject_target, sizeof(double));
    yreinj_prev = calloc(reinject_target, sizeof(double));
    laminar_lengths = calloc(reinject_target, sizeof(double));

    /* Arrays for x, y, z */
    double xi[3], yi[3], zi[3];
    double yi_prev = 0;

    /* Arrays for adjustment */
    double xfit[3], yfit[3], zfit[3];
    double *coefficients = calloc(3, sizeof(double));
    double a_c, b_c, c_c;
    
    double yf = 41.2861;
    double clam = 1.85;
    unsigned int count_reinject = 0;

    unsigned int n_bins = 200;
    double ymin, ymax, yj, dy;
    ymin = yf - clam;
    ymax = yf + clam;
    dy = (ymax - ymin) / (double)(n_bins - 1);
    yj = ymin;
    
    double knorm = 0;

    /* Poincaré section */
    double xp = 0;
    xi[0] = x[0];
    yi_prev = x[1];
    zi[0] = x[2];

    /* Initialize the first three points */
    for (unsigned int i = 1; i < 3; i++) {
        int status = gsl_odeiv2_evolve_apply(e, c, s, &sys, &t, t1, &h, x);
        xi[i] = x[0];
        yi[i] = x[1];
        zi[i] = x[2];
        if (status != GSL_SUCCESS) {
            printf("error initializing, return value=%d\n", status);
            break;
        }
    }

    while (count_reinject < reinject_target) {
        int status = gsl_odeiv2_evolve_apply(e, c, s, &sys, &t, t1, &h, x);

        /* Update values */
        xi[0] = xi[1];
        xi[1] = xi[2];
        xi[2] = x[0];
        
        yi[0] = yi[1];
        yi[1] = yi[2];
        yi[2] = x[1];

        zi[0] = zi[1];
        zi[1] = zi[2];
        zi[2] = x[2];

        if (status != GSL_SUCCESS) {
            printf("error, return value=%d\n", status);
            break;
        }

        if (t > 1000.0) {
            if (xi[1] > xp) {
                if (xi[0] < xp) {
                    counter++;
                    xfit[0] = xi[0];
                    xfit[1] = xi[1];
                    xfit[2] = xi[2];
                    yfit[0] = yi[0];
                    yfit[1] = yi[1];
                    yfit[2] = yi[2];
                    zfit[0] = zi[0];
                    zfit[1] = zi[1];
                    zfit[2] = zi[2];
                    // gsl_regression_quadratic(xfit, yfit, 3, coefficients);
                    // a_c = coefficients[0];
                    // b_c = coefficients[1];
                    // c_c = coefficients[2];
                    if (yi[1] >= yf - clam && yi[1] <= yf + clam) {
                        if (yi_prev > yf + clam || yi_prev < yf - clam) {
                            yreinj[count_reinject] = yi[1];
                            yreinj_prev[count_reinject] = yi_prev;
                            count_reinject++;
                            laminar_start = counter;
                            if (count_reinject % 1000 == 0) {
                                printf("count reinject: %d\n", count_reinject);
                            }
                        }
                    }
                    if (yi[1] < yf - clam || yi[1] > yf + clam) {
                        if (yi_prev >= yf - clam && yi_prev <= yf + clam) {
                            laminar_lengths[count_reinject] = counter - laminar_start;
                        }
                    }
                    yi_prev = yi[1];
                }
            }
        }
    }

    FILE *laminar = fopen("../datafiles/laminar_pdll.dat", "w");
    double *laminar_lengts_histogram;

    double max_l, min_l, lj;

    max_l = gsl_stats_max(laminar_lengths, 1, reinject_target);
    min_l = gsl_stats_min(laminar_lengths, 1, reinject_target);

    laminar_lengts_histogram = calloc(n_bins, sizeof(double));

    lj = 1;

    /* Increment y from min to max to generate bins */
    for (unsigned int i = 0; i < max_l; i++) {

        /* Loop through whole array of y fitted */
        for (unsigned int j = 1; j < reinject_target - 1; j++) {
            
            /* Ask for belonging to bin */
            if (laminar_lengths[j] > lj && laminar_lengths[j] <= lj + 1) {
                laminar_lengts_histogram[i] += laminar_lengths[j];
            }
        }
        lj++;
    }

    /* Normalizamos pdll */
    double b = 0, int_pdll = 0, lavg = 0;

    for (unsigned int i = 0; i < max_l; i++) {
        int_pdll += laminar_lengts_histogram[i];
    }

    b = 1 / int_pdll;

    lj = 1;

    for (unsigned int i = 0; i < max_l; i++) {
        fprintf(laminar, "%5.10f %5.10f\n", lj, b * laminar_lengts_histogram[i]);
        lj++;
        lavg += b * laminar_lengts_histogram[i] * lj;
    }

    printf("lavg: %5.10f\n", lavg);

    gsl_odeiv2_evolve_free(e);
    gsl_odeiv2_control_free(c);
    gsl_odeiv2_step_free(s);
    gsl_rng_free(rng);
    free(laminar_lengths);
    free(laminar_lengts_histogram);
    return 0;
}