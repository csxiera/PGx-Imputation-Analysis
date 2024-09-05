import csv
import sys
import os

def compare_csv_files(file1, file2, output):
    positions_file2 = set()

    # Read positions from file 2
    with open(file2, 'r') as csvfile:
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            position = row[1]  # Assuming position is in the 2nd column
            positions_file2.add(position)

    # Read rows from file 1 and extract matching rows
    matching_rows = []
    with open(file1, 'r') as csvfile:
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            position = row[4]  # Assuming position is in the 5th column
            if position in positions_file2:
                row[0] = '*' + row[0].split('*')[-1]
                matching_rows.append(row)

    # Write matching rows to the output file
    with open(output, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        csv_writer.writerows(matching_rows)

    os.remove(file2)

if __name__ == "__main__":
    chrom = sys.argv[1]
    folder = sys.argv[2]
    build = sys.argv[3]

    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.abspath(os.path.join(script_dir, '..', '..', '..', '..'))

    file1_path = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'star-allele-defs', build, f'chr_{chrom}.csv')
    file2_path = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'output-files', folder, f'chr_{chrom}_matches.csv')
    output_file_path = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'output-files', folder, f'chr_{chrom}_stars.csv')
    
    #current_directory = os.getcwd()
    #print("Current directory for get_stars:", current_directory)

    compare_csv_files(file1_path, file2_path, output_file_path)
    print("Matching rows have been written to", output_file_path)