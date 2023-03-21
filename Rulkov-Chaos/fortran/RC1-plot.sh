#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 800,800 font 'arial,21' persist

set terminal qt enhanced

#set output 'g5p1a2-dE.png'

set size square

set grid lw 2
#set title ''
set ylabel 'x_{n+1}'
set xlabel '{/Symbol a}'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

#set autoscale

#set logscale

#set format x "10^{%L}"
#set format y "10^{%L}"

set multiplot layout 2,2

p 'RulkovChaos1-Bifurcation.d' u 1:2 title 'x_{n+1}' w p pt 7 ps 0.1 lc rgb 'blue'

set size square
set key top right
set ylabel 'y_{n+1}'

p  'RulkovChaos1-Bifurcation.d' u 1:3 title 'y_{n+1}' w p pt 7 ps 0.1 lc rgb 'blue'

# set xrange [1.989:1.996]
# set yrange [-1.8:0]

set ylabel 'x_{n+1}'
set size square
set autoscale

p 'RulkovChaos1-Bifurcation_zoomed.d' u 1:2 title 'x_{n+1}' w p pt 7 ps 0.1 lc rgb 'blue'

# set xrange [1.989:1.996]
# set yrange [-1.8:0]

set ylabel 'y_{n+1}'
set size square
set autoscale
p  'RulkovChaos1-Bifurcation_zoomed.d' u 1:3 title 'y_{n+1}' w p pt 7 ps 0.1 lc rgb 'blue'

unset multiplot
