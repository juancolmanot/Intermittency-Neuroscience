#!/usr/bin/gnuplot

set terminal pdfcairo size 15,9 font 'Arial, 21'

set output "plots/plot_two_dimensional_laminar_distance.pdf"

set multiplot layout 2,3 rowsfirst

set ylabel 'RPD(x)'
set xlabel 'x'

p 'datafiles/two_dimensional_rpd_x.dat' u 1:2 notitle w lp pt 6 ps 0.5

set ylabel 'l(x_{in})'
set xlabel 'x'

p 'datafiles/two_dimensional_rpd_x.dat' u 1:3 notitle w lp pt 6 ps 0.5

set ylabel 'EPD(x)'
set xlabel 'x'

p 'datafiles/two_dimensional_epd_x.dat' u 1:2 notitle w lp pt 6 ps 0.5

set ylabel 'p(l)'
set xlabel 'l'

p 'datafiles/two_dimensional_laminar_stats.dat' u 1:2 notitle w lp pt 6 ps 0.5

set ylabel '<l>'
set xlabel 'l'

p 'datafiles/two_dimensional_laminar_stats.dat' u 1:3 notitle w lp pt 6 ps 0.5

unset multiplot
