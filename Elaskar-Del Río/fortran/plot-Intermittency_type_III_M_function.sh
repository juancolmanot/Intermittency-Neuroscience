#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo size 6,6 font 'arial,21'

set output "plots/plot_Intermittency_type_III_M_function.pdf"

set grid lw 2

set key font ',12'
set xtics font ',11'
set ytics font ',11'


set key top left

set autoscale

set multiplot layout 2,1 rowsfirst
set ylabel font ',16'
set xlabel font ',16'
set ylabel 'M(x) - M(x)_{avg}'
set xlabel 'x'

p 'datafiles/Intermittency_type_III_M_case1.dat' u 1:2 t 'M(x)' w p pt 5 ps 0.2 lc rgb 'red', \
  'datafiles/Intermittency_type_III_M_avg_case1.dat' u 1:2 t 'Mavg(x)' w p pt 5 ps 0.2 lw 1 lc rgb 'blue', \

set logscale y

set key top right
set ylabel font ',16'
set xlabel font ',16'
set ylabel 'Rel. Error (M(x), M(x)_{avg})'
set xlabel 'x'

p 'datafiles/testdif.dat' every 1::199*0::199*1 u 1:(abs($2)) t 'x**0.5' w l lw 2, \
  'datafiles/testdif.dat' every 1::199*1::199*2 u 1:(abs($2)) t 'x**1' w l lw 2, \
  'datafiles/testdif.dat' every 1::199*2::199*3 u 1:(abs($2)) t 'x**1.5' w l lw 2, \
  'datafiles/testdif.dat' every 1::199*3::199*4 u 1:(abs($2)) t 'x**2' w l lw 2

unset multiplot