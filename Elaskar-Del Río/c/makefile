CC=gcc
LDFLAGS=
OPTFLAGS=-O3

# ====================================================================
# Compile flags
# ====================================================================
# Warning flags
flag_w01=-Wall -Wextra -Wconversion -pedantic -Wno-unused-parameter
# Debugging flags
flag_d01=-g
# Optimization flags
flag_o01=-O3 -ftree-vectorize -ftree-loop-vectorize
flag_o02=-march=native -Ofast -ffast-math

CFLAGS=${flag_o01} ${flag_o02} ${flag_w01} ${flag_d01}

TARGET=
SOURCES=$(shell echo *.c)
COMMON_OBJECTS=

# ====================================================================
# Compile source
# ====================================================================
$(TARGET): $(TARGET).o
	@$(CC) $(CFLAGS) $(OPTFLAGS) $^ -o $@ $(LDFLAGS)

# ====================================================================
# Clean
# ====================================================================	

clean:
	@rm -f ${TARGET} *.o

.PHONY: clean all