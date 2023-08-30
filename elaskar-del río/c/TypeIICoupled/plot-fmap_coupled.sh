#!/usr/bin/gnuplot

set terminal pdfcairo enhanced size 4.3,4 font 'Arial, 14'

set output "../plots/plot_fmap_coupled.pdf"

set ylabel 'f(x)' rotate by 0
set xlabel 'x'

# set linetype and dashtype
set style arrow 1 nohead lc 'black' lt 1 lw 1.5 dashtype 3
set style arrow 2 lc 'black' lt 2 lw 1.5
set style line 1 lc rgb 'black' lt 1 lw 1.5 dashtype 3


set xrange [-10:10]
set yrange [-10:10]

set xtics -10, 2, 10
set ytics -10, 2, 10

set label "x_c" at -3,-0.2 center font ", 13"

set arrow from 0, graph 0 to 0, graph 1 arrowstyle 1
set arrow from -3.167, 0 to -3.167, 8.534 lc 'black' lw 1.5 head


p '../datafiles/fmap_typeII_coulped_x.dat' u 1:2 notitle w l lw 1.5 lc rgb 'black', \
x notitle w l lw 1 lc rgb 'black', \
0 notitle w l linestyle 1
