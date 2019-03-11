FC  = ifort
CC  = gcc
LINKER = $(FC)

OPENMP   = # -qopenmp
FCFLAGS   = -Ofast $(OPENMP) -module ./$(TAG)
LFLAGS   = $(OPENMP)
DEFINES  = -D_GNU_SOURCE
INCLUDES =
LIBS     =
