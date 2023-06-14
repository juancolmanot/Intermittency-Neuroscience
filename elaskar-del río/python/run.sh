#!/bin/bash

python $1.py
n=$(grep "n_i = " $1.py | awk '{print $3}')
./plot-$1.sh
xdg-open plots/plot_$1.pdf
