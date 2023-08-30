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
    n_headers=$(grep '.h"' $1.c | awk '{print $2}' | cut -d '/' -f 7 | cut -d '.' -f 1 | wc -l)
    if [ n_headers == 0 ]; then
        make MAIN=$1
    else
        headers=""
        for header in $(grep '.h"' $1.c | awk '{print $2}' | cut -d '/' -f 7 | cut -d '.' -f 1); do
            headers+="$header "
        done
        make MAIN=$1 HEADERS="$headers"
    fi
    ./$1
    make clean > /dev/null
    ./plot-$1.sh
    for file in $(ls plots/*"$1"* | awk '{print $1}'); do
        xdg-open "$file"
    done
    rm $1
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
