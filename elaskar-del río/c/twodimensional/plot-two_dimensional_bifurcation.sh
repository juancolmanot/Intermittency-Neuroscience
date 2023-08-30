#!/usr/bin/gnuplot

set terminal pdfcairo size 8,4 font 'Arial, 21'

set output "plots/plot_two_dimensional_bifurcation.pdf"


set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set ylabel 'x_n'
set xlabel '{/Symbol a}'


p 'datafiles/two_dimensional_bifurcation.dat' every 10 u 1:2 notitle w p pt 6 ps 0.001 lc rgb 'black'


unset multiplot
unset output
unset terminal
