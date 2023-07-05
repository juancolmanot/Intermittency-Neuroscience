#!/usr/bin/gnuplot

set terminal pdfcairo size 15,9 font 'Arial, 21'

set output "plots/plot_two_dimensional_distance.pdf"

# set logscale y

set multiplot layout 2,2 rowsfirst

set ylabel 'distance x'
set xlabel 'n'

p 'datafiles/two_dimensional_distance.dat' every 200 u 1:2 notitle w p pt 6 ps 0.1 lc rgb 'blue', \
5e-4 notitle w l lw 1 lc rgb 'red'

set ylabel 'distance y'
set xlabel 'n'

p 'datafiles/two_dimensional_distance.dat' every 200 u 1:3 notitle w p pt 6 ps 0.1 lc rgb 'blue', \
5e-4 notitle w l lw 1 lc rgb 'red'

set ylabel 'x'
set xlabel 'n'

p 'datafiles/two_dimensional_distance.dat' every 200 u 1:4 notitle w p pt 6 ps 0.1 lc rgb 'blue'

set ylabel 'y'
set xlabel 'n'

p 'datafiles/two_dimensional_distance.dat' every 200 u 1:5 notitle w p pt 6 ps 0.1 lc rgb 'blue'

unset multiplot
