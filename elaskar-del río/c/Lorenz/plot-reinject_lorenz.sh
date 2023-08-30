#!/usr/bin/gnuplot

set terminal pdfcairo size 8,4 font 'Arial, 21'

set output "../plots/plot_reinject_lorenz.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'

set ylabel 'y(i)'
set xlabel 'y(i-1)'

p '../datafiles/reinject_lorenz.dat' u 2:1 notitle w p pt 7 ps 0.1 lc rgb 'red'
