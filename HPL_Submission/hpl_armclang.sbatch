#!/bin/bash
#SBATCH --job-name=ARMada
#SBATCH --nodes=4
#SBATCH --ntasks-per-node=16
#SBATCH --cpus-per-task=1
#SBATCH --mem=120G
#SBATCH --time=03:00:00
#SBATCH --output=build/hpl_team_4_armclang.%j.out

module load compilers/armclang/24.04
module load libraries/openmpi/5.0.3/armclang-24.04

cd /home/ado/ukscc-team-4/HPL/hpl-2.3/bin/armclang
/apps/modules/libraries/openmpi/5.0.3/armclang-24.04/bin/mpirun -np 64 --map-by ppr:16:node --bind-to core ./xhpl
