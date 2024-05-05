#!/bin/bash
#SBATCH --job-name=NODE_LIST-latency
#SBATCH --nodes=2
#SBATCH --ntasks=2
#SBATCH --output=/home/ogooberman/ukscc-team-4/OSU/outputs/latency-pinned-eth0-NODE_LIST-%j.out
#SBATCH --time=01:00:00
#SBATCH --nodelist=NODE_LIST
#SBATCH --exclusive

module load compilers/gcc/13 libraries/openmpi/5.0.3/gcc-13

# pin processes to core that is servicing the network adapter interupts (run cat /proc/interrupts to see which core has service most interupts for device)
# Use below script to print core for each queue
# for i in $(egrep "\eth0."  /proc/interrupts |awk -F ":" '{print $1}');do cat /proc/irq/$i/smp_affinity_list;done
# CORE FOR CN01 
# mgmnt port   -> core 11 (DON'T USE THIS)
# eth0-Tx-Rx-0 -> core 7
# eth0-Tx-Rx-1 -> core 9
# eth0-Tx-Rx-2 -> core 10
# eth0-Tx-Rx-3 -> core 12
# eth0-Tx-Rx-4 -> core 1
# eth0-Tx-Rx-5 -> core 14
# eth0-Tx-Rx-6 -> core 3
# eth0-Tx-Rx-7 -> core 5

# etho-Tx-Rx-0 has IRQ number 52 so we can see the mask that irqbalance uses to select a core in /proc/irq/52/smp_affinity
# Command to get the cpu core that the first eth0 IRQ is attached to
# cat /proc/irq/`grep -m 1 "\eth0." /proc/interrupts |awk -F ":" '{print $1}' | awk '{$1=$1;print}'`/smp_affinity_list

# warning will change as the system can dynamically move which core services IRQ interrupts
# can stop this ocurring using irqbalance but probably don't want to do that as will impact other users...
# could have used osu_multi_lat to test latency between all nodes at once but since testing is done at the same time elected to do it with separate tasks instead so not sharing bandwidth between tests

# this command only runs on the host machine but it appears that they all have use the sime IRQ core pinnings by default (probably as a result )
CLOSEST_CORE=$(cat /proc/irq/`grep -m 1 "\eth0." /proc/interrupts |awk -F ":" '{print $1}' | awk '{$1=$1;print}'`/smp_affinity_list)
mpirun -np 2 -cpu-list $CLOSEST_CORE ~/build/OSU/libexec/osu-micro-benchmarks/mpi/pt2pt/osu_latency