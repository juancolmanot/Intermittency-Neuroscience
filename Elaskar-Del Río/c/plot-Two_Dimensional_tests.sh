#!/usr/bin/gnuplot

set terminal pdfcairo size 12,12 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_tests.pdf"

set grid lw 1

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set multiplot layout 2,2 rowsfirst

set ylabel 'x_n'
set xlabel '{/Symbol a}'

p 'datafiles/Two_Dimensional_tests.dat' every 25 u 1:2 notitle w p pt 6 ps 0.01 lc rgb 'black'

set ylabel 'y_n'
set xlabel '{/Symbol a}'

p 'datafiles/Two_Dimensional_tests.dat' every 25 u 1:3 notitle w p pt 6 ps 0.01 lc rgb 'black'

set ylabel 'x_{n+1}'
set xlabel '{/Symbol a}'

p 'datafiles/Two_Dimensional_tests.dat' every 25 u 1:4 notitle w p pt 6 ps 0.01 lc rgb 'black'

set ylabel 'y_{n+1}'
set xlabel '{/Symbol a}'

p 'datafiles/Two_Dimensional_tests.dat' every 25 u 1:5 notitle w p pt 6 ps 0.01 lc rgb 'black'

