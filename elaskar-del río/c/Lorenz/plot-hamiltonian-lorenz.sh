#!/usr/bin/gnuplot

set terminal pdfcairo size 8,6 font 'Arial, 21'

set output "../plots/plot_lorenz_hamiltonian.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'


set multiplot layout 2,2 rowsfirst

set ylabel 'U'
set xlabel 't'

p '../datafiles/hamilton_lorenz.dat' every 2 u 1:2 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'K'
set xlabel 't'

p '../datafiles/hamilton_lorenz.dat' every 2 u 1:3 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'H'
set xlabel 't'

p '../datafiles/hamilton_lorenz.dat' every 2 u 1:4 notitle w l lw 0.1 lc rgb 'black'

unset multiplot