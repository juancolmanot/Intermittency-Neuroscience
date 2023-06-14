#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo size 8,6 font 'arial,21'

set output "plots/plot_Intermittency_type_III_M_prob.pdf"

set multiplot layout 2,2 rowsfirst

set grid lw 2
set ylabel 'M(x)'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'Intermittency_type_III_M_prob1.dat' u 2:5 title 'M1(x)' w l lw 1.5 lc rgb 'red', \
  'Intermittency_type_III_M_prob2.dat' u 2:5 title 'M2(x)' w l lw 1.5 lc rgb 'blue', \

set grid lw 2
set ylabel 'x_{avg}'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'Intermittency_type_III_M_prob1.dat' u 2:3 title 'x1_{avg}' w l lw 1.5 lc rgb 'red', \
  'Intermittency_type_III_M_prob2.dat' u 2:3 title 'x2_{avg}' w l lw 1.5 lc rgb 'blue', \

set grid lw 2
set ylabel '{/Symbol p}(x)'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'Intermittency_type_III_M_prob1.dat' u 2:4 title '{/Symbol p}_1(x)' w l lw 1.5 lc rgb 'red', \
  'Intermittency_type_III_M_prob2.dat' u 2:4 title '{/Symbol p}_2(x)' w l lw 1.5 lc rgb 'blue', \

set grid lw 2
set ylabel 'N_{points}'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set ytics format "10^{%L}"

set key top left

set autoscale

p 'Intermittency_type_III_M_prob1.dat' u 2:1 title 'N1' w l lw 1.5 lc rgb 'red', \
  'Intermittency_type_III_M_prob2.dat' u 2:1 title 'N2' w l lw 1.5 lc rgb 'blue', \

unset multiplot