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

p 'RulkovChaos4_A.dat' every 1::5000*0::4999*1 u 1:2 title '{/Symbol a}=1.994' w l lw 2 lc rgb 'blue',\
  'RulkovChaos4_A.dat' every 1::5000*1::4999*2 u 1:2 title '{/Symbol a}=1.995' w l lw 2 lc rgb 'green',\
  'RulkovChaos4_A.dat' every 1::5000*2::4999*3 u 1:2 title '{/Symbol a}=1.99527' w l lw 2 lc rgb 'red',\
  'RulkovChaos4_A.dat' every 1::5000*3::4999*4 u 1:2 title '{/Symbol a}=1.99528' w l lw 2 lc rgb 'black',\
  'RulkovChaos4_A.dat' every 1::5000*4::4999*5 u 1:2 title '{/Symbol a}=1.996' w l lw 2 lc rgb 'cyan'

