#!/usr/bin/gnuplot

set terminal pdfcairo size 12,12 font 'Arial, 21'

set output "plots/plot_two_dimensional_tests_x.pdf"

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 2,2 rowsfirst

set ylabel 'y'
set xlabel 'x'

p 'datafiles/two_dimensional_evolution_1.dat' u 2:3 notitle w p pt 6 ps 1 lc rgb 'red'

set ylabel 'x'
set xlabel 'n'

p 'datafiles/two_dimensional_evolution_1.dat' u 1:2 notitle w p pt 6 ps 0.15 lc rgb 'black'

set ylabel 'xerr'
set xlabel 'n'

set logscale y

p 'datafiles/two_dimensional_error_evol_1.dat' u 1:2 notitle w lp pt 6 ps 0.15 lc rgb 'black', \
1e-4 w l lw 1.5 lc rgb 'red'

unset logscale

set ylabel 'xn1'
set xlabel 'xn'

p 'datafiles/two_dimensional_evolution_1.dat' u 2:4 notitle w p pt 6 ps 1 lc rgb 'red'

unset multiplot