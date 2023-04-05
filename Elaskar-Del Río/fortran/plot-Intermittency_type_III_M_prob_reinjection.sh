#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo enhanced color notransparent

set output 'plots/plot_Intermittency_type_III_M_prob_reinjection.pdf'

set size 1,1

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

p 'datafiles/Intermittency_type_III_M_reinj_prob1.dat' every 10::0::14999 u 2:5 title 'M1(x)' w lp pt 5 ps 0.25 lw 0.75 lc rgb 'black', \
  'datafiles/Intermittency_type_III_M_reinj_prob2.dat' every 10::0::14999 u 2:5 title 'M2(x)' w lp pt 9 ps 0.4 lw 0.75 lc rgb 'black', \

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

p 'datafiles/Intermittency_type_III_M_reinj_prob1.dat' every 10::0::14999 u 2:3 title 'x1_{avg}' w lp pt 5 ps 0.25 lw 0.75 lc rgb 'black', \
  'datafiles/Intermittency_type_III_M_reinj_prob2.dat' every 10::0::14999 u 2:3 title 'x2_{avg}' w lp pt 9 ps 0.4 lw 0.75 lc rgb 'black', \

set grid lw 2
set ylabel '{/Symbol F}(x)'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top right

set autoscale

p 'datafiles/Intermittency_type_III_M_reinj_prob1.dat' u 2:4 title '{/Symbol F}_1(x)' w lp pt 5 ps 0.25 lw 0.75 lc rgb 'black', \
  'datafiles/Intermittency_type_III_M_reinj_prob2.dat' u 2:4 title '{/Symbol F}_2(x)' w lp pt 9 ps 0.4 lw 0.75 lc rgb 'black', \

set grid lw 2
set ylabel 'N_{points}'
set xlabel 'x'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

#set ytics format "10^{%L}"

set key top right

set autoscale

p 'datafiles/Intermittency_type_III_M_reinj_prob1.dat' u 2:1 title 'N1' w lp pt 5 ps 0.25 lw 0.75 lc rgb 'black', \
  'datafiles/Intermittency_type_III_M_reinj_prob2.dat' u 2:1 title 'N2' w lp pt 9 ps 0.4 lw 0.75 lc rgb 'black', \

unset multiplot

unset output
unset terminal