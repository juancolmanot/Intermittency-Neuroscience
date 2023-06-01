#!/usr/bin/gnuplot

set terminal pdfcairo size 12,12 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Evolution_x.pdf"

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 2,2 rowsfirst

set ylabel 'x'
set xlabel 'n'

p 'datafiles/Two_Dimensional_Evolution_x.dat' every 1 u 1:2 notitle w p pt 7 ps 0.15 lc rgb 'black'

set ylabel 'y'
set xlabel 'n'

p 'datafiles/Two_Dimensional_Evolution_x.dat' every 1 u 1:3 notitle w p pt 7 ps 0.15 lc rgb 'black'

set ylabel 'y'
set xlabel 'x'

p 'datafiles/Two_Dimensional_Evolution_x.dat' every 1 u 2:3 notitle w p pt 7 ps 0.15 lc rgb 'black'

unset multiplot