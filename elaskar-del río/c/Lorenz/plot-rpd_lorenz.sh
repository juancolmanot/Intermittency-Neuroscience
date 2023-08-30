#!/usr/bin/gnuplot

set terminal pdfcairo size 6,4 font 'Arial, 21'

set output "../plots/plot_rpd_lorenz.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'

set ylabel 'RPD(y)'
set xlabel 'y'

p '../datafiles/rpd_lorenz.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'red'
