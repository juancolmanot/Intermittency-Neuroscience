#!/usr/bin/gnuplot

# kind of output to generate
set terminal pdfcairo size 8,6 font 'arial,21'

set output "plots/plot_Intermittency_type_III_M.pdf"

set grid lw 2

set multiplot layout 2,2 rowsfirst

# Plot 1
set ylabel 'M(x)'
set xlabel 'x'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_M_sum_case1.dat' u 1:2 t 'Ordered-Sum' w l lw 1.5 lc rgb 'red', \
  'datafiles/Intermittency_type_III_M_prob_case1.dat' u 1:3 t 'Definition' w l lw 1.5 lc rgb 'blue'

# Plot 2
set ylabel '{/Symbol F}{(x)} - case 1'
set xlabel 'x'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_M_prob_case1.dat' u 1:2 notitle w l lw 1.5 lc rgb 'red'

# Plot 3
set ylabel 'M(x)'
set xlabel 'x'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_M_sum_case2.dat' u 1:2 t 'Ordered-Sum' w l lw 1.5 lc rgb 'red', \
  'datafiles/Intermittency_type_III_M_prob_case2.dat' u 1:3 t 'Definition' w l lw 1.5 lc rgb 'blue'

# Plot 4
set ylabel '{/Symbol F}(x) - case 2'
set xlabel 'x'

set key font ',12'
set xtics font ',11'
set ytics font ',11'

set key top left

set autoscale

p 'datafiles/Intermittency_type_III_M_prob_case2.dat' u 1:2 notitle w l lw 1.5 lc rgb 'red'

unset multiplot