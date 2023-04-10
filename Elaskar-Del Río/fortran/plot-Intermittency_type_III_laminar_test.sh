#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo size 8,6 font 'arial,21'

set output 'plots/plot_Intermittency_type_III_laminar_test.pdf'

set grid lw 2

set multiplot layout 3,2 rowsfirst

set ylabel 'x_{reinjected}'
set xlabel 'iteration'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_laminar_test_1.dat' u 1:2 notitle w l lw 1 lc rgb 'black'

set ylabel '{/Symbol y}(l)'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_laminar_test_2.dat' u 1:2 notitle w l lw 1 lc rgb 'black'


set ylabel 'l_{avg}'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_laminar_test_2.dat' u 1:3 notitle w l lw 1 lc rgb 'black'


set ylabel 'l_{med1}'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_laminar_test_3.dat' u 1:2 notitle w l lw 1 lc rgb 'black'


set ylabel 'l_{med}'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_laminar_test_4.dat' u 1:2 notitle w l lw 1 lc rgb 'black'

unset terminal