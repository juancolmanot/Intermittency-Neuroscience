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
#include "../../../../../cursos/modulosc/gsl_utilities.h"

int main(void) {

    gsl_matrix *A = gsl_matrix_alloc(3, 3);

    gsl_matrix_diagonal(A);

    for (unsigned int i = 0; i < 3; i++) {
        printf("%5.5f %5.5f %5.5f\n", gsl_matrix_get(A, i, 0), gsl_matrix_get(A, i, 1), gsl_matrix_get(A, i, 2));
    }

    return 0;
}




