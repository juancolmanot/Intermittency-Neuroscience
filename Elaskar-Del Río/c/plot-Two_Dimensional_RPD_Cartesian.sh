#!/usr/bin/gnuplot

set terminal pdfcairo size 16,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_RPD_Cartesian.pdf"

set grid lw 2

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 1,2 rowsfirst

set ylabel 'RPD[r(x, y)]'
set xlabel 'r(x, y)'

p 'datafiles/Two_Dimensional_RPD_Cartesian.dat' u 1:2 notitle w lp pt 5 ps 0.1 lc rgb 'black'

set ylabel 'r reinjected'
set xlabel 'iteration'

p 'datafiles/Two_Dimensional_RPD_Cartesian_reinjected.dat' u 1:2 notitle w p pt 5 ps 0.1 lc rgb 'black'