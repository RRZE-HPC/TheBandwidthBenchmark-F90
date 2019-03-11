FC  = gfortran
CC  = gcc
LINKER = $(FC)

OPENMP   =  -fopenmp
FCFLAGS   = -Ofast $(OPENMP) -J./$(TAG)
LFLAGS   = $(OPENMP)
DEFINES  = -D_GNU_SOURCE
INCLUDES =
LIBS     =
