#!/usr/bin/gnuplot

set terminal pdfcairo size 12,6 font 'Arial, 21'

set output "plots/plot_two_dimensional_map_f_g.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set multiplot layout 1,2 rowsfirst

set ylabel 'F(x_n, y_n)'
set xlabel 'x_n'
set autoscale

p 'datafiles/two_dimensional_map_f_g.dat' u 1:3 notitle w p pt 6 ps 0.001 lc rgb 'black', \
    x notitle w l lw 1 lc rgb 'red'

set ylabel 'G(x_n, y_n)'
set xlabel 'y_n'

set autoscale

p 'datafiles/two_dimensional_map_f_g.dat' u 2:4 notitle w p pt 6 ps 0.001 lc rgb 'black', \
    x notitle w l lw 1 lc rgb 'red'

unset multiplot
unset output
unset terminal