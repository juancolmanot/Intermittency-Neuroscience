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
#include "../../../../../cursos/modulosc/get_file_lines.h"
#include "../../../../../cursos/modulosc/read_file.h"

int main(void) {
    
    char filename[1024] = "../datafiles/rpd_lorenz_1.dat";

    int *shape;

    double x_lam, rpd;

    shape = get_n_lines(filename);

    printf("rows: %d, cols: %d\n", shape[0], shape[1]);

    gsl_matrix *m;

    m = file_data(filename, shape);

    for (unsigned int i = 0; i < shape[0]; i++){
        x_lam = gsl_matrix_get(m, i, 0);
        rpd = gsl_matrix_get(m, i, 1);
        printf("m[%d, 0]: %f, m[%d, 1]: %f\n",i ,x_lam, i, rpd);
    }

    return 0;
}