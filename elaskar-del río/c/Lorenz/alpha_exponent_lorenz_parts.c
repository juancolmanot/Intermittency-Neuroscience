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
    
    FILE *m_fit_1, *m_fit_2, *m_slope;

    m_fit_1 = fopen("../datafiles/m_fit_7_1.dat", "w");
    m_fit_2 = fopen("../datafiles/m_fit_7_2.dat", "w");
    m_slope = fopen("../datafiles/m_slopes.dat", "a");

    char filename[1024] = "../datafiles/m_function_7.dat";

    int *shape;

    shape = get_n_lines(filename);

    printf("rows: %d, cols: %d\n", shape[0], shape[1]);

    gsl_matrix *matrix_data;
    double *M_x, *x;

    // Declaramos arreglos para dividir serie de datos en dos
    double *M_x1, *x1, *M_x2, *x2;
    
    x = calloc(shape[0], sizeof(double));
    M_x = calloc(shape[0], sizeof(double));

    matrix_data = file_data(filename, shape);

    for (unsigned int i = 0; i < shape[0]; i++){
        x[i] = gsl_matrix_get(matrix_data, i, 0);
        M_x[i] = gsl_matrix_get(matrix_data, i, 1);
        // printf("i: %d; x[i]: %f; Mx[i]: %f\n", i, x[i], M_x[i]);
    }

    int breakcount1, breakcount2;
    int size1, size2;
    int d = 1;

    for (unsigned int i = 0; i < shape[0]; i++){
        if (x[i] >= 40.35 && d == 1) {
            breakcount1 = i;
            d = 0;
        }
        if (x[i] >= 40.85) {
            breakcount2 = i;
            break;
        }
    }

    size1 = breakcount1 + 1;
    size2 = shape[0] - breakcount2 - 1;

    x1 = calloc(size1, sizeof(double));
    M_x1 = calloc(size1, sizeof(double));

    x2 = calloc(size2, sizeof(double));
    M_x2 = calloc(size2, sizeof(double));

    for (unsigned int i = 0; i < size1; i++) {
        x1[i] = x[i];
        M_x1[i] = M_x[i];
    }

    for (unsigned int i = breakcount2 + 1; i < shape[0]; i++) {
        x2[i - breakcount2 - 1] = x[i];
        M_x2[i - breakcount2 - 1] = M_x[i];
    }

    double c0_1, c1_1, cov00_1, cov01_1, cov11_1, sumsq_1;
    double c0_2, c1_2, cov00_2, cov01_2, cov11_2, sumsq_2;

    gsl_fit_linear(x1, 1, M_x1, 1, size1,
                   &c0_1, &c1_1, &cov00_1, &cov01_1, &cov11_1, &sumsq_1);

    gsl_fit_linear(x2, 1, M_x2, 1, size2,
                   &c0_2, &c1_2, &cov00_2, &cov01_2, &cov11_2, &sumsq_2);

    fprintf(m_slope, "%5.8f\n", c1_1);
    fprintf(m_slope, "%5.8f\n", c1_2);

    for (unsigned int i = 0; i < size1; i++) {
        fprintf(m_fit_1, "%5.8f %5.8f %5.8f\n", x1[i], M_x1[i], c0_1 + c1_1 * x1[i]);
    }

    for (unsigned int i = 0; i < size2; i++) {
        fprintf(m_fit_2, "%5.8f %5.8f %5.8f\n", x2[i], M_x2[i], c0_2 + c1_2 * x2[i]);
    }

    fclose(m_fit_1);
    fclose(m_fit_2);
    fclose(m_slope);
    gsl_matrix_free(matrix_data);
    free(x);
    free(M_x);
    free(x1);
    free(M_x1);
    free(x2);
    free(M_x2);

    return 0;
}