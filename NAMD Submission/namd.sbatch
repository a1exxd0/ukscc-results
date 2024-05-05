#!/bin/bash
#SBATCH --job-name=namd-4        # create a short name for your job
#SBATCH --nodes=4                # node count
#SBATCH --ntasks-per-node=16     # tasks per nodes
#SBATCH --cpus-per-task=1        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --mem-per-cpu=4G         # memory per cpu-core (4G per cpu-core is default)
#SBATCH --time=00:30:00          # total run time limit (HH:MM:SS)

module purge

module load compilers/gcc/13 libraries/openmpi/5.0.3/gcc-13 tools/cmake

# add tcl and fftw that is was built with to path
export LD_LIBRARY_PATH="$HOME/build/NAMD/NAMD_3.0b6_Source/tcl/lib:$HOME/build/NAMD/NAMD_3.0b6_Source/fftw/lib:$LD_LIBRARY_PATH"

# add charmrun to path (so we can use net/mpi or whatever it was built with)
export PATH="$HOME/build/NAMD/NAMD_3.0b6_Source/charm-v7.0.0/bin:$PATH"

sed -i -e 's:outputName.*:outputName          /home/ogooberman/ukscc-team-4/NAMD/outputs/4-node-run:g' $HOME/build/stmv/stmv.namd

srun --distribution=block:block --hint=nomultithread ~/build/NAMD/NAMD_3.0b6_Source/Linux-ARM64-g++/namd3 ~/build/stmv/stmv.namd

# mpirun -np 16 ~/build/NAMD/NAMD_3.0b6_Source/Linux-ARM64-g++/namd3 ~/build/stmv/stmv.namd
# srun -np 2 ~/build/NAMD/NAMD_3.0b6_Source/Linux-ARM64-g++/namd3 ~/build/stmv/stmv.namd