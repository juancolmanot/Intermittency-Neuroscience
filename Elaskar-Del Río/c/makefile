# ====================================================================
# Compiler info and paths
# ====================================================================

CC=gcc
MPATH=../../../modulosc/
HPATH= -I${MPATH}
CPATH= -L${MPATH}
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

CFLAGS=${flag_o01} ${flag_o02} ${flag_w01} ${flag_d01}

# ====================================================================
# Compilation directories
# ====================================================================

MAIN=
HEADERS=
HEADERS_O:=$(addprefix $(MPATH),$(HEADERS))
HEADERS_O=$(addsuffix .o,$(HEADERS))
HEADERS_H:=$(addprefix $(MPATH),$(HEADERS_O))
HEADERS_H=$(addsuffix .h,$(HEADERS_H))
#SOURCES=$(shell echo *.c)
#COMMON_OBJECTS=

# ====================================================================
# Generate executable
# ====================================================================
$(MAIN): $(MAIN).o $(HEADERS_O)
	@$(CC) $(CPATH) $^ -o $@

# ====================================================================
# Compile output files
# ====================================================================
$(MAIN).o: $(MAIN).c $(HEADERS_H)
	@$(CC) $(CFLAGS) $(OPTFLAGS) -c - o $@ $< 


# ====================================================================
# Clean
# ====================================================================	

clean:
	@rm -f ${MAIN} *.o

.PHONY: clean all