#!/usr/bin/gnuplot

set terminal pdfcairo size 8,8 font 'Arial, 21'

set output "../plots/plot_reinject_lorenz_regions.pdf"

set xlabel font ', 21'
set ylabel font ', 21'

set key font ',12'
set ytics font ',12'
set xtics font ',12'

set ylabel 'y(i)'
set xlabel 'y(i-1)'

p '../datafiles/reinject_region1.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'red'

p '../datafiles/reinject_region2.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'red'

p '../datafiles/reinject_region3.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'red'

p '../datafiles/reinject_region4.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'red'

p '../datafiles/reinject_region5.dat' u 1:2 notitle w p pt 7 ps 0.1 lc rgb 'red'

