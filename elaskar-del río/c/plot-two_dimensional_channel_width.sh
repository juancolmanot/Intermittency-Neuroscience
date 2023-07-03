#!/usr/bin/gnuplot

set terminal pdfcairo size 12,9 font 'Arial, 21'

set output "plots/plot_two_dimensional_channel_width.pdf"

set multiplot layout 3,2 rowsfirst

set ylabel 'x1'
set xlabel 'x'

p 'datafiles/two_dimensional_evolution_14_0.674149_eps.dat' u 2:4 notitle w p pt 6 ps 0.1, \
x notitle w l lw 2 lc rgb 'red'

set ylabel 'y1'
set xlabel 'y'

p 'datafiles/two_dimensional_evolution_14_0.674149_eps.dat' u 3:5 notitle w p pt 6 ps 0.1, \
x notitle w l lw 2 lc rgb 'red'

set logscale y

set ylabel 'distance x'
set xlabel 'n'

p 'datafiles/two_dimensional_distance_to_line_14_0.674149_eps.dat' u 1:4 notitle w p pt 6 ps 0.1

set ylabel 'distance y'
set xlabel 'n'

p 'datafiles/two_dimensional_distance_to_line_14_0.674149_eps.dat' u 1:5 notitle w p pt 6 ps 0.1

set ylabel 'distance x'
set xlabel 'x'

p 'datafiles/two_dimensional_distance_to_line_14_0.674149_eps.dat' u 2:4 notitle w p pt 6 ps 0.1

set ylabel 'distance y'
set xlabel 'y'

p 'datafiles/two_dimensional_distance_to_line_14_0.674149_eps.dat' u 3:5 notitle w p pt 6 ps 0.1


unset multiplot
