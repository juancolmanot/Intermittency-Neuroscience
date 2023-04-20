#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../modulosc/linear_algebra.h"

/* Declare function that computes the map */

static void mapa(double* x1, double* x, double alfa, double beta) {
    
    x1[0] = 4.f * alfa * x[0] * (1.f - x[0]) + beta * x[1] * (1.f - x[0]);
    x1[1] = 4.f * alfa * x[1] * (1.f - x[1]) + beta * x[0] * (1.f - x[1]);
}

int main() {

    /* Open file to write data */
    FILE *fp = fopen("datafiles/Two_Dimensional_Evolution.dat", "w");

    /* Define column names */
    char colnames[4][4] = {"ln(ac-a)", "l"};
    
    /* Size of data written */
    unsigned int n = 9;

    /* Print to file the first row with column names */
    fprintf(fp, "%*.*s %*.*s\n",\
    0, n, &colnames[0], n+1, n, &colnames[1]);

    /* Hyper-parameters and variables for script */
    unsigned int i, j, k;

    /* Parameters for reinjection and intermittency */
    unsigned int n_reinjected = 15000; // Number of points to be reinjected
    unsigned int n_bins_x = 200; // Number of sub-intervals of laminar interval of states
    unsigned int n_bins_l = 50; // Number of sub-intervals of length of laminar phases

    double lbr, ubr; // lower and upper boundaries of reinjection
    unsigned int l, lavg; // current and average laminar length

    double* x_reinjected = malloc(n_reinjected * sizeof(double)); // Array for storing reinjected points
    double* prob_r = malloc(n_bins_x * sizeof(double)); // Array for storing probability density of reinjection
    unsigned int* n_r = malloc(n_bins_x * sizeof(double)); // Counter for reinjection points
    double* x_bins = malloc((n_bins_x + 1) * sizeof(double)); // Domain of laminar region for the x,y variables
    
    double* laminar_lengths = malloc(n_reinjected * sizeof(double)); // Array for storing laminar lengths
    double* prob_l = malloc(n_bins_l * sizeof(double)); // Array for storing probability density of laminar length
    unsigned int* n_l = malloc(n_bins_l * sizeof(double)); // Counter for laminar lengths
    double* l_bins = malloc((n_bins_l + 1) * sizeof(double)); // Domain of lengths of laminar phases

    /* System variables */
    double p_alpha_c, p_alpha, p_beta; // Parameters alpha, beta and alpha critical. 
    double* xn = malloc(2 * sizeof(double)); // Nth iteration state vector
    double* xn1 = malloc(2 * sizeof(double)); // N+1th iteration state vector

    /* Asign values to parameters and initial conditions */
    p_alpha_c = 0.674103;
    p_beta = 0.5f;
    p_alpha = p_alpha_c - exp((double)-24);
    xn[0] = 0.75;
    xn[1] = 0.7;
    xn1[0] = xn1[1] = 0.f;

    i = j = k = 0;

    for ()
    while (j < n_reinjected) {
        i++;
        /* Compute the map */
        mapa(xn1, xn, p_alfa_c, p_beta);
        if ()


        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    fclose(fp);
    printf("Finished\n");
    return 0;
}