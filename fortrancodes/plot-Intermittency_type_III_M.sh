#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 600,600 font 'arial,21' persist

set terminal qt enhanced

set size 1,1

set grid lw 2
set title 'M(x) function'
set ylabel 'x_{reinjected}'
set xlabel 'M(x)'

set key font ',12'
set xtics font ',11'
set ytics font ',11'


set key top left

set autoscale

# M1(x) = m1*x + ai1*(1 - m1)
# M2(x) = m2*x + ai2*(1 - m2)

#set xrange[0.0:0.65]
#set xrange[0.0:0.3]

# fit M1(x) 'Intermittency_type_III_M_avg_case1.dat' u 1:2 via ai1,m1
# fit M2(x) 'Intermittency_type_III_M_avg_case2.dat' u 1:2 via ai2,m2

p 'Intermittency_type_III_M_case1.dat' u ($0/10):1 w l lw 1.5 lc rgb 'red', \
  'Intermittency_type_III_M_avg_case1.dat' u 0:1 w p pt 5 ps 0.25 lc rgb 'blue', \

# p 'Intermittency_type_III_M_case1.dat' u 1:2 title 'tot 1' w l lw 1.5 lc rgb 'black', \
#   'Intermittency_type_III_M_case2.dat' u 1:2 title 'tot 2' w l lw 1.5 lc rgb 'black', \
#   'Intermittency_type_III_M_avg_case1.dat' u 1:2 title 'avg 1' w l lw 1.5 lc rgb 'black', \
#   'Intermittency_type_III_M_avg_case2.dat' u 1:2 title 'avg 2' w l lw 1.5 lc rgb 'black'
#   [x=0.0:0.65] M1(x) t 'fit 1' w p pt 5 ps 0.5 lc rgb 'red', \
#   [x=0:0.65] M2(x) t 'fit 2' w p pt 5 ps 0.5 lc rgb 'blue'
  