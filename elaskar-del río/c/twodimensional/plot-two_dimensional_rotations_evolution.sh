#!/usr/bin/gnuplot

set terminal pdfcairo size 8,8 font 'Arial, 21'
output_file = "plots/plot_Two_Dimensional_Rotations_Evolution_xy.pdf"
set output output_file

set grid lw 2

set key font ',12'
set ytics font ',12'
set xtics font ',12'

set xlabel 'n'

set multiplot layout 2,2 rowsfirst

set ylabel 'x'

p 'datafiles/Two_Dimensional_Rotations_Evolution_xy.dat' u 1:2 notitle w p pt 7 ps 0.2

set ylabel 'y'

p 'datafiles/Two_Dimensional_Rotations_Evolution_xy.dat' u 1:3 notitle w p pt 7 ps 0.2

set ylabel 'x1'

p 'datafiles/Two_Dimensional_Rotations_Evolution_xy.dat' u 1:4 notitle w p pt 7 ps 0.2

set ylabel 'y1'

p 'datafiles/Two_Dimensional_Rotations_Evolution_xy.dat' u 1:5 notitle w p pt 7 ps 0.2

unset multiplot

unset output

unset terminal



do for [i=0:7] {

    set terminal pdfcairo size 16,16 font 'Arial, 21'
    output_file = sprintf("plots/plot_Two_Dimensional_Rotations_Evolution_tetha=pi * $d/4.pdf", i)
    set output output_file

    set grid lw 2

    set key font ',12'
    set ytics font ',12'
    set xtics font ',12'

    set xlabel 'n'

    set multiplot layout 2,2 rowsfirst

    set ylabel 'u'

    p 'datafiles/Two_Dimensional_Rotations_Evolution_uv.dat' every 1::5000*i::5000*(i+1) u 1:2 notitle w p pt 7 ps 0.2

    set ylabel 'v'

    p 'datafiles/Two_Dimensional_Rotations_Evolution_uv.dat' every 1::5000*i::5000*(i+1) u 1:3 notitle w p pt 7 ps 0.2

    set ylabel 'u1'

    p 'datafiles/Two_Dimensional_Rotations_Evolution_uv.dat' every 1::5000*i::5000*(i+1) u 1:4 notitle w p pt 7 ps 0.2

    set ylabel 'v1'

    p 'datafiles/Two_Dimensional_Rotations_Evolution_uv.dat' every 1::5000*i::5000*(i+1) u 1:5 notitle w p pt 7 ps 0.2

    unset multiplot

    unset output

    unset terminal
}





unset multiplot
unset output
unset terminal