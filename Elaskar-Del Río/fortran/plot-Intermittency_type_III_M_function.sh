#!/usr/bin/gnuplot

# kind of output to generate
set terminal qt size 600,600 font 'arial,21' persist

set terminal qt enhanced

#set size 1,1

set grid lw 2
# set title 'M(x) function'
# set ylabel 'x_{reinjected}'
# set xlabel 'M(x)'

set key font ',12'
set xtics font ',11'
set ytics font ',11'


set key top left

set autoscale

# M1(x) = m1*x + ai1*(1 - m1)
# M2(x) = m2*x + ai2*(1 - m2)

#set xrange[0.0:0.65]
#set xrange[0.0:0.3]

# fit M1(x) 'Intermittency_type_III_M_avg_case1.dat' u 1:2 via ai1,m1
# fit M2(x) 'Intermittency_type_III_M_avg_case2.dat' u 1:2 via ai2,m2

# p 'Intermittency_type_III_M_case1.dat' u 1:2 title 'tot 1' w l lw 1.5 lc rgb 'black', \
#   'Intermittency_type_III_M_case2.dat' u 1:2 title 'tot 2' w l lw 1.5 lc rgb 'black', \
#   'Intermittency_type_III_M_avg_case1.dat' u 1:2 title 'avg 1' w l lw 1.5 lc rgb 'black', \
#   'Intermittency_type_III_M_avg_case2.dat' u 1:2 title 'avg 2' w l lw 1.5 lc rgb 'black'
#   [x=0.0:0.65] M1(x) t 'fit 1' w p pt 5 ps 0.5 lc rgb 'red', \
#   [x=0:0.65] M2(x) t 'fit 2' w p pt 5 ps 0.5 lc rgb 'blue'

set multiplot layout 2,1 rowsfirst

#set size 1,1
p 'Intermittency_type_III_M_case1.dat' u 1:2 t 'M(x)' w p pt 5 ps 0.2 lc rgb 'red', \
  'Intermittency_type_III_M_avg_case1.dat' u 1:2 t 'Mavg(x)' w p pt 5 ps 0.2 lw 1 lc rgb 'blue', \

set logscale y

# set yrange[1e-3:1e7]

set key top right


#set size 1,1
p 'testdif.dat' every 1::99*0::99*1 u 1:(abs($2)) t 'x**0.5' w l lw 2, \
  'testdif.dat' every 1::99*1::99*2 u 1:(abs($2)) t 'x**1' w l lw 2, \
  'testdif.dat' every 1::99*2::99*3 u 1:(abs($2)) t 'x**1.5' w l lw 2, \
  'testdif.dat' every 1::99*3::99*4 u 1:(abs($2)) t 'x**2' w l lw 2
  # 'test.dat' every 1::9999*0::9999*1 u 1:2 notitle w l lw 1, \
  # 'testavg.dat' every 1::99*0::99*1 u 1:2 notitle w p pt 5 ps 1,\
  # 'test.dat' every 1::9999*1::9999*2 u 1:2 notitle w l lw 1, \
  # 'testavg.dat' every 1::99*1::99*2 u 1:2 notitle w p pt 5 ps 1,\
  # 'test.dat' every 1::9999*2::9999*3 u 1:2 notitle w l lw 1, \
  # 'testavg.dat' every 1::99*2::99*3 u 1:2 notitle w p pt 5 ps 1,\
  # 'test.dat' every 1::9999*3::9999*4 u 1:2 notitle w l lw 1, \
  # 'testavg.dat' every 1::99*3::99*4 u 1:2 notitle w p pt 5 ps 1,\

unset multiplot