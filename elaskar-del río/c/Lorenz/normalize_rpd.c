/* Incluímos librerías */

#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include <gsl/gsl_vector.h>
#include <gsl/gsl_errno.h>
#include <gsl/gsl_matrix.h>
#include <gsl/gsl_sort_vector.h>
#include <gsl/gsl_statistics.h>
#include "../../../../../cursos/modulosc/lorenz.h"
#include "../../../../../cursos/modulosc/get_file_lines.h"
#include "../../../../../cursos/modulosc/read_file.h"
#include "../../../../../cursos/modulosc/intermittency.h"


int main(void) {
    
    /* Abrimos archivo a almacenar ajuste de rpd. */

    FILE *rpd_fit;

    rpd_fit = fopen("../datafiles/rpd_fit_1.dat", "w");

    /* Nombramos archivos de donde leeremos los datos */

    char filename1[1024] = "../datafiles/rpd_lorenz_1.dat";
    char filename2[1024] = "../datafiles/rpd_weights.dat";
    char filename3[1024] = "../datafiles/m_slopes.dat";

    /* Punteros para almacenar la forma de cada archivo de datos */

    int *shape1, *shape2, *shape3;

    /* Puntero para almacenar la rpd */
    double *rpd;

    /* Obtenemos la forma de cada archivo de datos */
    shape1 = get_n_lines(filename1);
    shape2 = get_n_lines(filename2);
    shape3 = get_n_lines(filename3);

    /* Alocamos arreglo */
    rpd = calloc(shape1[0], sizeof(double));

    printf("rows1: %d, cols1: %d\n", shape1[0], shape1[1]);
    printf("rows2: %d, cols2: %d\n", shape2[0], shape2[1]);
    printf("rows3: %d, cols3: %d\n", shape3[0], shape3[1]);

    /* Declaramos y alocamos arreglos para almacenar datos */
    gsl_vector *count_data, *rpd_x, *x, *m_slopes;
    gsl_matrix *matrix_data;
    rpd_x = gsl_vector_alloc(shape1[0]);
    x = gsl_vector_alloc(shape1[0]);
    
    /* Leemos y alocamos arreglos de datos */
    matrix_data = file_data(filename1, shape1);
    count_data = file_data_vector(filename2, shape2[0]);
    m_slopes = file_data_vector(filename3, shape3[0]);

    /* Inicializamos contador de puntos reinyectados totales */
    int count_tot = 0;
    /* Sumamos todos los puntos reinyectados */
    for (unsigned int i = 0; i < shape2[0]; i++){
        count_tot += gsl_vector_get(count_data, i);
    }
    /* Abrimos archivo para escribir la rpd normalizada numérica */
    FILE *rpd_norm = fopen("../datafiles/rpd_lorenz_1_norm.dat", "w");

    /* Escribimos vectores x y rpd y a su vez el archivo de la rpd normalizada */
    for (unsigned int i = 0; i < shape1[0]; i++){
        gsl_vector_set(x, i, gsl_matrix_get(matrix_data, i, 0));
        gsl_vector_set(rpd_x, i, (gsl_matrix_get(matrix_data, i, 1) * gsl_vector_get(count_data, 0)) / (double) count_tot);
        fprintf(rpd_norm, "%5.8f %5.8f\n", gsl_vector_get(x, i), gsl_vector_get(rpd_x, i));
    }

    /* Declaramos las variables y parámetros a usar en la normalización */
    double wi; // Proporción del área a ocupar por la rpd_i
    double alpha, b, m; // parámetros de la función rpd y pendiende de la función M
    
    /* Computamos los diferentes parámetros */
    wi = (double) gsl_vector_get(count_data, 0) / (double) count_tot;
    m = gsl_vector_get(m_slopes, 0);
    alpha = (2 * m - 1) / (1 - m);

    /* Declaramos las variables a usar para la integración */
    double integral_rpd, dx, xc, xi;
    
    /* Límite inferior de la región laminar y paso de integración del dominio */
    xc = gsl_vector_get(x, 0);
    dx = (gsl_vector_get(x, 1) - gsl_vector_get(x, 0)) / (double) shape1[0];

    FILE *integral_calc = fopen("../datafiles/integral_test.dat", "w");

    /* Computamos la integral */
    // integral_rpd += 0.5 * powf(gsl_vector_get(x, 0) - xc, alpha) * dx;
    // fprintf(integral_calc, "%5.8f %5.8f %5.8f\n",
    //     gsl_vector_get(x, 0),
    //     powf(gsl_vector_get(x, 0) - xc, alpha),
    //     integral_rpd
    // );
    for (unsigned int i = 1; i < shape1[0] - 1; i++) {
        integral_rpd += powf(gsl_vector_get(x, i) - xc, alpha) * dx;
        fprintf(integral_calc, "%5.8f %5.8f %5.8f\n",
        gsl_vector_get(x, i),
        powf(gsl_vector_get(x, i) - xc, alpha),
        integral_rpd
    );
    }
    integral_rpd += 0.5 * powf(gsl_vector_get(x, shape1[0] - 1) - xc, alpha) * dx;
    fprintf(integral_calc, "%5.8f %5.8f %5.8f\n",
        gsl_vector_get(x, shape1[0] - 1),
        powf(gsl_vector_get(x, shape1[0] - 1) - xc, alpha),
        integral_rpd
    );
    // integral_rpd *= dx;

    /* Cálculo de constante de normalización */
    b = wi / integral_rpd;

    printf("wi: %f, integral_rpd: %f, b: %f\n", wi, integral_rpd, b);

    for (unsigned int i = 0; i < shape1[0]; i++) {
        xi = gsl_vector_get(x, i);
        fprintf(rpd_fit, "%5.8f %5.8f %5.8f\n", xi, gsl_vector_get(rpd_x, i), b * powf(xi - xc, alpha));
    }

    free(shape1);
    free(shape2);
    fclose(rpd_norm);
    fclose(rpd_fit);
    fclose(integral_calc);
    gsl_matrix_free(matrix_data);
    gsl_vector_free(count_data);
    gsl_vector_free(rpd_x);
    // gsl_integration_workspace_free(iw);

    return 0;
}