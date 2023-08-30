#!/usr/bin/gnuplot

set terminal pdfcairo size 8,6 font 'Arial, 21'

set output "../plots/plot_poincare_section_lorenz.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'

set multiplot layout 2,1 rowsfirst

set ylabel 'y_{fit}'
set xlabel 'iteration'

p '../datafiles/poincare_section_lorenz.dat' u 1:3 notitle w lp pt 7 ps 0.1 lc rgb 'red'

set ylabel 'z_{fit}'
set xlabel 'iteration'

p '../datafiles/poincare_section_lorenz.dat' u 1:4 notitle w lp pt 7 ps 0.1 lc rgb 'red'
