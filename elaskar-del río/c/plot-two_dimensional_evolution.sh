#!/usr/bin/gnuplot

set terminal pdfcairo size 8,5 font 'Arial, 21'

set output "plots/plot_two_dimensional_evolution_2.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'


set multiplot layout 2,1 rowsfirst

set ylabel 'x_n'
set xlabel 'n'

set yrange[0.7:1]

p 'datafiles/two_dimensional_evolution_0.674103.dat' every 3 u 1:2 notitle w p pt 6 ps 0.1 lc rgb 'black'

set ylabel 'x_n'
set xlabel 'n'

set yrange[0.7:1]

p 'datafiles/two_dimensional_evolution_0.7786251.dat' every 3 u 1:2 notitle w p pt 6 ps 0.1 lc rgb 'black'

unset multiplot