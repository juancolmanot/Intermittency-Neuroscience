#!/usr/bin/gnuplot

set terminal pdfcairo size 6,6 font 'Arial, 21'

set output "plots/plot_two_dimensional_cobweb.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set ylabel 'F(x_n, y_n)'
set xlabel 'x_n'
set autoscale

p 'datafiles/two_dimensional_map_f_g.dat' u 1:3 notitle w l lw 1 lc rgb 'black', \
  'datafiles/two_dimensional_cobweb.dat' u 1:2 notitle w p pt 4 ps 1 lc rgb 'blue', \
  x notitle w l lw 1 lc rgb 'red'

unset output
unset terminal