import os
import csv
import sys

def merge_csv_files(input_file_dir, output_file, csv_type):
    # Get list of CSV files in the current directory
    csv_files = [os.path.join(input_file_dir, file) for file in os.listdir(input_file_dir) if file.endswith(csv_type)]

    # Initialize an empty list to store rows from all CSV files
    all_rows = []

    # Iterate over each CSV file and append its content to all_rows
    for file_name in csv_files:
        with open(file_name, 'r', newline='') as csv_file:
            reader = csv.reader(csv_file)
            for row in reader:
                all_rows.append(row)

    # Write the merged data to a single CSV file
    output_file_path = os.path.join(input_file_dir, output_file)
    with open(output_file_path, 'w', newline='') as merged_file:
        writer = csv.writer(merged_file)
        writer.writerows(all_rows)

    print("Merged CSV file saved successfully.")

    with open(output_file_path, 'r') as file:
        lines = file.readlines()

    with open(output_file_path, 'w') as file:
        for line in lines:
            if line.startswith("CHROM"):
                file.write(line)
                break

        for line in lines:
            if not line.startswith("CHROM"):
                file.write(line)

    # Delete all files ending in "pgx.csv" in the input directory
    for file_name in os.listdir(input_file_dir):
        if file_name.endswith("pgx.csv"):
            file_path = os.path.join(input_file_dir, file_name)
            os.remove(file_path)
            print(f"Deleted file: {file_path}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <output_file> <folder> <.csv type>")
        sys.exit(1)

    output_file_name = sys.argv[1]
    folder = sys.argv[2]
    csv_type = sys.argv[3]

    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.abspath(os.path.join(script_dir, '..', '..', '..', '..'))

    input_file_dir = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'output-files', folder)

    merge_csv_files(input_file_dir, output_file_name, csv_type)