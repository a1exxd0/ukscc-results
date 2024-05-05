#!/bin/bash
#SBATCH --job-name=NODE_LIST-bandwidth
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --output=/home/ogooberman/ukscc-team-4/OSU/outputs/bandwidth-pinned-eth0-NODE_LIST-%j.out
#SBATCH --time=01:00:00
#SBATCH --nodelist=NODE_LIST
#SBATCH --exclusive

module load compilers/gcc/13 libraries/openmpi/5.0.3/gcc-13

# pin processes to core 7 as that is what is servicing the network adapter interupts (run cat /proc/interrupts to see which core is assigned)
# warning will change as the system can dynamically move which core services IRQ interrupts

CLOSEST_CORE=$(cat /proc/irq/`grep -m 1 "\eth0." /proc/interrupts |awk -F ":" '{print $1}' | awk '{$1=$1;print}'`/smp_affinity_list)
mpirun -np 2 -cpu-list $CLOSEST_CORE ~/build/OSU/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_bw