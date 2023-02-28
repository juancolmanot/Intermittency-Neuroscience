#!/bin/bash

# module paths
    pth_mod_01='../../modulos/prec_mod.f90'
    pth_mod_02='../../modulos/rangens_mod.f90'
    pth_mod_03='../../modulos/ran2.f90'
    #pth_mod_04='../../modulos/mzran.f90'
    pth_mod_05='../../modulos/mtmod.f90'
    #pth_mod_06='../../modulos/miscelaneous_mod_b4.f90'
    pth_mod_07='../../modulos/matrixalgebra.f90'

    pth_mod=''${pth_mod_01}' '${pth_mod_02}' '${pth_mod_03}' '${pth_mod_05}' '${pth_mod_07}'' #'${pth_mod_06}''

# object code name
    ob_cod_name='RulkovChaos5.o'

# fortran code name
    f90_cod_name='RulkovChaos5.f90'

# compile flags
    ## warning flags
		flg_w01='-Wall -Wextra -Wconversion -pedantic'
	## debugging flags
		flg_d01='-ffpe-trap=zero -ffpe-trap=overflow -ffpe-trap=underflow' 
		flg_d02='-g -fbacktrace -fbounds-check'
	## optimization flags
		flg_o01='-o3 -ftree-vectorize -ftree-loop-vectorize'
		flags_o02='-march=native'
    ## varios    
        flg_g01='-fcheck=all'
        flg_g02='-fbacktrace'

	flags=${flg_o01}' '${flg_o02}' '${flg_w01}' '${flg_d02}' '${flg_d02}' '${flg_g01}

# libraries
    lib01='-lfftw3'

# execution
    # remove modules, objects and existing results.dat
    rm -f *.mod *.o

    #gfortran ${flags} -o ${ob_cod_name} ${pth_mod} ${f90_cod_name}
    gfortran -g ${flags} -o ${ob_cod_name} ${pth_mod} ${f90_cod_name} 

    ./${ob_cod_name}

    # remove modules and object codes
    rm -f *.mod*.o

# Notes:

# compilation
#   1) chmod +x script.sh
#   2) ./script.sh