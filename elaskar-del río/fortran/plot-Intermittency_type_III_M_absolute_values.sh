#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo size 6,8 font 'arial,21'

set output "plots/plot_Intermittency_type_III_M_absolute_values.pdf"

set grid lw 2

set multiplot layout 2,1 rowsfirst

# Plot 1
set ylabel 'M(|x|)'
set xlabel '|x|'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_M_sum_abs.dat' u 1:2 notitle w l lw 1.5 lc rgb 'black'

# Plot 2
set ylabel '{/Symbol F}{(x)}'
set xlabel 'x'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_M_prob_abs.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'black'


unset multiplot