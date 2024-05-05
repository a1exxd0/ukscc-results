#!/bin/bash


# tested using armpl but it introduced overhead at that point
# done similarly to how I did in HPL

# this is optimal configuration. Tested without openmp and performance was down by x10
# running with -march=armv8-a+simd ends up slower than -mcpu native or both so we avoid
OPTIMS="-Ofast -funsafe-math-optimizations -mcpu=native -ffast-math -flto"


# standard further optimisation flags
CCFLAGS="-fopenmp -fomit-frame-pointer -O3 -funroll-loops"

# 1M -> 530 GB/s
# 500K -> 606 GB/s
# 400K -> 600GB/s
# 600K -> 603 GB/s
# 500 looks like optimal after more runs
STREAMSIZE=25000000

# arbitrary
N_TIMES=20000
armclang $OPTIMS $CCFLAGS -DSTREAM_ARRAY_SIZE=$STREAMSIZE -DNTIMES=$N_TIMES -O stream.c -o stream
