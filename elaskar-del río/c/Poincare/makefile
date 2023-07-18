# ====================================================================
# Compiler info and paths
# ====================================================================

CC=gcc
OMP=-fopenmp
GDB=-g
MPATH=../../../../modulosc/
FFTH= -I../../../../modulosc/fftw-3.3.10/api/
FFTC= -L/usr/local/lib/
HPATH= -I${MPATH}
CPATH= -L${MPATH}
LDLIBS= -lgsl -lgslcblas -lfftw3 -lm
OPTFLAGS=-O3

# ====================================================================
# Compile flags
# ====================================================================
# Warning flags
flag_w01=-Wall -Wextra -Wconversion -pedantic -Wno-unused-parameter
# Debugging flags
flag_d01=-g
# Optimization flags
flag_o01=-O3 -ftree-vectorize -ftree-loop-vectorize -funroll-loops
flag_o02=-march=native -Ofast -ffast-math
flag_o03=-fopt-info-vec -ftree-vectorizer-verbose=2

CFLAGS=${flag_o01} ${flag_o02} ${flag_w01} ${flag_d01} ${flag_o03}

# ====================================================================
# Compilation directories
# ====================================================================

MAIN=
HEADERS=
comma:=,
HEADERS_LIST:=$(subst  ,$(comma),$(HEADERS))
HEADERS_LIST:=$(subst $(comma), ,$(HEADERS))
HEADERS_O:=$(addprefix $(MPATH),$(HEADERS_LIST))
HEADERS_O:=$(addsuffix .o,$(HEADERS_O))
HEADERS_H:=$(addprefix $(MPATH),$(HEADERS_LIST))
HEADERS_H:=$(addsuffix .h,$(HEADERS_H))


# ====================================================================
# Generate executable
# ====================================================================
$(MAIN): $(MAIN).o $(HEADERS_O)
	@$(CC) $(CPATH) $(FFTC) $^ -o $@ $(LDLIBS)

# ====================================================================
# Compile output main file
# ====================================================================
$(MAIN).o: $(MAIN).c $(HEADERS_H)
	@$(CC) $(CFLAGS) $(HPATH) $(FFTH) $(OPTFLAGS) -c -o $@ $<

# ====================================================================
# Compile output module files
# ====================================================================
$(MPATH)%.o: $(MPATH)%.c $(MPATH)%.h
	@$(CC) $(CFLAGS) $(HPATH) $(FFTH) $(OPTFLAGS) -c -o $@ $<

#
# ====================================================================
# Clean
# ====================================================================

clean:
	@rm -f ${MAIN} *.o
	@rm -f ${MPATH}*.o

.PHONY: clean all
