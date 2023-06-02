#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <fftw3.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp0 = fopen("datafiles/two_dimensional_evolution_x.dat", "w");
    FILE* fp1 = fopen("datafiles/two_dimensional_dft_x.dat", "w");

    unsigned int N = 3000;
    unsigned long long seed = rand();
    unsigned int n_map = 14;
    double alpha_c, beta;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double epsilon, alpha_i;
    
    fftw_complex *x_evol, *f_evol;
    fftw_plan p;

    x_evol = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
    f_evol = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);

    alpha_c = 0.674149344;
    beta = 0.5;

    epsilon = 2e-5;

    alpha_i = alpha_c - epsilon;

    init_genrand64(seed);

    xn[0] = genrand64_real3();
    xn[1] = genrand64_real3();
    xn1[0] = xn1[1] = 0;

    for (unsigned int i = 0; i < N; i++) {

        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        fprintf(fp0, "%d %5.15f %5.15f  %5.15f  %5.15f\n", i, xn[0], xn[1], xn1[0], xn1[1]);

        x_evol[i][0] = xn[0];
        x_evol[i][0] = 0;

        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    p = fftw_plan_dft_1d(N, x_evol, f_evol, FFTW_FORWARD, FFTW_ESTIMATE);

    fftw_execute(p);

    for (unsigned int i = 0; i < N; i++) {
        fprintf(fp1, "%d    %5.15f    %5.15f\n", i, f_evol[i][0], f_evol[i][1]);
    }

    fftw_destroy_plan(p);
    fftw_free(x_evol);
    fftw_free(f_evol);
    free(xn);
    free(xn1);
    fclose(fp0);
    fclose(fp1);
    return 0;
}

