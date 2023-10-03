#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_fit.h>
#include "../../../../../cursos/modulosc/get_file_lines.h"
#include "../../../../../cursos/modulosc/read_file.h"

int main(void) {
    
    FILE *m_fit, *m_slope;

    m_fit = fopen("../datafiles/m_fit_5.dat", "w");
    m_slope = fopen("../datafiles/m_slopes.dat", "a");

    char filename[1024] = "../datafiles/m_function_5.dat";

    int *shape;

    shape = get_n_lines(filename);

    printf("rows: %d, cols: %d\n", shape[0], shape[1]);

    gsl_matrix *matrix_data;
    double *M_x, *x;
    
    x = calloc(shape[0], sizeof(double));
    M_x = calloc(shape[0], sizeof(double));

    matrix_data = file_data(filename, shape);

    for (unsigned int i = 0; i < shape[0]; i++){
        x[i] = gsl_matrix_get(matrix_data, i, 0);
        M_x[i] = gsl_matrix_get(matrix_data, i, 1);
    }

    double c0, c1, cov00, cov01, cov11, sumsq;

    gsl_fit_linear(x, 1, M_x, 1, shape[0],
                   &c0, &c1, &cov00, &cov01, &cov11, &sumsq);

    for (unsigned int i = 0; i < shape[0]; i++) {
        fprintf(m_fit, "%5.8f %5.8f %5.8f\n", x[i], M_x[i], c0 + c1 * x[i]);
    }

    fprintf(m_slope, "%5.8f\n", c1);

    fclose(m_fit);
    fclose(m_slope);
    gsl_matrix_free(matrix_data);
    free(x);
    free(M_x);

    return 0;
}