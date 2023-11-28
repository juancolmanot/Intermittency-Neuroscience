#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_sort_vector.h>
#include "../../../../../cursos/modulosc/lorenz.h"
#include "../../../../../cursos/modulosc/get_file_lines.h"
#include "../../../../../cursos/modulosc/read_file.h"

int main(void) {
    
    FILE *m_region1;

    m_region1 = fopen("../datafiles/m_function_9.dat", "w");

    char filename[1024] = "../datafiles/reinjected_lorenz_9.dat";

    int *shape;

    double *rpd;

    shape = get_n_lines(filename);

    rpd = calloc(shape[0], sizeof(double));

    printf("rows: %d, cols: %d\n", shape[0], shape[1]);

    gsl_vector *vector_data, *x_reinjected;
    
    x_reinjected = gsl_vector_alloc(shape[0]);

    vector_data = file_data_vector(filename, shape[0]);

    for (unsigned int i = 0; i < shape[0]; i++){
        gsl_vector_set(x_reinjected, i, gsl_vector_get(vector_data, i));
    }
    
    gsl_sort_vector(x_reinjected);

    double M_i = 0;
    double c0;
    c0 = gsl_vector_get(x_reinjected, 0) - 0.5 * gsl_vector_get(x_reinjected, 0);

    for (unsigned int i = 0; i < shape[0]; i++){
        M_i += gsl_vector_get(x_reinjected, i);
        fprintf(m_region1, "%5.15f %5.15f %5.15f\n",
            gsl_vector_get(x_reinjected, i),
            M_i / (double) (i + 1),
            c0 + gsl_vector_get(x_reinjected, i) * 0.5
        );
    }

    fclose(m_region1);
    gsl_vector_free(vector_data);
    gsl_vector_free(x_reinjected);

    return 0;
}