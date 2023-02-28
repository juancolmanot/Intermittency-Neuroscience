#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 800,400 font 'arial,21' persist

set terminal qt enhanced

#set output 'g5p1a2-dE.png'

set size 1,1

#set grid lw 2
#set title ''
set ylabel 'x-coordinate'
set xlabel '{/Symbol e}  (x10^{-4})'

set key font ',12'
set xtics font ',11'
set ytics font ',11'


set key top left

set autoscale

#set logscale

set format x "%1.1t"
#set format y "10^{%L}"

set xtics 0,0.0004,0.001


p 'RulkovChaos6_A.dat' u 1:2 notitle w p pt 7 ps 0.2 lc rgb 'blue'