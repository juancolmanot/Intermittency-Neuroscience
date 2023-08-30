#!/usr/bin/gnuplot

set terminal pdfcairo size 12,8 font 'Arial, 21'

set output "../plots/plot_evol_poincare.pdf"

set ylabel font '18'
set xlabel font '18'

set key font ',12'
set ytics font ',12'
set xtics font ',12'


set multiplot layout 2,2 rowsfirst

set ylabel 'x'
set xlabel 't'

p '../datafiles/evolution_lorenz.dat' every 100 u 1:2 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'y'
set xlabel 't'

p '../datafiles/evolution_lorenz.dat' every 100 u 1:3 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'z'
set xlabel 't'

p '../datafiles/evolution_lorenz.dat' every 100 u 1:4 notitle w l lw 0.1 lc rgb 'black'

# set ticslevel 0
# set xlabel 'x'
# set ylabel 'y'
# set zlabel 'z'

# set view 60, 45

# splot '../datafiles/evolution_lorenz.dat' every 100 u 2:3:4 notitle w l lw 1 lc rgb 'black'

unset multiplot