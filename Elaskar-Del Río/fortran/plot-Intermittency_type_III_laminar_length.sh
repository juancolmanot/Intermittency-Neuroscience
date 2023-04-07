#!/usr/bin/gnuplot

# kind of output to generate
#set terminal qt size 1200,800 font 'arial,21'
 
#set terminal qt enhanced

set terminal pdfcairo enhanced color notransparent

set output 'plots/plot_Intermittency_type_III_laminar_length.pdf'

#set size 1,1

set multiplot layout 2,2 rowsfirst

set grid lw 2
set ylabel '{/Symbol y}_1(l)'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

#set logscale y

set autoscale

p 'datafiles/Intermittency_type_III_lam_length_1.dat' u 1:3 title '{/Symbol y}_1(l)' w l lw 1 lc rgb 'red'

unset logscale

set grid lw 2
set ylabel '{/Symbol y}_1(l_{mean})'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_avglam_length_1.dat' u 1:2 t '{/Symbol y}_1(l_{mean})' lw 1 lc rgb 'red'

set grid lw 2
set ylabel '{/Symbol y}_2(l)'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

#set logscale y

set autoscale

p 'datafiles/Intermittency_type_III_lam_length_2.dat' u 1:3 title '{/Symbol y}_2(l)' w l lw 1 lc rgb 'blue'

unset logscale

set grid lw 2
set ylabel '{/Symbol y}_2(l_{mean})'
set xlabel 'l'

set xlabel font ',9'
set ylabel font ',9'

set key font ',9'
set xtics font ',9'
set ytics font ',9'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_avglam_length_1.dat' u 1:2 t '{/Symbol y}_2(l_{mean})' lw 1 lc rgb 'blue'

unset multiplot

unset output
unset terminal