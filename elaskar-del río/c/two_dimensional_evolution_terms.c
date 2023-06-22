#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Open file where output will be written */
    FILE *fp = fopen("datafiles/two_dimensional_evolution_terms.dat", "w");


    /* Parameters of the computation */
    unsigned int n_iterations = 1000; // Number of iterations per alfa.
    unsigned int n_map = 14;

    double p_alfa, p_beta; // Declare both parameters
    double alfa_c = 0.674149344;
    
    /* Allocate the arrays for the states of the system */
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));

    /* Terms */
    double x_squared, x_linear, y_linear, xy_crossed;

    /* Initialize the generator for random initial conditions */
    unsigned int seed = 88492;
    
    /* Initialize the parameters with the predetermined values */
    p_alfa = alfa_c;
    p_beta = 0.5;

    /* Define control variable for checkign divergence */
    unsigned int m = 0;
    
    /* Initialize generator */
    init_genrand64(seed);        
        
    /* Set xn1 to zero */
    xn1[0] = xn1[1] = 0;

    xn[0] = genrand64_real3();
    xn[1] = genrand64_real3();

    /* Evolve the system in time */
    for (unsigned int j = 0; j < n_iterations; j++) {
        map_2d_n(xn1, xn, n_map, p_alfa, p_beta);

        x_squared = - 4 * p_alfa * xn[0] * xn[0];
        x_linear = 4 * p_alfa * xn[0];
        y_linear = p_beta * xn[1];
        xy_crossed = - p_beta * xn[0] * xn[1];

        fprintf(fp, "%d %.16E %.16E %.16E %.16E %.16E %.16E\n", j, xn[0], x_squared, x_linear, y_linear, xy_crossed, xn[1]);
        
        /* Update the state vector */
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    fclose(fp);
    printf("Finalizado\n");
    return 0;
}