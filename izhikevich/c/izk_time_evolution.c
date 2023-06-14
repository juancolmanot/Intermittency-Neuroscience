#include <stdlib.h>
#include <stdio.h>
#include <math.h>
#include "../../../../cursos/modulosc/mt64.h"
#include "../../../../cursos/modulosc/linear_algebra.h"
#include "../../../../cursos/modulosc/izhikevich.h"


int main(){

	unsigned long long seed;
	unsigned int n = 1000;
	double a, b, c, d, I;
	double* x = calloc(2, sizeof(double));
	double* x1 = calloc(2, sizeof(double));

	a = 0.02;
	b = 0.25;
	c = -55;
	d = 0;
	I = - 0.8;

	seed = (unsigned long long)rand();

	init_genrand64(seed);

	x[0] = -20; //(double)genrand64_real3();
	x[1] = 5; //(double)genrand64_real3();
	x1[0] = x1[1] = 0;

	FILE* fp = fopen("datafiles/izk_time_evolution.dat", "w");

	for (unsigned int i = 0; i < n; i++) {

		iz_map(x1, x, a, b, c, d, I);

		fprintf(fp, "%d	%4.10f	%4.10f	%4.10f	%4.10f\n", i, x[0], x[1], x1[0], x1[1]);
		x[0] = x1[0];
		x[1] = x1[1];
	}

	fclose(fp);

	return 0;
}
