#!/usr/bin/gnuplot

set terminal pdfcairo size 12,6 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_laminar_length.pdf"

set grid lw 2

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set ylabel 'ln<l>'
set xlabel 'ln({/Symbol a}_c - {/Symbol a})'

p 'datafiles/Two_Dimensional_laminar_length.dat' u 1:2 notitle w lp pt 6 ps 0.001 lw 1 lc rgb 'black'

unset output
unset terminal
