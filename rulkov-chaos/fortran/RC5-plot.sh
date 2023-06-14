#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 1200,400 font 'arial,21' persist

set terminal qt enhanced

#set output 'g5p1a2-dE.png'

set size 600,400

set grid lw 2
#set title ''
set ylabel 'y'
set xlabel 'x'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

#set logscale

#set format x "10^{%L}"
#set format y "10^{%L}"

set multiplot layout 1,2

p 'RulkovChaos5_A.dat' every 1::47000*1::46999*2 u 2:3 title '{/Symbol e}=0.0005' w l lw 1 lc rgb 'blue',\
  'RulkovChaos5_A.dat' every 1::47000*0::46999*1 u 2:3 title '{/Symbol e}=0.0008' w l lw 1 lc rgb 'red'


#set size 600,400

set key top right

set ylabel 'x'
set xlabel 'iteration [n]'

set format x "%1.0te{%L}"

p 'RulkovChaos5_A.dat' every 1::47000*1::46999*2 u 1:2 title '{/Symbol e}=0.0005' w l lw 1 lc rgb 'blue',\
  'RulkovChaos5_A.dat' every 1::47000*0::46999*1 u 1:2 title '{/Symbol e}=0.0008' w l lw 1 lc rgb 'red'

unset multiplot