#include <stdlib.h>
#include <stdio.h>

/* Function that evaluates the map given the (x, y) values */

static void mapa(double* x1, double* x, double alfa, double beta) {
    
    x1[0] = 4.f * alfa * x[0] * (1.f - x[0]) + beta * x[1] * (1.f - x[0]);
    x1[1] = 4.f * alfa * x[1] * (1.f - x[1]) + beta * x[0] * (1.f - x[1]);
}

int main() {

    /* Open file where output will be written */
    FILE *fp = fopen("datafiles/Two_Dimensional_Bifurcation.dat", "w");

    /* Define column names and separation between them*/
    char colnames[3][5] = {"alfa", "xn", "yn"};
    unsigned int n = 9;

    /* Parameters of the computation */
    unsigned int n_alfa = 10; // Number of alfa coefficients to compute
    unsigned int n_iterations = 8000; // Number of iterations per alfa.
    unsigned int transient = 5000; // predetermined transient period

    double p_alfa, p_beta; // Declare both parameters
    const double min_alfa = 0.8; // Minimum value of alfa to be computed
    const double max_alfa = 0.85; // Maximum value of alfa to be computed
    const double dalfa = (max_alfa - min_alfa) / (float)n_alfa; // Alfa step between to consecutive values
    
    /* Allocate the arrays for the states of the system */
    double* xn = malloc(2 * sizeof(float));
    double* xn1 = malloc(2 * sizeof(float));

    /* Initialize the generator for random initial conditions */
    unsigned int seed = 88492;
    
    /* Write the column names in the first row of the file */
    fprintf(fp, "%*.*s %*.*s %*.*s\n", \
        0, n, &colnames[0], n+1, n, &colnames[1], n+2, n, colnames[2]); 

    /* Initialize the parameters with the predetermined values */
    p_alfa = min_alfa;
    p_beta = 0.5;

    /* Loop through the alfas */
    for (unsigned int i = 0; i < n_alfa; i++) {
        /* Initialize generator */
        srand(seed);
        
        /* Initialize the initial random state bewteen 0 and 1 */
        xn[0] = (double)rand() / (double)RAND_MAX;
        xn[1] = (double)rand() / (double)RAND_MAX;
        
        /* Set xn1 to zero */
        xn1[0] = xn1[1] = 0.f;

        /* Evolve the system in time */
        for (unsigned int j = 0; j < n_iterations; j++) {
            mapa(xn1, xn, p_alfa, p_beta); // Compute the map
            
            /* Write to file if transient is passed*/
            if (j > transient) {
                fprintf(fp, "%.4E %.4E %.4E\n", p_alfa, xn[0], xn[1]);
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