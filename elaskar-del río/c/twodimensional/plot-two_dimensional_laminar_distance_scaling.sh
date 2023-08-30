#!/usr/bin/gnuplot

set terminal pdfcairo size 9,9 font 'Arial, 21'

set output "plots/plot_two_dimensional_eps_lavg.pdf"

set multiplot layout 1, 1 rowsfirst

set ylabel '<l>'
set xlabel 'eps'

p 'datafiles/two_dimensional_eps_lavg.dat' u (log($1)):(log($2)) notitle w lp pt 6 ps 0.5

unset multiplot
