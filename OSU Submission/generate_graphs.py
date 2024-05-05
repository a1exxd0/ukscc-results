# ugly code to generate comparison graphs of OSU benchmarks

import pandas as pd
import matplotlib.pyplot as plt
import sys

def create_node_pair_comparison_graph(test):
    df = pd.read_csv(sys.argv[1] + "/combined_" + test + ".csv")

    # Extract unique node pairs
    node_pairs = set(column.split('-')[-2] for column in df.columns if ',' in column)
    print(node_pairs)

    # Plotting
    fig, axs = plt.subplots(2, 3, sharex=True)
    legend_handles = {}

    # create graph for each node pair
    for i, pair in enumerate(node_pairs):
        # get column data
        columns = list(column for column in df.columns if pair in column)
        columns.sort()
        print(columns)
        for col in columns:
            lbl = col[:col.find('-'+pair)]
            if lbl not in legend_handles:
                legend_handles[lbl] = axs[i//3, i%3].plot(df['Size'], df[col], label=lbl)[0]
            else:
                axs[i//3, i%3].plot(df['Size'], df[col], label=lbl)
        axs[i//3, i%3].set_title(pair)
        axs[i//3, i%3].set_yscale('log')
        axs[i//3, i%3].set_xscale('log')

    if test == "bandwidth":
      fig.legend(legend_handles.values(), legend_handles.keys(), loc='lower right')
    else:
      fig.legend(legend_handles.values(), legend_handles.keys(), loc='upper right')
    plt.tight_layout()

    # Save plot to file
    plt.savefig(sys.argv[1] + "/grid_of_node_" + test + ".png")

def create_run_comparison_graph(test):
    df = pd.read_csv(sys.argv[1] + "/combined_" + test + ".csv")

    # types of runs
    run_types = (test, test+'-pinned', test+'-pinned-eth0')
    node_pairs = set(column.split('-')[-2] for column in df.columns if ',' in column)
    print(node_pairs)

    # Plotting
    fig, axs = plt.subplots(1, 3, sharex=True)
    legend_handles = {}

    # create graph for each node pair
    for i, run_type in enumerate(run_types):
        # get column data
        for node_pair in node_pairs:
            col = list(column for column in df.columns if run_type + '-' + node_pair in column)[0]
            lbl = node_pair
            if lbl not in legend_handles:
                legend_handles[lbl] = axs[i].plot(df['Size'], df[col], label=lbl)[0]
            else:
                axs[i].plot(df['Size'], df[col], label=lbl)
        axs[i].set_title(run_type)
        axs[i].set_yscale('log')
        axs[i].set_xscale('log')

    if test == "bandwidth":
      fig.legend(legend_handles.values(), legend_handles.keys(), loc='lower right')
    else:
      fig.legend(legend_handles.values(), legend_handles.keys(), loc='upper right')
    plt.tight_layout()

    # Save plot to file
    plt.savefig(sys.argv[1] + "/grid_of_runs_" + test + ".png")

# Read data from CSV file
working_directory = ''
if len(sys.argv) < 2:
    # If no arguments are provided, throw exception
    raise Exception('No path provided to run script in')
else:
    working_directory = sys.argv[1]

create_run_comparison_graph("bandwidth")
create_run_comparison_graph("latency")

create_node_pair_comparison_graph("bandwidth")
create_node_pair_comparison_graph("latency")