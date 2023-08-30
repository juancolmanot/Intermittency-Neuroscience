#!/usr/bin/gnuplot

set terminal pdfcairo size 12,6 font 'Arial, 21'

set output "../plots/plot_lorenz_x_f.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'


set multiplot layout 2,3 rowsfirst

set ylabel 'x'
set xlabel 't'

p '../datafiles/coordinates_lorenz.dat' every 2 u 1:2 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'y'
set xlabel 't'

p '../datafiles/coordinates_lorenz.dat' every 2 u 1:3 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'z'
set xlabel 't'

p '../datafiles/coordinates_lorenz.dat' every 2 u 1:4 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'dx/dt'
set xlabel 't'

p '../datafiles/derivatives_lorenz.dat' every 2 u 1:2 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'dy/dt'
set xlabel 't'

p '../datafiles/derivatives_lorenz.dat' every 2 u 1:3 notitle w l lw 0.1 lc rgb 'black'

set ylabel 'dz/dt'
set xlabel 't'

p '../datafiles/derivatives_lorenz.dat' every 2 u 1:4 notitle w l lw 0.1 lc rgb 'black'

unset multiplot
unset output
unset terminal

set terminal pdfcairo size 10,4 font 'Arial, 21'

set output "../plots/plot_lorenz_rx_rf.pdf"

set key font ',12'
set ytics font ',12'
set xtics font ',12'


set multiplot layout 1,2 rowsfirst

set ylabel 'sqrt(x^2 + y^2 + z^2)'
set xlabel 't'

p '../datafiles/coordinates_lorenz.dat' every 2 u 1:(sqrt($2*$2 + $3*$3 + $4*$4)) notitle w l lw 0.1 lc rgb 'black'

set ylabel "sqrt(x'^2 + y'^2 + z'^2)"
set xlabel 't'

p '../datafiles/derivatives_lorenz.dat' every 2 u 1:(sqrt($2*$2 + $3*$3 + $4*$4)) notitle w l lw 0.1 lc rgb 'black'

unset multiplot