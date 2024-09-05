import csv
import os
import sys

def get_file_paths(input_type):
    if input_type == 'stars_csv_map':
        master_csv = os.path.expanduser('~/PGx-Imputation-Analysis/results/master_stars_vcf_to_csv.csv')
        stars_output_filename = 'stars_csv_map.csv'
    elif input_type == 'stars_vcf_map':
        master_csv = os.path.expanduser('~/PGx-Imputation-Analysis/results/master_stars_vcf_to_vcf.csv')
        stars_output_filename = 'stars_vcf_map.csv'
    else:
        raise ValueError("Invalid input type. Must be 'stars_csv_map' or 'stars_vcf_map'.")

    return master_csv, stars_output_filename

def merge_to_master(input_type):
    datasets = ["1000g_s_30x", "1000g_m_30x", "1000g_s", "1000g_m", "topmed_s", "topmed_m", "unimputed_m", "unimputed_s", "raw"]
    header = ['allele', 'gene', 'rsid', 'chr', 'pos', 'dataset']

    # Get the master CSV file and stars_output filename based on the input type
    master_csv, stars_output_filename = get_file_paths(input_type)

    with open(master_csv, 'w', newline='') as master_file:
        writer = csv.writer(master_file)

        if os.stat(master_csv).st_size == 0:
            writer.writerow(header)

        for dataset in datasets:
            stars_output_csv = os.path.expanduser(f'~/PGx-Imputation-Analysis/data/output-files/{dataset}/{stars_output_filename}')

            if os.path.exists(stars_output_csv):
                with open(stars_output_csv, 'r') as stars_output_file:
                    reader = csv.reader(stars_output_file)

                    # Skip the header row
                    next(reader, None)

                    # Write the rows to the master CSV file
                    for row in reader:
                        writer.writerow(row)

    print(f"Merged data into {master_csv} successfully.")

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python script.py <stars_csv_map|stars_vcf_map>")
        sys.exit(1)

    input_type = sys.argv[1]
    merge_to_master(input_type)

