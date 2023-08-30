#!/usr/bin/gnuplot

set terminal pdfcairo size 12,12 font 'Arial, 21'

set output "plots/plot_two_dimensional_test_reinjection.pdf"

set multiplot layout 2,2 rowsfirst

p 'datafiles/two_dimensional_test_lavg_x.dat' u (log($1)):(log($2)) notitle w lp pt 6 ps 0.5, \
'datafiles/two_dimensional_test_lavg_x.dat' u (log($1)):(log(1/sqrt($1))) notitle w lp pt 6 ps 0.5

p 'datafiles/two_dimensional_test_lavg_y.dat' u (log($1)):(log($2)) notitle w lp pt 6 ps 0.5, \
'datafiles/two_dimensional_test_lavg_y.dat' u (log($1)):(log(1/sqrt($1))) notitle w lp pt 6 ps 0.5

p 'datafiles/two_dimensional_test_lavg_xy.dat' u (log($1)):(log($2)) notitle w lp pt 6 ps 0.5, \
'datafiles/two_dimensional_test_lavg_xy.dat' u (log($1)):(log(1/sqrt($1))) notitle w lp pt 6 ps 0.5

unset multiplot
