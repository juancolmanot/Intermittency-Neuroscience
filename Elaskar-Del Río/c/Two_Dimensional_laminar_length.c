#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../modulosc/linear_algebra.h"
#include "../../../modulosc/intermittency.h"


/* Declare function that computes the map */

static void mapa(double* x1, double* x, double alfa, double beta) {
    
    x1[0] = 4.f * alfa * x[0] * (1.f - x[0]) + beta * x[1] * (1.f - x[0]);
    x1[1] = 4.f * alfa * x[1] * (1.f - x[1]) + beta * x[0] * (1.f - x[1]);
}

int main() {

    printf("%d", 2);
    /* Open file to write data */
    FILE *fp = fopen("datafiles/Two_Dimensional_Evolution.dat", "w");

    /* Hyper-parameters and variables for script */
    unsigned int j, k, m;

    /* Parameters for reinjection and intermittency */
    unsigned int n_reinjected = 15000; // Number of points to be reinjected
    unsigned int n_bins_x = 200; // Number of sub-intervals of laminar interval of states
    unsigned int n_bins_l = 50; // Number of sub-intervals of length of laminar phases

    double lbr, ubr; // lower and upper boundaries of reinjection
    double lavg; // average laminar length

    double* x_reinjected = malloc(n_reinjected * sizeof(double)); // Array for storing reinjected points
    double* prob_x = malloc(n_bins_x * sizeof(double)); // Array for storing probability density of reinjection 
    double* x_avg = malloc(n_bins_x * sizeof(double)); // Array for storing average values of reinjection points
    unsigned int* n_r = malloc(n_bins_x * sizeof(double)); // Counter for reinjection points
    double* x_bins = malloc((n_bins_x + 1) * sizeof(double)); // Domain of laminar region for the x,y variables
    
    double* laminar_lengths = malloc(n_reinjected * sizeof(double)); // Array for storing laminar lengths
    double* prob_l = malloc(n_bins_l * sizeof(double)); // Array for storing probability density of laminar length 
    double* avg_l = malloc(n_bins_l * sizeof(double)); // Array for storing average values of laminar length
    unsigned int* n_l = malloc(n_bins_l * sizeof(double)); // Counter for laminar lengths
    double* l_bins = malloc((n_bins_l + 1) * sizeof(double)); // Domain of lengths of laminar phases

    /* System variables */
    unsigned int n_alpha = 100;
    double p_alpha_c, p_alpha, p_beta; // Parameters alpha, beta and alpha critical. 
    double dalpha, alpha_min, alpha_max; // Alpha parameter limits and step size
    double* xn = malloc(2 * sizeof(double)); // Nth iteration state vector
    double* xn1 = malloc(2 * sizeof(double)); // N+1th iteration state vector

    /* Asign values to parameters and initial conditions */
    p_alpha_c = 0.674149344;
    p_beta = 0.5;
    alpha_min = p_alpha_c - exp((double)-24);
    alpha_max = p_alpha_c - exp((double)-19);
    dalpha = (alpha_max - alpha_min) / (double) n_alpha;
    p_alpha = alpha_min;
    xn[0] = 0.75;
    xn[1] = 0.7;
    xn1[0] = xn1[1] = 0.f;

    j = k = m = 0;

    lbr = 0;
    ubr = 0.05;

    x_bins = linspace(lbr, ubr, n_bins_x + 1);
    x_bins = linspace((double)1, (double)n_bins_l, n_bins_l + 1);


    for (unsigned int i = 0; i < n_alpha; i++) {
        while (k < n_reinjected) {
            j++;
            mapa(xn1, xn, p_alpha, p_beta);
            if (reinjection(xn1[0], xn[0], ubr, lbr)) {
                x_reinjected[k] = xn1[0];
                k++;
                m = j;
            }
            else if (ejection(xn1[0], xn[0], ubr, lbr)) {
                laminar_lengths[k] = j - m;
            }
        }

        for (unsigned int i = 0; i <= n_reinjected; i++) {
            for (j = 0; j <= n_bins_x; j++) {
                if (x_reinjected[i] > x_bins[j] && x_reinjected[i] < x_bins[j + 1]) {
                    x_avg[j] += x_reinjected[i];
                    n_r[j] += 1;
                }
            }
            for (j = 0; j <= n_bins_l; j++) {
                if (laminar_lengths[i] > l_bins[j] && laminar_lengths[i] < l_bins[j + 1]) {
                    avg_l[j] += laminar_lengths[i];
                    n_l[j] += 1;
                }
            }
        }

        for (unsigned int i = 0; i < n_bins_x; i++) {
            x_avg[i] /= n_r[i];
            prob_x[i] = n_r[i] / (double)n_reinjected;
        }

        for (unsigned int i = 0; i < n_bins_l; i++) {
            avg_l[i] /= n_l[i];
            prob_l[i] = n_l[i] / (double)n_reinjected;
        }

        lavg = 0;

        for (unsigned int i = 0; i < n_bins_l; i++) {
            lavg += avg_l[i]*prob_l[i];
        }

        fprintf(fp, "%f %f\n", p_alpha, lavg);
        p_alpha += dalpha;
    }
    

    fclose(fp);
    printf("Finished\n");
    return 0;
}