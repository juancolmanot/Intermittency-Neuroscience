#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    /* Open file where output will be written */
    FILE *fp = fopen("datafiles/two_dimensional_bifurcation.dat", "w");


    /* Parameters of the computation */
    unsigned int n_alfa = 1000; // Number of alfa coefficients to compute
    unsigned int n_iterations = 30000; // Number of iterations per alfa.
    unsigned int transient = 29000; // predetermined transient period
    unsigned int n_map = 14;

    double p_alfa, p_beta; // Declare both parameters
    double alfa_c = 0.674149344;
    const double eps_alfa = 5e-5;
    const double min_alfa = 0.6; // Minimum value of alfa to be computed
    const double max_alfa = 0.85; // Maximum value of alfa to be computed
    const double dalfa = (max_alfa - min_alfa) / (double)(n_alfa - 1); // Alfa step between to consecutive values
    
    /* Allocate the arrays for the states of the system */
    double* xn = malloc(2 * sizeof(double));
    double* xn1 = malloc(2 * sizeof(double));

    /* Initialize the generator for random initial conditions */
    unsigned int seed = 88492;
    
    /* Initialize the parameters with the predetermined values */
    p_alfa = min_alfa;
    p_beta = 0.5;

    /* Define control variable for checkign divergence */
    unsigned int m = 0;
    
    /* Initialize generator */
    init_genrand64(seed);

    /* Loop through the alfas */
    for (unsigned int i = 0; i < n_alfa; i++) {
    
        /* Define the initial state depending on alpha */
        if (p_alfa < 0.72) {
            /* Initialize the initial random state bewteen 0 and 1 */
            xn[0] = genrand64_real3();
            xn[1] = genrand64_real3();
        }
        else if (p_alfa >= 0.72) {
            /* Force initial state to stable basin of atraction */
            xn[0] = 0.5;
            xn[1] = 0.5;
        }
        
        
        /* Set xn1 to zero */
        xn1[0] = xn1[1] = 0;

        /* Evolve the system in time */
        for (unsigned int j = 0; j < n_iterations; j++) {
            // mapa(xn1, xn, p_alfa, p_beta); // Compute the map
            map_2d(xn1, xn, p_alfa, p_beta);

            /* Write to file if transient is passed*/
            if (j > transient) {
                fprintf(fp, "%.16E %.16E %.16E\n", p_alfa, xn[0], xn[1]);
            }

            /* Update the state vector */
            xn[0] = xn1[0];
            xn[1] = xn1[1];
        }
        seed = rand();
        p_alfa = p_alfa + dalfa; // Increment alfa
    }
    fclose(fp);
    printf("Finalizado\n");
    return 0;
}