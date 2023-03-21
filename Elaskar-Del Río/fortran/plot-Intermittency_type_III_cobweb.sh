#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 600,600 font 'arial,21' persist

set terminal qt enhanced

set size 1,1

set grid lw 2
set title 'Cobweb plot'
set ylabel 'x_{n+1}'
set xlabel 'x_n'

set key font ',12'
set xtics font ',11'
set ytics font ',11'


set key top left

set autoscale

#set format x "%1.1t"
#set format y "10^{%L}"

p 'Intermittency_type_III_map_F_cobweb.dat' u 1:2 notitle w l lw 1.5 lc rgb 'black', \
  'Intermittency_type_III_map_F_cobweb.dat' u 1:1 notitle w l lw 1.5 lc rgb 'black', \
  'Intermittency_type_III_trajectory_cobweb.dat' u 1:2 notitle w l lw 1.2 lc rgb 'red'