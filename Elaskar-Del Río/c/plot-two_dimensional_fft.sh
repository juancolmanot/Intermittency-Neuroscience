#!/usr/bin/gnuplot

set terminal pdfcairo size 12,12 font 'Arial, 21'

set output "plots/plot_two_dimensional_fft.pdf"

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 1,2 rowsfirst

set ylabel 'x'
set xlabel 'n'

p 'datafiles/two_dimensional_fft_x.dat' u 1:2 notitle w l lc rgb 'black'

set ylabel 'Amplitude (A)'
set xlabel 'frequency (f)'

# set yrange[0:0.03]
# set xrange[0:0.2]

set logscale x

p 'datafiles/two_dimensional_fft_x.dat' u 3:4 notitle w l lc rgb 'black'

unset multiplot