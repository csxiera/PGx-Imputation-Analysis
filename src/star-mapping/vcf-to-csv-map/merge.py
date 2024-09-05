import os
import csv
import sys

def merge_csv_files(output_file, csv_type):
    # Get list of CSV files in the current directory
    csv_files = [file for file in os.listdir('.') if file.endswith(csv_type)]

    # Initialize an empty list to store rows from all CSV files
    all_rows = []

    # Iterate over each CSV file and append its content to all_rows
    for file_name in csv_files:
        with open(file_name, 'r', newline='') as csv_file:
            reader = csv.reader(csv_file)
            for row in reader:
           	    all_rows.append(row)

        # Write the merged data to a single CSV file
        with open(output_file, 'w', newline='') as merged_file:
            writer = csv.writer(merged_file)
            writer.writerows(all_rows)

    print("Merged CSV file saved successfully.")

    with open(output_file, 'r') as file:
        lines = file.readlines()

    with open(output_file, 'w') as file:
        for line in lines:
            if line.startswith("CHROM"):
                file.write(line)
                break

        for line in lines:
            if not line.startswith("CHROM"):
                file.write(line)

if __name__ == "__main__":
    
    if len(sys.argv) != 4:
        print("Usage: python script.py <output_file.csv> <folder> <.csv type>")
        sys.exit(1)

    output_file_name = sys.argv[1]
    directory = sys.argv[2]
    csv_type = sys.argv[3]

    script_dir = os.path.dirname(os.path.abspath(__file__))
    os.chdir(os.path.join(script_dir, directory))
    current_directory = os.getcwd()

    print("Current directory for merge:", current_directory)

    merge_csv_files(output_file_name, csv_type)
