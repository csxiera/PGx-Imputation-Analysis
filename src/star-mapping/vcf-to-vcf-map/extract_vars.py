import csv
import os
import sys

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

txt_file = os.path.expanduser(f'/home/courtney.lenz/PGx-Imputation-Analysis/data/gwas/{dataset_dir}/overlap_all.txt')
output_file = os.path.expanduser(f'/home/courtney.lenz/PGx-Imputation-Analysis/data/gwas/{dataset_dir}/stars_vcf_map.csv')

chromosomes = [7, 10, 12, 13, 19, 22]

# Map star allele definitions to variants in given dataset
with open(output_file, 'w', newline='') as outfile:
    writer = csv.writer(outfile)
    writer.writerow(['allele', 'gene', 'rsid', 'chr', 'pos', 'dataset'])

    for chromosome in chromosomes:
        csv_file = os.path.expanduser(f'/home/courtney.lenz/PGx-Imputation-Analysis/data/star-allele-defs/chr_{chromosome}.csv')

        # Store star allele variants
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

        # Identify star allele variants present in dataset using variant rsid or position
        with open(txt_file, 'r') as txtfile:
            reader = csv.reader(txtfile, delimiter='\t')
            for row in reader:
                rsid = row[2]
                position = row[1]
                if rsid in variants:
                    gene_allele = variants[rsid][0].split('*')
                    gene = gene_allele[0]
                    allele = '*' + gene_allele[1]
                    writer.writerow([allele, gene, rsid, variants[rsid][3], variants[rsid][4], dataset_name])
                elif position in variants:
                    gene_allele = variants[position][0].split('*')
                    gene = gene_allele[0]
                    allele = '*' + gene_allele[1]
                    writer.writerow([allele, gene, 'rsid' if variants[position][2] != "-" else '.', variants[position][3], variants[position][4], dataset_name])
