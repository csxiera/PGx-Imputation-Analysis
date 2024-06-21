import csv
import os
import sys

# Get the dataset directory from the command-line arguments
dataset_dir = sys.argv[1]

# Map the dataset directories to the dataset names
dataset_names = {
    "1000g_s_30x": "1000G 30x Standard",
    "1000g_m_30x": "1000G 30x Modified",
    "1000g_s": "1000G Standard",
    "1000g_m": "1000G Modified",
    "topmed_s": "Topmed Standard",
    "topmed_m": "Topmed Modified"
}

# Get the dataset name for the given directory
dataset_name = dataset_names.get(dataset_dir, "Unknown Dataset")

# Specify the paths to your files
txt_file = os.path.expanduser(f'~/mdsc508/{dataset_dir}/overlap_all.txt')
output_file = os.path.expanduser(f'~/mdsc508/{dataset_dir}/stars_output.csv')

# List of chromosomes
chromosomes = [7, 10, 12, 13, 19, 22]

# Open the output file
with open(output_file, 'w', newline='') as outfile:
    writer = csv.writer(outfile)
    # Write the header row
    writer.writerow(['allele', 'gene', 'rsid', 'chr', 'pos', 'dataset'])

    # Loop over the chromosomes
    for chromosome in chromosomes:
        csv_file = os.path.expanduser(f'~/mdsc508/chr_{chromosome}.csv')

        # Read the CSV file and store the variants in a dictionary
        variants = {}
        with open(csv_file, 'r') as csvfile:
            reader = csv.reader(csvfile)
            for row in reader:
                rsid = row[2]
                position = row[4]
                if rsid != "-":
                    variants[rsid] = row
                else:
                    variants[position] = row

        # Read the TXT file and check if each variant exists in the dictionary
        with open(txt_file, 'r') as txtfile:
            reader = csv.reader(txtfile, delimiter='\t')
            for row in reader:
                rsid = row[2]
                position = row[1]
                if rsid in variants:
                    # Split the first column into gene and allele
                    gene_allele = variants[rsid][0].split('*')
                    gene = gene_allele[0]
                    allele = '*' + gene_allele[1]
                    # Write the row in the new format
                    writer.writerow([allele, gene, rsid, variants[rsid][3], variants[rsid][4], dataset_name])
                elif position in variants:
                    # Split the first column into gene and allele
                    gene_allele = variants[position][0].split('*')
                    gene = gene_allele[0]
                    allele = '*' + gene_allele[1]
                    # Write the row in the new format
                    writer.writerow([allele, gene, 'rsid' if variants[position][2] != "-" else '.', variants[position][3], variants[position][4], dataset_name])