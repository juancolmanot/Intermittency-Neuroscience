#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo size 8,6 font 'arial,21'

set output 'plots/plot_Intermittency_type_III_laminar_test.pdf'

set grid lw 2
set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set multiplot layout 2,2 rowsfirst

set ylabel '{/Symbol y}(l)'
set xlabel 'l'

set key top left

set autoscale

set xrange[0:50]

p 'datafiles/Intermittency_type_III_laminar_test_2.dat' u 1:2 notitle w lp pt 3 ps 0.5 lc 'black'
set autoscale

set ylabel 'l_{avg}'
set xlabel 'l'

set key top left

p 'datafiles/Intermittency_type_III_laminar_test_2.dat' u 1:3 notitle w l lw 1 lc rgb 'black'

set autoscale

set ylabel 'l_{med1}'
set xlabel 'l'

set key top left

p 'datafiles/Intermittency_type_III_laminar_test_3.dat' u 1:2 notitle w l lw 1 lc rgb 'black'

set autoscale

set ylabel 'l_{med}'
set xlabel 'x'

set key top left

p 'datafiles/Intermittency_type_III_laminar_test_4.dat' u 1:2 notitle w l lw 1 lc rgb 'black'

unset terminal