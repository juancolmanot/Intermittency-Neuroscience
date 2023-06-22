#include <stdlib.h>
#include <stdio.h>
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1, *fp2;

    fp1 = fopen("datafiles/two_dimensional_evolution_0.674103.dat", "w");
    fp2 = fopen("datafiles/two_dimensional_evolution_0.7786251.dat", "w");
    
    unsigned int N1 = 20000;
    unsigned int N2 = 200000;
    unsigned int n_map = 14;
    double* p_alpha = calloc(2, sizeof(double));
    double* p_beta = calloc(2, sizeof(double));
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));

    p_alpha[0] = 0.674103;
    p_alpha[1] = 0.7782651;
    p_beta[0] = 0.5;
    p_beta[1] = 0.3;

    xn[0] = 0.77;
    xn[1] = 0.57;
    xn1[0] = xn1[1] = 0;
     
    for (unsigned int i = 0; i < N1; i++) {        
        // map_2d_n(xn1, xn, n_map, p_alpha[0], p_beta[0]);
        map_2d(xn1, xn, p_alpha[0], p_beta[0]);
        
        if (i % 14 == 0) {
            fprintf(fp1, "%d %.4E %.4E %.4E %.4E\n", i, xn[0], xn[1], xn1[0], xn1[1]);
        }

        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }
    
    for (unsigned int i = 0; i < N2; i++) {        
        // map_2d_n(xn1, xn, n_map, p_alpha[1], p_beta[1]);
        map_2d(xn1, xn, p_alpha[1], p_beta[1]);

        if (i % 14 == 0) {
            fprintf(fp2, "%d %.4E %.4E %.4E %.4E\n", i, xn[0], xn[1], xn1[0], xn1[1]);
        }
        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }
    
    fclose(fp1);
    fclose(fp2);
    return 0;
}

