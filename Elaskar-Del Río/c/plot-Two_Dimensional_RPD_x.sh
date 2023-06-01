#!/usr/bin/gnuplot

set terminal pdfcairo size 12,6 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_RPD_x.pdf"

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 1,2 rowsfirst

set ylabel 'p(x)'
set xlabel 'n'

p 'datafiles/Two_Dimensional_RPD_x.dat' every 1 u 1:3 notitle w l lc rgb 'black'

set ylabel '<x>'
set xlabel 'n'

p 'datafiles/Two_Dimensional_RPD_x.dat' every 1 u 1:4 notitle w l lc rgb 'black'

unset multiplot