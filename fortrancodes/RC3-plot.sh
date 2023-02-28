#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 800,800 font 'arial,21' persist

set terminal qt enhanced

#set output 'g5p1a2-dE.png'

set size square

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

p 'RulkovChaos3_A.dat' every 1::0::499 u 1:2 title 'x_{01}' w l lw 2 lc rgb 'blue'
