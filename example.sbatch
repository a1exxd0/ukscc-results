#!/bin/bash
#SBATCH --job-name=gotta_go_fast # create a short name for your job
#SBATCH --nodes=4               # node count
#SBATCH --ntasks-per-node=1     # tasks per nodes
#SBATCH --cpus-per-task=16        # cpu-cores per task (>1 if multi-threaded tasks)
#SBATCH --time=00:30:00          # total run time limit (HH:MM:SS)
#SBATCH --output=/home/efarrell/UKSCC/ukscc-team-4/MiniVite/output/4-node-LJ-prod-output_%j.out
#SBATCH --error=/home/efarrell/UKSCC/ukscc-team-4/MiniVite/output/4-node-LJ-prod-error_%j.err

module purge

module load compilers/armclang/24.04 libraries/openmpi/5.0.3/armclang-24.04

OMP_NUM_THREADS=16
OMP_PLACES=cores 
OMP_PROC_BIND=close

# Baseline run 
# mpirun -np 4 /home/efarrell/UKSCC/ukscc-team-4/MiniVite/build/miniVite/miniVite -f /home/efarrell/UKSCC/ukscc-team-4/MiniVite/build/miniVite/com-LiveJournal.bin

# Pokec dataset
# mpirun -np 4 --bind-to socket --map-by node /home/efarrell/UKSCC/ukscc-team-4/MiniVite/build/miniVite/miniVite -f /home/efarrell/UKSCC/ukscc-team-4/MiniVite/build/miniVite/soc-Pokec.bin -b -r 2 -t 0.01
# LiveJournal
mpirun -np 4 --bind-to socket --map-by node /home/efarrell/UKSCC/ukscc-team-4/MiniVite/build/miniVite/miniVite -f /home/efarrell/UKSCC/ukscc-team-4/MiniVite/build/miniVite/com-LiveJournal.bin -b -r 2 -t 0.01