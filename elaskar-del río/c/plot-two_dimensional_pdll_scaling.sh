#!/usr/bin/gnuplot

set terminal pdfcairo size 16,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_PDLL_Scaling.pdf"

set grid lw 2

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 1,2 rowsfirst

set ylabel '<l>'
set xlabel 'eps'

p 'datafiles/Two_Dimensional_PDLL_Scaling_x.dat' u (-$3):2 notitle w lp, \
  (7e2/x) w l

set ylabel '<l>'
set xlabel 'l'

p 'datafiles/Two_Dimensional_PDLL_Scaling_x.dat' u (-$3):(log($2)) notitle w lp, \
  (1/x) w l

unset multiplot