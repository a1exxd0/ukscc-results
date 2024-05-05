import os
import csv
import glob
import re
import sys

# function to extract slurm job number from production run filenames
def get_final_number(filename):
    # Extract the final number from the filename
    match = re.search(r'(\d+)\.out$', filename)
    if match:
        return int(match.group(1))
    else:
        return 0  # Default to 0 if no final number found

def combine_data(directory, search, output_filename):
    # Get all the files in the directory
    files = glob.glob(os.path.join(directory, search))
    files.sort(key=get_final_number)
    print(files)

    # Initialize a dictionary to store data
    data = {}

    # Iterate through each file
    for file in files:
        filename = os.path.basename(file)
        
        # Extract column header from filename
        header = filename.split('.')[0]
        
        # Read the file and extract data
        with open(file, 'r') as f:
            lines = f.readlines()
            # Extracting data starts from the second line
            data["Size"] = [line.strip().split()[0] for line in lines[4:]]
            data[header] = [line.strip().split()[1] for line in lines[4:]]
    
    # Writing combined data to a CSV file
    with open(os.path.join(directory, output_filename), 'w', newline='') as csvfile:
        writer = csv.writer(csvfile)
        # Write headers
        writer.writerow(data.keys())
        # Transpose the data and write rows
        for row in zip(*data.values()):
            writer.writerow(row)

# Usage example
working_directory = ''
if len(sys.argv) > 1:
    # Return the first argument
    working_directory = sys.argv[1]
else:
    # If no arguments are provided, return None or handle it as needed
    raise Exception('No path provided to run script in')

combine_data(working_directory, 'latency*.out', 'combined_latency.csv')
combine_data(working_directory, 'bandwidth*.out', 'combined_bandwidth.csv')
