#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_odeiv2.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include "../../../../../cursos/modulosc/lorenz.h"
#include "../../../../../cursos/modulosc/gsl_utilities.h"

int main(void) {

    FILE *poincare, *reinjected1, *reinjected2, *reinjected3, *reinjected4, *reinjected5, *reinjected;
    poincare = fopen("../datafiles/poincare_section_lorenz.dat", "w");
    reinjected1 = fopen("../datafiles/reinjected_lorenz_1.dat", "w");
    reinjected2 = fopen("../datafiles/reinjected_lorenz_2.dat", "w");
    reinjected3 = fopen("../datafiles/reinjected_lorenz_3.dat", "w");
    reinjected4 = fopen("../datafiles/reinjected_lorenz_4.dat", "w");
    reinjected5 = fopen("../datafiles/reinjected_lorenz_5.dat", "w");
    reinjected = fopen("../datafiles/reinjected_lorenz.dat", "w");

    unsigned long int seed = (unsigned long int)time(NULL);

    Parameters *p = malloc(sizeof(Parameters));

    p->a = 10.0;
    p->b = 166.2;
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
    unsigned int reinject_target = 200000;

    double *yreinj, *yreinj_prev;

    yreinj = calloc(reinject_target, sizeof(double));
    yreinj_prev = calloc(reinject_target, sizeof(double));

    /* Arrays for x, y, z */
    double xi[3], yi[3], zi[3];
    double yi_prev = 0;

    /* Arrays for adjustment */
    double xfit[3], yfit[3], zfit[3];
    double *coefficients = calloc(3, sizeof(double));
    double a_c, b_c, c_c;

    /* Laminar region */
    FILE *region_1, *region_2, *region_3, *region_4, *region_5;
    region_1 = fopen("../datafiles/reinject_region1.dat", "w");
    region_2 = fopen("../datafiles/reinject_region2.dat", "w");
    region_3 = fopen("../datafiles/reinject_region3.dat", "w");
    region_4 = fopen("../datafiles/reinject_region4.dat", "w");
    region_5 = fopen("../datafiles/reinject_region5.dat", "w");
    double yf = 41.2861;
    double clam = 1.85;
    unsigned int count_reinject = 0;
    double yr0, yr1, yr2, yr3, yr4, yr5, yr6;
    yr0 = 0;
    yr1 = 18;
    yr2 = 25;
    yr3 = 30;
    yr4 = yf - clam;
    yr5 = yf + clam;
    yr6 = 100;

    unsigned int counter1, counter2, counter3, counter4, counter5;

    counter1 = counter2 = counter3 = counter4 = counter5 = 0;

    unsigned int counter_tot;

    counter_tot = counter1 + counter2 + counter3 + counter4 + counter5;

    FILE *weights = fopen("../datafiles/rpd_weights.dat", "w");

    fprintf(weights, "%d\n", counter1);
    fprintf(weights, "%d\n", counter2);
    fprintf(weights, "%d\n", counter3);
    fprintf(weights, "%d\n", counter4);
    fprintf(weights, "%d\n", counter5);

    FILE *RPD1, *RPD2, *RPD3, *RPD4, *RPD5;
    RPD1 = fopen("../datafiles/rpd_lorenz_1.dat", "w");
    RPD2 = fopen("../datafiles/rpd_lorenz_2.dat", "w");
    RPD3 = fopen("../datafiles/rpd_lorenz_3.dat", "w");
    RPD4 = fopen("../datafiles/rpd_lorenz_4.dat", "w");
    RPD5 = fopen("../datafiles/rpd_lorenz_5.dat", "w");
    unsigned int n_bins = 200;
    double ymin, ymax, yj, dy;
    ymin = yf - clam;
    ymax = yf + clam;
    dy = (ymax - ymin) / (double)(n_bins - 1);
    yj = ymin;
    double *yreinjected1, *yreinjected2, *yreinjected3, *yreinjected4, *yreinjected5;
    
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

    while (counter_tot < reinject_target) {
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
                            fprintf(reinjected, "%5.15f\n", yi[1]);
                            if (yi_prev > yr0 && yi_prev < yr1) {
                                fprintf(region_1, "%5.15f  %5.15f\n", yi_prev, yi[1]);
                                fprintf(reinjected1, "%5.15f\n", yi[1]);
                                counter1++;
                            }
                            if (yi_prev > yr1 && yi_prev < yr2) {
                                fprintf(region_2, "%5.15f  %5.15f\n", yi_prev, yi[1]);
                                fprintf(reinjected2, "%5.15f\n", yi[1]);
                                counter2++;
                            }
                            if (yi_prev > yr2 && yi_prev < yr3) {
                                fprintf(region_3, "%5.15f  %5.15f\n", yi_prev, yi[1]);
                                fprintf(reinjected3, "%5.15f\n", yi[1]);
                                counter3++;
                            }
                            if (yi_prev > yr3 && yi_prev < yr4) {
                                fprintf(region_4, "%5.15f  %5.15f\n", yi_prev, yi[1]);
                                fprintf(reinjected4, "%5.15f\n", yi[1]);
                                counter4++;
                            }
                            if (yi_prev > yr5 && yi_prev < yr6) {
                                fprintf(region_5, "%5.15f  %5.15f\n", yi_prev, yi[1]);
                                fprintf(reinjected5, "%5.15f\n", yi[1]);
                                counter5++;
                            }
                        }
                    }
                    counter_tot = counter1 + counter2 + counter3 + counter4 + counter5;
                    if (counter % 5000 == 0) {
                        printf("counter pass: %d, counter reinject: %d\n", counter, count_reinject);
                        printf("counter 1: %d\n", counter1);
                        printf("counter 2: %d\n", counter2);
                        printf("counter 3: %d\n", counter3);
                        printf("counter 4: %d\n", counter4);
                        printf("counter 5: %d\n", counter5);
                        printf("counter tot: %d\n", counter_tot);
                    }
                    yi_prev = yi[1];
                }
            }
        }
    }

    yreinjected1 = calloc(n_bins, sizeof(double));
    yreinjected2 = calloc(n_bins, sizeof(double));
    yreinjected3 = calloc(n_bins, sizeof(double));
    yreinjected4 = calloc(n_bins, sizeof(double));
    yreinjected5 = calloc(n_bins, sizeof(double));

    /* Increment y from min to max to generate bins */
    for (unsigned int i = 0; i < n_bins; i++) {

        /* Loop through whole array of y fitted */
        for (unsigned int j = 1; j < reinject_target - 1; j++) {
            
            /* Ask for belonging to bin */
            if (yreinj[j] > yj && yreinj[j] <= yj + dy) {
                
                if (yreinj_prev[j] > yr0 && yreinj_prev[j] < yr1) {
                    yreinjected1[i]++;
                }
                if (yreinj_prev[j] > yr1 && yreinj_prev[j] < yr2) {
                    yreinjected2[i]++;
                }
                if (yreinj_prev[j] > yr2 && yreinj_prev[j] < yr3) {
                    yreinjected3[i]++;
                }
                if (yreinj_prev[j] > yr3 && yreinj_prev[j] < yr4) {
                    yreinjected4[i]++;
                }
                if (yreinj_prev[j] > yr5 && yreinj_prev[j] < yr6) {
                    yreinjected5[i]++;
                }
            }
        }
        
        fprintf(RPD1, "%5.15f  %5.15f\n", yj, yreinjected1[i]);
        fprintf(RPD2, "%5.15f  %5.15f\n", yj, yreinjected2[i]);
        fprintf(RPD3, "%5.15f  %5.15f\n", yj, yreinjected3[i]);
        fprintf(RPD4, "%5.15f  %5.15f\n", yj, yreinjected4[i]);
        fprintf(RPD5, "%5.15f  %5.15f\n", yj, yreinjected5[i]);
        yj += dy;
    }

    gsl_odeiv2_evolve_free(e);
    gsl_odeiv2_control_free(c);
    gsl_odeiv2_step_free(s);
    gsl_rng_free(rng);
    fclose(poincare);
    fclose(region_1);
    fclose(region_2);
    fclose(region_3);
    fclose(region_4);
    fclose(RPD1);
    fclose(RPD2);
    fclose(RPD3);
    fclose(RPD4);
    fclose(reinjected);
    fclose(reinjected1);
    fclose(reinjected2);
    fclose(reinjected3);
    fclose(reinjected4);
    fclose(reinjected5);
    fclose(weights);
    return 0;
}