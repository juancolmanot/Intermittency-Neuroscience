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
#include <gsl/gsl_linalg.h>
#include "../../../../../cursos/modulosc/lorenz.h"
#include "../../../../../cursos/modulosc/gsl_integration.h"

int main(void) {

    FILE *evol = fopen("../datafiles/evol_test.dat", "w");

    /* Lorenz system's parameters */
    Parameters *p = malloc(sizeof(Parameters));

    p->a = 10.0;
    p->b = 166.07;
    p->c = 8.0 / 3.0;

    /* Dimension of system */
    int size = 3;

    /* Integration errors and max step allowed */
    double rel_err = 1e-14, abs_err = 1e-12;
    double h = 1e-6;

    /* Integration algorithm */
    const gsl_odeiv2_step_type *integrator = gsl_odeiv2_step_rkf45;
    
    /* System ODEs and Jacobian */
    gsl_odeiv2_system sys = {lorenz, jaclorenz, size, p};

    /* Initial and final times of integration */
    double t = 0.0, t1 = 10.0;

    /* State vector & initial condition*/
    double x[3];
    x[0] = 2.0;
    x[1] = -1.0;
    x[2] = 150.0;

    /* Vector for storing results */
    double *xt = calloc(4, sizeof(double));

    /* Start Lyapunov algorithm */

    /* Integration interval time T */
    double T = 0.5;
    /* Lyapunov errors */
    double rel_err_l = 1e-6, abs_err_l = 1e-4;
    /* Max number of iterations kmax */
    double kmax = 100;

    /* Perturbations matrix ||u|| */
    gsl_matrix *u_mat = gsl_matrix_alloc(size, size);

    gsl_matrix_set_identity(u_mat);

    printf("%5.5f %5.5f %5.5f\n",
        gsl_matrix_get(u_mat, 0, 0),
        gsl_matrix_get(u_mat, 0, 1),
        gsl_matrix_get(u_mat, 0, 2)
    );
    printf("%5.5f %5.5f %5.5f\n",
        gsl_matrix_get(u_mat, 1, 0),
        gsl_matrix_get(u_mat, 1, 1),
        gsl_matrix_get(u_mat, 1, 2)
    );
    printf("%5.5f %5.5f %5.5f\n",
        gsl_matrix_get(u_mat, 2, 0),
        gsl_matrix_get(u_mat, 2, 1),
        gsl_matrix_get(u_mat, 2, 2)
    );


    /* Integration performance */
    xt = x_t_sol(x, t, t1, h, rel_err, abs_err, integrator, sys, size);
    
    fclose(evol);
    return 0;
}