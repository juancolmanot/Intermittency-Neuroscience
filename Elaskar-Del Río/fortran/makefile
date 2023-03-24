# ====================================================================
# Compiler
# ====================================================================
FC=gfortran

# ====================================================================
# Compile flags
# ====================================================================
# Warning flags
flag_w01=-Wall -Wextra -Wconversion -pedantic
# Debugging flags
flag_d01=-ffpe-trap=zero -ffpe-trap=overflow -ffpe-trap=underflow
flag_d02=-g -fbacktrace -fbounds-check
# Optimization flags
flag_o01=-O3 -ftree-vectorize -ftree-loop-vectorize
flag_o02=-march=native
# Varios
flag_g01=-fcheck=all
flag_g02=-fbacktrace

FFLAGS=${flag_o01} ${flag_o02} ${flag_w01} ${flag_d01} ${flag_d02} \
    ${flag_g01} ${flag_g02}

# ====================================================================
# Sources
# ====================================================================


# ====================================================================
# Binaries compilation
# ====================================================================
# binary names
bin_name_01 = Intermittency_type_III_M_function
bin_name_02 = Intermittency_type_III_cobweb
bin_name_03 = Intermittency_type_III_M_prob
bin_name_04 = Intermittency_type_III_M_prob_reinjection
bin_name_05 = Intermittency_type_III_laminar_length

# object dependencies
dependencies_01 = precision.o mtmod.o maps.o matrixalgebra.o vector_statistics.o

# binary rules
# Intermittency_type_III_M_function
$(bin_name_01).o: $(dependencies_01)
	$(FC) $(FFLAGS) -o $(bin_name_01).o $(dependencies_01) $(bin_name_01).f90

# Intermittency_type_III_cobweb
$(bin_name_02).o: $(dependencies_01)
	$(FC) $(FFLAGS) -o $(bin_name_02).o $(dependencies_01) $(bin_name_02).f90

# Intermittency_type_III_M_prob
$(bin_name_03).o: $(dependencies_01)
	$(FC) $(FFLAGS) -o $(bin_name_03).o $(dependencies_01) $(bin_name_03).f90

# Intermittency_type_III_M_prob_reinjection
$(bin_name_04).o: $(dependencies_01)
	$(FC) $(FFLAGS) -o $(bin_name_04).o $(dependencies_01) $(bin_name_04).f90

# Intermittency_type_III_M_prob_reinjection
$(bin_name_05).o: $(dependencies_01)
	$(FC) $(FFLAGS) -o $(bin_name_05).o $(dependencies_01) $(bin_name_05).f90


# ====================================================================
# Modules compilation
# ====================================================================
# modules path
mod_path=../../../../cursos/modulosfortran/
# module names
mod_name_01 = precision
mod_name_02 = rangens_mod
mod_name_03 = ran2
mod_name_04 = mtmod
mod_name_05 = miscelaneous_mod_b4
mod_name_06 = matrixalgebra
mod_name_07 = functions
mod_name_08 = neuronmodels
mod_name_09 = maps
mod_name_10 = vector_statistics

# module recipes
$(mod_name_01).o:
	$(FC) -c $(mod_path)$(mod_name_01).f90
$(mod_name_04).o:
	$(FC) -c $(mod_path)$(mod_name_04).f90
$(mod_name_09).o: $(mod_name_01).o
	$(FC) -c $(mod_path)$(mod_name_09).f90
$(mod_name_06).o: $(mod_name_01).o
	$(FC) -c $(mod_path)$(mod_name_06).f90
$(mod_name_10).o: $(mod_name_01).o $(mod_name_06).o
	$(FC) -c $(mod_path)$(mod_name_10).f90


# ====================================================================
# Sources
# ====================================================================
bin_name_01_src = ${mod_path}${mod_name_01}.f90 ${mod_path}${mod_name_04}.f90 \
${mod_path}${mod_name_09}.f90 ${mod_path}${mod_name_06}.f90 \
${mod_path}${mod_name_10}.f90 ${bin_name_01}.f90

bin_name_02_src = ${mod_path}${mod_name_01}.f90 ${mod_path}${mod_name_04}.f90 \
${mod_path}${mod_name_09}.f90 ${mod_path}${mod_name_06}.f90 ${bin_name_02}.f90

bin_name_03_src = ${mod_path}${mod_name_01}.f90 ${mod_path}${mod_name_04}.f90 \
${mod_path}${mod_name_09}.f90 ${mod_path}${mod_name_06}.f90 \
${mod_path}${mod_name_10}.f90 ${bin_name_03}.f90

bin_name_04_src = ${mod_path}${mod_name_01}.f90 ${mod_path}${mod_name_04}.f90 \
${mod_path}${mod_name_09}.f90 ${mod_path}${mod_name_06}.f90 \
${mod_path}${mod_name_10}.f90 ${bin_name_04}.f90

bin_name_05_src = ${mod_path}${mod_name_01}.f90 ${mod_path}${mod_name_04}.f90 \
${mod_path}${mod_name_09}.f90 ${mod_path}${mod_name_06}.f90 \
${mod_path}${mod_name_10}.f90 ${bin_name_05}.f90

# ====================================================================
# Executable and run
# ====================================================================
# run
run_cmd = run_

# Intermittency type III M(x)
$(bin_name_01): $(bin_name_01).o $(bin_name_01).f90 $(mod_name_01).o \
$(mod_name_04).o $(mod_name_09).o $(mod_name_06).o $(mod_name_10).o
	$(FC) $(FFLAGS) -o $@ $(bin_name_01_src)
$(run_cmd)$(bin_name_01): $(bin_name_01)
	@./$(bin_name_01)

# Intermittency type III cobweb-plot
$(bin_name_02): $(bin_name_02).o $(bin_name_02).f90 $(mod_name_01).o \
$(mod_name_04).o $(mod_name_09).o $(mod_name_06).o
	$(FC) $(FFLAGS) -o $@ $(bin_name_02_src)
$(run_cmd)$(bin_name_02): $(bin_name_02)
	@./$(bin_name_02)

# Intermittency type III M(x) prob
$(bin_name_03): $(bin_name_03).o $(bin_name_03).f90 $(mod_name_01).o \
$(mod_name_04).o $(mod_name_09).o $(mod_name_06).o $(mod_name_10).o
	$(FC) $(FFLAGS) -o $@ $(bin_name_03_src)
$(run_cmd)$(bin_name_03): $(bin_name_03)
	@./$(bin_name_03)

# Intermittency type III M(x) prob reinjection
$(bin_name_04): $(bin_name_04).o $(bin_name_04).f90 $(mod_name_01).o \
$(mod_name_04).o $(mod_name_09).o $(mod_name_06).o $(mod_name_10).o
	$(FC) $(FFLAGS) -o $@ $(bin_name_04_src)
$(run_cmd)$(bin_name_04): $(bin_name_04)
	@./$(bin_name_04)

# Intermittency type III laminar length probability
$(bin_name_05): $(bin_name_05).o $(bin_name_05).f90 $(mod_name_01).o \
$(mod_name_04).o $(mod_name_09).o $(mod_name_06).o $(mod_name_10).o
	$(FC) $(FFLAGS) -o $@ $(bin_name_05_src)
$(run_cmd)$(bin_name_05): $(bin_name_05)
	@./$(bin_name_05)

# ====================================================================
# Plot
# ====================================================================
# plot
plot_cmd = plot-

# Plot Intermittency_type_III_M
$(plot_cmd)$(bin_name_01):
	@./$(plot_cmd)$(bin_name_01).sh

# Plot Intermittency_type_III_M_prob
$(plot_cmd)$(bin_name_03):
	@./$(plot_cmd)$(bin_name_03).sh

# Plot Intermittency_type_III_M_prob_reinjection
$(plot_cmd)$(bin_name_04):
	@./$(plot_cmd)$(bin_name_04).sh

# Plot Intermittency_type_III_laminar_lengths
$(plot_cmd)$(bin_name_05):
	@./$(plot_cmd)$(bin_name_05).sh

# ====================================================================
# Phony rules
# ====================================================================
clean:
	@rm -f *.o *.mod ${bin_name_01} ${bin_name_02} ${bin_name_03} ${bin_name_04} ${bin_name_05}


