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

    rpd_fit = fopen("../datafiles/rpd_6_norm_fitted.dat", "w");

    /* Nombramos archivos de donde leeremos los datos */

    char filename1[1024] = "../datafiles/rpd_lorenz_6.dat";
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

    printf("rpd lorenz 3 : rows1: %d, cols1: %d\n", shape1[0], shape1[1]);
    printf("rpd weights : rows2: %d, cols2: %d\n", shape2[0], shape2[1]);
    printf("m slopes: rows3: %d, cols3: %d\n", shape3[0], shape3[1]);

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
    FILE *rpd_norm = fopen("../datafiles/rpd_6_norm_numerical.dat", "w");
    
    /* Escribimos vectores x y rpd y a su vez el archivo de la rpd normalizada */
    for (unsigned int i = 0; i < shape1[0]; i++){
        gsl_vector_set(x, i, gsl_matrix_get(matrix_data, i, 0));
        gsl_vector_set(rpd_x, i, gsl_matrix_get(matrix_data, i, 1));
        fprintf(rpd_norm, "%5.8f %5.8f\n", gsl_vector_get(x, i), gsl_vector_get(rpd_x, i));
    }

    /* Declaramos las variables y parámetros a usar en la normalización */
    double wi, wi_1, wi_2; // Proporción del área a ocupar por la rpd_i
    double alpha_1, b_1, m_1; // parámetros de la función rpd y pendiende de la función M
    double alpha_2, b_2, m_2;

    double i_break = 0;
    double count_wi_1, count_wi_2;

    count_wi_1 = count_wi_2 = 0;

    /* Declaramos las variables a usar para la integración */
    double integral_rpd_1, integral_rpd_2, xc_1, xc_2, xi;
    
    /* Límite inferior de la región laminar y paso de integración del dominio */
    // xc = gsl_vector_get(x, 0);
    xc_1 = 39;
    xc_2 = 40.6;

    for (unsigned int i = 0; i < shape1[0]; i++) {
        count_wi_1 += gsl_vector_get(rpd_x, i);
        printf("%f\n", count_wi_1);
        if (fabs(gsl_vector_get(x, i) - xc_2) <= 1e-2) {
            i_break = (double)i;
            break;
        }
    }

    count_wi_2 = gsl_vector_get(count_data, 5) - count_wi_1;

    wi_1 = (double) count_wi_1 / (double) count_tot;
    wi_2 = (double) count_wi_2 / (double) count_tot;

    printf("wi1: %f, wi2: %f\n", wi_1, wi_2);

    /* Computamos los diferentes parámetros */
    wi = (double) gsl_vector_get(count_data, 5) / (double) count_tot;
    m_1 = gsl_vector_get(m_slopes, 7);
    // m_1 = 0.5;
    alpha_1 = (2 * m_1 - 1) / (1 - m_1);
    m_2 = gsl_vector_get(m_slopes, 8);
    alpha_2 = (2 * m_2 - 1) / (1 - m_2);

    printf("m1: %f, alpha1: %f\n", m_1, alpha_1);
    printf("m2: %f, alpha2: %f\n", m_2, alpha_2);

    double integral_numeric_1, dx, b_numeric_1;
    double integral_numeric_2, b_numeric_2;

    dx = (gsl_vector_get(x, 1) - gsl_vector_get(x, 0));

    for (unsigned int i = 0; i < i_break; i++) {
        integral_numeric_1 += gsl_vector_get(rpd_x, i);
    }

    for (unsigned int i = i_break; i < shape1[0]; i++) {
        integral_numeric_2 += gsl_vector_get(rpd_x, i);
    }
    
    integral_numeric_1 = integral_numeric_1 * dx;
    b_numeric_1 = wi_1 / integral_numeric_1;

    integral_numeric_2 = integral_numeric_2 * dx;
    b_numeric_2 = wi_2 / integral_numeric_2;   
    

    FILE *integral_calc = fopen("../datafiles/integral_test.dat", "w");

    /* Computamos la integral */
    for (unsigned int i = 1; i < i_break - 1; i++) {
        integral_rpd_1 += powf(gsl_vector_get(x, i) - xc_1, alpha_1);
    }
    integral_rpd_1 += 0.5 * powf(gsl_vector_get(x, i_break) - xc_1, alpha_1);
    integral_rpd_1 *= dx;

    for (unsigned int i = i_break + 1; i < shape1[0]; i++) {
        // printf("int rpd 2: %f\n", integral_rpd_2);
        integral_rpd_2 += powf(gsl_vector_get(x, i) - xc_2, alpha_2);
    }
    integral_rpd_2 += 0.5 * powf(gsl_vector_get(x, shape1[0] - 1) - xc_2, alpha_2);
    integral_rpd_2 *= dx;

    /* Cálculo de constante de normalización */
    b_1 = wi_1 / integral_rpd_1;
    b_2 = wi_2 / integral_rpd_2;

    printf("wi_1: %f, integral_rpd_1: %f, b_1: %f\n", wi_1, integral_rpd_1, b_1);
    printf("wi_1: %f, integral_numerical_1: %f, b_numerical_1: %f\n", wi_1, integral_numeric_1, b_numeric_1);
    printf("alpha_1: %f\n", alpha_1);

    printf("wi_2: %f, integral_rpd_2: %f, b_2: %f\n", wi_2, integral_rpd_2, b_2);
    printf("wi_2: %f, integral_numerical_2: %f, b_numerical_2: %f\n", wi_2, integral_numeric_2, b_numeric_2);
    printf("alpha_2: %f\n", alpha_2);

    printf("wi: %f\n", wi);

    for (unsigned int i = 0; i < i_break; i++) {
        xi = gsl_vector_get(x, i);
        fprintf(rpd_fit, "%5.8f %5.8f %5.8f\n", xi, b_numeric_1 * gsl_vector_get(rpd_x, i), b_1 * powf(xi - xc_1, alpha_1));
    }

    
    for (unsigned int i = i_break; i < shape1[0]; i++) {
        xi = gsl_vector_get(x, i);
        fprintf(rpd_fit, "%5.8f %5.8f %5.8f\n", xi, b_numeric_2 * gsl_vector_get(rpd_x, i), b_2 * powf(xi - xc_2, alpha_2));
    }

    free(shape1);
    free(shape2);
    fclose(rpd_norm);
    fclose(rpd_fit);
    fclose(integral_calc);
    gsl_matrix_free(matrix_data);
    gsl_vector_free(count_data);
    gsl_vector_free(rpd_x);

    return 0;
}