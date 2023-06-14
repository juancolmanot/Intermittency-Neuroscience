#!/usr/bin/gnuplot

set terminal pdfcairo size 16,8 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_PDLL_Cartesian_Scaling.pdf"

set grid lw 2

set key font ',14'
set ytics font ',14'
set xtics font ',14'

set multiplot layout 1,2 rowsfirst

set ylabel '<l>'
set xlabel '{/Symbol a}_c - {/Symbol a}'

p 'datafiles/Two_Dimensional_PDLL_Cartesian_Scaling.dat' u 1:2 notitle w lp pt 7 ps 0.5 lc rgb 'black'

set ylabel 'ln<l>'
set xlabel 'ln({/Symbol a}_c - {/Symbol a})'

p 'datafiles/Two_Dimensional_PDLL_Cartesian_Scaling.dat' u 3:4 notitle w lp pt 7 ps 0.5 lc rgb 'black'

unset multiplot