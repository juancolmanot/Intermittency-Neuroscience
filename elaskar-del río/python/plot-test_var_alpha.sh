#!/usr/bin/gnuplot

set terminal pdfcairo size 8, 8 font 'Arial, 21'

set output "plots/plot_test_var_alpha.pdf"


n = 1000 

set grid lw 2
set key font ', 14'
set ytics font ', 14'
set xtics font ', 14'

set multiplot layout 1,1 rowsfirst


set ylabel 'y_n'
set xlabel 'x_n'

p 'datafiles/test_var_alpha.dat' every 1::(n + 1)*0::(n + 1)*1 u 2:3 notitle w p pt 5 ps 0.5, \
  'datafiles/test_var_alpha.dat' every 1::(n + 1)*1::(n + 1)*2 u 2:3 notitle w p pt 7 ps 0.5, \
  'datafiles/test_var_alpha.dat' every 1::(n + 1)*2::(n + 1)*3 u 2:3 notitle w p pt 9 ps 0.5, \
  'datafiles/test_var_alpha.dat' every 1::(n + 1)*3::(n + 1)*4 u 2:3 notitle w p pt 11 ps 0.5, \
  'datafiles/test_var_alpha.dat' every 1::(n + 1)*4::(n + 1)*5 u 2:3 notitle w p pt 13 ps 0.5

unset multiplot
unset terminal