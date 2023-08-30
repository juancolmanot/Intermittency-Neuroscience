#include <stdlib.h>
#include <stdio.h>
#include <time.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"


int main() {

    FILE *fp1, *fp2, *fp3, *fp4;
    
    fp1 = fopen("datafiles/two_dimensional_channel_x_14_0.674149344_eps.dat", "w");
    fp2 = fopen("datafiles/two_dimensional_channel_y_14_0.674149344_eps.dat", "w");
    fp3 = fopen("datafiles/two_dimensional_dchannel_x_14_0.674149344_eps.dat", "w");
    fp4 = fopen("datafiles/two_dimensional_dchannel_y_14_0.674149344_eps.dat", "w");
    
    unsigned int N = 200000;
    unsigned int transient = (unsigned int) N * 0.3;
    unsigned int n_map = 14;
    unsigned int n_eps = 200;
    double p_alpha = 0.674103;
    double p_beta = 0.5;
    double epsilon, depsilon;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));

    double distance_line_y = 2;
    double min_channel_y = 10;
    double dmin_channel_y = 1;
    double distance_line_x = 2;
    double min_channel_x = 10;
    double dmin_channel_x = 1;

    double x0, y0;

    x0 = 0.5;
    y0 = 0.3;

    epsilon = 1e-11;
    depsilon = 1e-12;

    unsigned int seed = (unsigned int)time(NULL);

    init_genrand64(seed);

    for (unsigned int j = 0; j < n_eps; j++) {

        min_channel_x = min_channel_y = 2;
        dmin_channel_x = dmin_channel_y = 2;
        
        xn[0] = x0; //genrand64_real3();
        xn[1] = y0; //genrand64_real3();
    
        xn1[0] = xn1[1] = 0;
    
        for (unsigned int i = 0; i < N; i++) {
            map_2d_n(xn1, xn, n_map, p_alpha - epsilon, p_beta);
            
            distance_line_x = fabs(xn[0] - xn1[0]) / sqrt(2);
            distance_line_y = fabs(xn[1] - xn1[1]) / sqrt(2);
            
            if (distance_line_x < min_channel_x) {
                dmin_channel_x = distance_line_x - min_channel_x;
                min_channel_x = distance_line_x;
                fprintf(fp3, "%d %5.15f\n", i, dmin_channel_x);
            }

            if (distance_line_y < min_channel_y) {
                dmin_channel_y = distance_line_y - min_channel_y;
                min_channel_y = distance_line_y;
                fprintf(fp4, "%d %5.15f\n", i, dmin_channel_y);
            }

            xn[0] = xn1[0];
            xn[1] = xn1[1];
        }
        fprintf(fp1, "%5.15f  %5.15f\n", epsilon, min_channel_x);
        fprintf(fp2, "%5.15f  %5.15f\n", epsilon, min_channel_y);
        
        if (j % 10 == 0){
            depsilon = depsilon * sqrt(10);
        }
        
        epsilon += depsilon;
    }
    
    fclose(fp1);
    return 0;
}

