#!/usr/bin/gnuplot

set terminal pdfcairo size 8,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Evolution_Cartesian.pdf"

set grid lw 2

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 2,2 rowsfirst

set ylabel 'r(x, y)'
set xlabel 'n'

set yrange[0:1]

p 'datafiles/Two_Dimensional_Evolution_Cartesian.dat' u 0:3 notitle w p pt 5 ps 0.1 lc rgb 'black'

set ylabel 'x'
set xlabel 'n'

set yrange[0:1]

p 'datafiles/Two_Dimensional_Evolution_Cartesian.dat' u 0:1 notitle w p pt 5 ps 0.1 lc rgb 'black'

set ylabel 'y'
set xlabel 'n'

set yrange[0:1]

p 'datafiles/Two_Dimensional_Evolution_Cartesian.dat' u 0:2 notitle w p pt 5 ps 0.1 lc rgb 'black'

set ylabel 'y'
set xlabel 'x'

set xrange[0:1]
set yrange[0:1]

p 'datafiles/Two_Dimensional_Evolution_Cartesian.dat' u 1:2 notitle w p pt 5 ps 0.1 lc rgb 'black'


unset multiplot
