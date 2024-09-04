import csv
import os

# List of dataset directories
datasets = ["1000g_s_30x", "1000g_m_30x", "1000g_s", "1000g_m", "topmed_s", "topmed_m"]

# Path to the master CSV file
master_csv = os.path.expanduser('~/PGx_Imputation-Analysis/results/master_stars.csv')

# Open the master CSV file in append mode
with open(master_csv, 'a', newline='') as master_file:
    writer = csv.writer(master_file)

    # Loop over the dataset directories
    for dataset in datasets:
        # Path to the stars_output.csv file in the current dataset directory
        stars_output_csv = os.path.expanduser(f'~/PGx_Imputation-Analysis/data/output-files/{dataset}/stars_output.csv')

        # Open the stars_output.csv file
        with open(stars_output_csv, 'r') as stars_output_file:
            reader = csv.reader(stars_output_file)

            # Skip the header row
            next(reader)

            # Write the rows to the master CSV file
            for row in reader:
                writer.writerow(row)
