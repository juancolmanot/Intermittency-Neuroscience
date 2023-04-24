# ====================================================================
# Compiler info and paths
# ====================================================================

CC=gcc
MPATH=../../../../cursos/modulosc/
HPATH= -I${MPATH}
CPATH= -L${MPATH}
LDLIBS= -lm
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
comma:=,
HEADERS_LIST:=$(subst  ,$(comma),$(HEADERS))
HEADERS_LIST:=$(subst $(comma), ,$(HEADERS))
HEADERS_O:=$(addprefix $(MPATH),$(HEADERS_LIST))
HEADERS_O:=$(addsuffix .o,$(HEADERS_O))
HEADERS_H:=$(addprefix $(MPATH),$(HEADERS_LIST))
HEADERS_H:=$(addsuffix .h,$(HEADERS_H))
#SOURCES=$(shell echo *.c)
#COMMON_OBJECTS=


# ====================================================================
# Generate executable
# ====================================================================
$(MAIN): $(MAIN).o $(HEADERS_O)
	@$(CC) $(CPATH) $^ -o $@ $(LDLIBS)

# ====================================================================
# Compile output main file
# ====================================================================
$(MAIN).o: $(MAIN).c $(HEADERS_H)
	@$(CC) $(CFLAGS) $(HPATH) $(OPTFLAGS) -c -o $@ $<

# ====================================================================
# Compile output module files
# ====================================================================
$(MPATH)%.o: $(MPATH)%.c $(MPATH)%.h
	@$(CC) $(CFLAGS) $(HPATH) $(OPTFLAGS) -c -o $@ $<

# $(foreach HEADER,$(HEADERS_LIST),\
# 	H_C=$(addsuffix .c, $(addprefix $(MPATH),$(HEADER))) \
# 	H_H=$(addsuffix .o, $(addprefix $(MPATH),$(HEADER))) \
# 	$(HEADER).o: $(H_C) $(H_H) \
# 		@$(CC) $(CFLAGS) $(HPATH) $(OPTFLAGS) -c -o $@ $< \
# )
# ====================================================================
# Clean
# ====================================================================

clean:
	@rm -f ${MAIN} *.o
	@rm -f ${MPATH}*.o

.PHONY: clean all
