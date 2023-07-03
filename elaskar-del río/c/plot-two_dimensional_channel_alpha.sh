#!/usr/bin/gnuplot

set terminal pdfcairo size 9,4 font 'Arial, 21'

set output "plots/plot_two_dimensional_channel_alpha.pdf"

set multiplot layout 1,2 rowsfirst

set logscale y

p 'datafiles/two_dimensional_channel_x_14_0.674149344_eps.dat' u (log($1)):2 notitle w p pt 6 ps 0.5

p 'datafiles/two_dimensional_channel_y_14_0.674149344_eps.dat' u (log($1)):2 notitle w p pt 6 ps 0.5

# set logscale y

# p 'datafiles/two_dimensional_dchannel_x_14_0.674149344_eps.dat' u 1:(abs($2)) notitle w p pt 6 ps 0.5

# p 'datafiles/two_dimensional_dchannel_y_14_0.674149344_eps.dat' u 1:(abs($2)) notitle w p pt 6 ps 0.5


unset multiplot
