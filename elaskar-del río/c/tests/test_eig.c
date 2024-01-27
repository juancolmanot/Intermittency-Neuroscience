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
#include "../../../../../cursos/modulosc/gsl_utilities.h"

int main(void) {

    Parameters *p = malloc(sizeof(Parameters));

    p->a = 10.0;
    p->b = 166.07;
    p->c = 8.0 / 3.0;

    double x[3] = {1.0, 3.0, -2.0};

    int size = 3;

    gsl_matrix *A = gsl_matrix_alloc(size, size);

    // A = lorenz_J(x, p);

    gsl_matrix_set_identity(A);

    gsl_matrix_scale(A, 3.0);

    gsl_vector *eval = gsl_vector_alloc(size);
    gsl_matrix *evec = gsl_matrix_alloc(size, size);

    eval = gsl_eigenvalues(A, size);
    evec = gsl_eigenvectors(A, size);

    printf("Autovalores y Autovectores\n");
    for (unsigned int i = 0; i < size; i++) {
        printf("lambda_%d: %5.5f\n", i + 1, gsl_vector_get(eval, i));
        printf("v_%d: [%5.5f, %5.5f, %5.5f]\n",
            i + 1,
            gsl_matrix_get(evec, 0, i),
            gsl_matrix_get(evec, 1, i),
            gsl_matrix_get(evec, 2, i)
        );
    }

    return 0;
}