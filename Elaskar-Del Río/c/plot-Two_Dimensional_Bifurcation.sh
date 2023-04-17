#!/usr/bin/gnuplot

set terminal pdfcairo size 8,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Bifurcation.pdf"

set grid lw 2

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale


set multiplot layout 2,1 rowsfirst

set ylabel 'x_n'
set xlabel '{/Symbol a}'


p 'datafiles/Two_Dimensional_Bifurcation.dat' every 50 u 1:2 notitle w p pt 7 ps 0.001

set ylabel 'y_{n}'
set xlabel 'n'

set autoscale
p 'datafiles/Two_Dimensional_Bifurcation.dat' every 50 u 1:3 notitle w p pt 7 ps 0.001

unset multiplot
unset output
unset terminal
