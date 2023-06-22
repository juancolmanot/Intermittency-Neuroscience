#!/usr/bin/gnuplot

set terminal pdfcairo size 12,12 font 'Arial, 21'

set output "plots/plot_two_dimensional_f_g.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set key top left

set multiplot layout 2,2 rowsfirst

set ylabel 'f(x, y)'
set xlabel 'x'

p 'datafiles/two_dimensional_f_g.dat' u 1:3 notitle w p pt 7 ps 0.1 lc rgb 'blue', \
x lw 1 lc rgb 'red'

set ylabel 'g(x, y) terms'
set xlabel 'y'

p 'datafiles/two_dimensional_f_g.dat' u 2:4 notitle w p pt 7 ps 0.1 lc rgb 'blue', \
x lw 1 lc rgb 'red'

set ylabel 'f(x, y) terms'
set xlabel 'y'

p 'datafiles/two_dimensional_f_g.dat' u 2:3 notitle w p pt 7 ps 0.1 lc rgb 'blue', \
x lw 1 lc rgb 'red'

set ylabel 'g(x, y) terms'
set xlabel 'x'

p 'datafiles/two_dimensional_f_g.dat' u 1:4 notitle w p pt 7 ps 0.1 lc rgb 'blue', \
x lw 1 lc rgb 'red'

unset multiplot