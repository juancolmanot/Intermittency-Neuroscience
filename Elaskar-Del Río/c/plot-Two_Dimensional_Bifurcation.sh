#!/usr/bin/gnuplot

set terminal pdfcairo size 12,6 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Bifurcation.pdf"

set grid lw 2

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set xrange[0.6:0.85]
set yrange[0:1]

set multiplot layout 1,2 rowsfirst

set ylabel 'x_n'
set xlabel '{/Symbol a}'


p 'datafiles/Two_Dimensional_Bifurcation.dat' every 50 u 1:2 notitle w p pt 6 ps 0.001 lc rgb 'black'

set ylabel 'y_{n}'
set xlabel 'n'

set autoscale

set xrange[0.6:0.85]
set yrange[0:1]

p 'datafiles/Two_Dimensional_Bifurcation.dat' every 50 u 1:3 notitle w p pt 6 ps 0.001 lc rgb 'black'

unset multiplot
unset output
unset terminal
