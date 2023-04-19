#!/usr/bin/gnuplot

set terminal pdfcairo size 8,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Evolution_Iterations.pdf"

set grid lw 2

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set multiplot layout 2,1 rowsfirst

set ylabel 'x_n'
set xlabel 'n'

p 'datafiles/Two_Dimensional_Evolution.dat' every 1 u 0:(abs($1)) notitle w p pt 6 ps 0.05 lc rgb 'black'

set ylabel 'y_{n}'
set xlabel 'n'

set autoscale
p 'datafiles/Two_Dimensional_Evolution.dat' every 1 u 0:(abs($2)) notitle w p pt 6 ps 0.05 lc rgb 'black'

# set ylabel 'y_n'
# set xlabel 'n'

# p 'datafiles/Two_Dimensional_Evolution.dat' every 10 u ($0*10):2 notitle w p pt 5 ps 0.25

# set ylabel 'y_{n+1}'
# set xlabel 'n'

# p 'datafiles/Two_Dimensional_Evolution.dat' every 10 u ($0*10):4 notitle w p pt 5 ps 0.25


unset multiplot
unset output
unset terminal

# set terminal pdfcairo size 8,8 font 'Arial, 21'

# set output "plots/plot_Two_Dimensional_Evolution_Bidimensional.pdf"

# set grid lw 2

# set key font ',12'
# set ytics font ',12'
# set xtics font ',12'
# set autoscale

# set xtics 0,0.2,1
# set xrange[0:1]

# set multiplot layout 2,2 rowsfirst

# set ylabel 'x_{n+1}'
# set xlabel 'x_n'

# p 'datafiles/Two_Dimensional_Evolution.dat' every 1 u 1:3 notitle w p pt 5 ps 0.25

# set ylabel 'y_{n+1}'
# set xlabel 'y_n'

# p 'datafiles/Two_Dimensional_Evolution.dat' every 1 u 2:4 notitle w p pt 5 ps 0.25

# set ylabel 'y_n'
# set xlabel 'x_n'

# p 'datafiles/Two_Dimensional_Evolution.dat' every 1 u 1:2 notitle w p pt 5 ps 0.25

# set ylabel 'y_{n+1}'
# set xlabel 'x_{n+1}'

# p 'datafiles/Two_Dimensional_Evolution.dat' every 1 u 3:4 notitle w p pt 5 ps 0.25

# unset multiplot