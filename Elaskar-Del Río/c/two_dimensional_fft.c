#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include <fftw3.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/intermittency.h"

int main() {

    FILE *fp = fopen("datafiles/two_dimensional_fft_x.dat", "w");
    FILE *fp1 = fopen("datafiles/two_dimensional_trajectory_x.dat", "w");
    
    unsigned int N = 10000;
    unsigned long long seed = rand();
    unsigned int n_map = 14;
    double alpha_c, beta;
    double* xn = calloc(2, sizeof(double));
    double* xn1 = calloc(2, sizeof(double));
    double epsilon, alpha_i;

    fftw_complex *x_evol, *f_evol;
    fftw_plan plan;
    double frequency, amplitude, maxAmp, period;
    double* amplitudes = calloc((unsigned int) N / 2, sizeof(double));

    x_evol = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);
    f_evol = (fftw_complex*) fftw_malloc(sizeof(fftw_complex) * N);

    alpha_c = 0.674013;
    beta = 0.5;

    epsilon = 0;

    alpha_i = alpha_c - epsilon;

    init_genrand64(seed);

    xn[0] = 0.7;
    xn[1] = 0.2;
    xn1[0] = xn1[1] = 0;

    for (unsigned int i = 0; i < N; i++) {

        map_2d_n(xn1, xn, n_map, alpha_i, beta);
        
        x_evol[i][0] = xn[0];
        x_evol[i][1] = 0;

        fprintf(fp1, "%d    %5.15f  %5.15f\n", i, xn[0], x_evol[i][0]);

        xn[0] = xn1[0];
        xn[1] = xn1[1];
    }

    plan = fftw_plan_dft_1d(N, x_evol, f_evol, FFTW_FORWARD, FFTW_ESTIMATE);

    fftw_execute(plan);

    for (unsigned int i = 0; i < N / 2; i++) {
        amplitudes[i] = sqrt(pow(f_evol[i][0], 2) + pow(f_evol[i][1], 2));
    }

    maxAmp = max(amplitudes, N/2);
    
    for (unsigned int i = 0; i < N / 2; i++) {
        amplitude = amplitudes[i]; // maxAmp;
        frequency = (double)i / N;
        period = 1 / frequency;
        if (period > 10e4) {
            period = 0;
        }
        fprintf(fp, "%5d    %5.15f  %5.15f  %5.15f  %5.15f\n", i, x_evol[i][0], frequency, amplitude, period);
    }

    fftw_destroy_plan(plan);
    fftw_free(x_evol);
    fftw_free(f_evol);
    free(xn);
    free(xn1);
    fclose(fp1);
    fclose(fp);
    return 0;
}

