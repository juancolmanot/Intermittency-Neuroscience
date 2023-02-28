#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 1000,800 font 'arial,21' persist

set terminal qt enhanced

#set grid lw 2
#set title ''
set ylabel 'v'
#set xlabel 't'

set key font ',12'
set xtics font ',11'
set ytics font ',11'


set key top left

set autoscale

#set logscale

#set format x "%1.1t"
#set format y "10^{%L}"

#unset bmargin
unset lmargin
#unset tmargin
unset rmargin

set multiplot layout 2,1

set size 1,0.6
set origin 0,0.4
set lmargin at screen 0.1
#set tmargin at screen 0.95
set rmargin at screen 0.9

p 'Izhikevich_1.dat' u 1:3 notitle w l lw 1.5 lc rgb 'black'

set size 1,0.4
set origin 0,0
set lmargin at screen 0.1
#set bmargin at screen 0.1
set rmargin at screen 0.9

set ylabel 'u'
set xlabel 't'

p 'Izhikevich_1.dat' u 1:2 notitle w l lw 1.5 lc rgb 'black'

unset multiplot