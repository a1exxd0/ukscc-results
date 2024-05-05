#!/bin/bash

OPTIMS="-Ofast -funsafe-math-optimizations -mcpu=native -ffast-math -flto"

# standard further optimisation flags
CCFLAGS="-fopenmp -fomit-frame-pointer -O3 -funroll-loops"

MPdir="/apps/modules/libraries/openmpi/5.0.3/armclang-24.04"
MPinc=-I$MPdir/include
MPlib=-L$MPdir/lib/libmpi.so

# 1M -> 530 GB/s
# 500K -> 606 GB/s
# 400K -> 600GB/s
# 600K -> 603 GB/s
# 500 looks like optimal after more runs
STREAMSIZE=100000000
# STREAMSIZE=500000
# arbitrary
N_TIMES=100
mpicc $OPTIMS $CCFLAGS -DSTREAM_ARRAY_SIZE=$STREAMSIZE -DNTIMES=$N_TIMES -O stream_mpi.c -lmpi -o mpi_stream
