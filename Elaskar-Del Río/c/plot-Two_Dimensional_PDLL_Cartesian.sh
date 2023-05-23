#!/usr/bin/gnuplot

set terminal pdfcairo size 16,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_PDLL_Cartesian.pdf"

set grid lw 2

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 2,2 rowsfirst

set ylabel 'p(l)'
set xlabel 'l'

p 'datafiles/Two_Dimensional_PDLL_Cartesian.dat' u 1:2 notitle w lp pt 7 ps 0.1 lc rgb 'black'

set ylabel 'CDP(l)'
set xlabel 'l'

p 'datafiles/Two_Dimensional_PDLL_Cartesian.dat' u 1:4 notitle w lp pt 7 ps 0.1 lc rgb 'black'

set ylabel 'ln(CDP(l))'
set xlabel 'l'

set logscale y

p 'datafiles/Two_Dimensional_PDLL_Cartesian.dat' u 1:4 notitle w lp pt 7 ps 0.1 lc rgb 'black'

unset multiplot