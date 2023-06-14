#!/usr/bin/gnuplot

set terminal pdfcairo size 8,16 font 'Arial, 21'

set output "plots/plot_Two_Dimensional_Plot3D.pdf"

set grid lw 2

set key font ',12'
set ytics font ',12'
set xtics font ',12'
set autoscale

set style data lines
set hidden3d
set dgrid3d 50,50,2

set xyplane at 0

set multiplot layout 2,1 rowsfirst

set xlabel 'x'
set ylabel 'y'
set zlabel 'F(x,y)'

set view 45, 45, 1

set autoscale

splot 'datafiles/Two_Dimensional_Plot3D.dat' u 1:2:3 notitle lc rgb 'black' # w lp pt 6 ps 0.05 lw 0.5 lc rgb 'black'

set xlabel 'x'
set ylabel 'y'
set zlabel 'G(x,y)'

set view 45, 45, 1

set autoscale

splot 'datafiles/Two_Dimensional_Plot3D.dat' u 1:2:4 notitle lc rgb 'black' #w lp pt 6 ps 0.05 lw 0.5 lc rgb 'black'

unset multiplot
unset output
unset terminal
