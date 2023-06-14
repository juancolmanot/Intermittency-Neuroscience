#!/usr/bin/gnuplot

set terminal pdfcairo size 8,7 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Scalation_l.pdf"

set grid lw 2

set key font ',19'
set ytics font ',14'
set xtics font ',14'

set ylabel 'ln<l>'
set xlabel 'ln({/Symbol a}_c - {/Symbol a})'

p 'datafiles/Two_Dimensional_Scalation_l.dat' u 1:2 w p pt 5 ps 0.5 lc rgb 'black'
