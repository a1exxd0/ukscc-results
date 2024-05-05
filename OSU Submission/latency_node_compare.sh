#!/bin/bash

echo "running...."

# list of nodes to check
nodes=("cn01" "cn02" "cn03" "cn04")
max=${#nodes[@]} 

# Loop through the list
for ((i = 0; i < ${#nodes[@]}; i++)); do
    for ((j = i + 1; j < ${#nodes[@]}; j++)); do
        echo "Node 1: ${nodes[$i]}; Node 2: ${nodes[$j]}"
        cp $HOME/ukscc-team-4/OSU/latency_template.sbatch $HOME/ukscc-team-4/OSU/latency_temp.sbatch
        sed -i 's@NODE_LIST@'"${nodes[$i]}"','"${nodes[$j]}"'@' $HOME/ukscc-team-4/OSU/latency_temp.sbatch
        sbatch $HOME/ukscc-team-4/OSU/latency_temp.sbatch
    done
done

rm $HOME/ukscc-team-4/OSU/latency_temp.sbatch