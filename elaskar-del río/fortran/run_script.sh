#!/bin/bash

help_panel(){
    echo -e "RUN SCRIPT"
    echo -e "\trun_script: Es una herramienta que permite correr los scripts\n de intermitencia y plotear los resultados."
    echo -e "SINOPSIS"
    echo -e "\trun_script [programa a ejecutar]"
    echo -e "OPCIONES"
    echo -e "\tPrograma a ejecutar"
    echo -e "\t\tNombre del programa a ejecutar (debe estar previsto en el Makefile)"
}


exec_script(){
    make clean > /dev/null
    echo "[+] Make command info"
    make "run_$1"
    make "plot-$1"
    make clean > /dev/null
    xdg-open plots/"plot_$1.pdf"
}

if [ -z $1 ]; then
    help_panel
    exit 1
elif [ $1 == "-h" ]; then
    help_panel
    exit 1
else
    exec_script $1
fi
exit 0