import csv
import sys
import os

def condense_variants(input_file, output_file):
    condensed_variants = {}

    # Read input file and aggregate variants for each position
    with open(input_file, 'r') as csvfile:
        csv_reader = csv.reader(csvfile)
        for row in csv_reader:
            position = row[4]
            allele = row[0].split('*')[1]
            gene = row[1]
            rsid = row[2]
            chromosome = row[3]

            # If position not already present in condensed_variants, add it with gene, rsid, and chromosome
            if position not in condensed_variants:
                condensed_variants[position] = {'alleles': [], 'gene': gene, 'rsid': rsid, 'chromosome': chromosome}

            # Append allele to the list of alleles for the position
            condensed_variants[position]['alleles'].append('*' + allele)

    # Write condensed variants to the output file
    with open(output_file, 'w', newline='') as csvfile:
        csv_writer = csv.writer(csvfile)
        for position, data in condensed_variants.items():
            alleles_str = ';'.join(data['alleles'])
            csv_writer.writerow([alleles_str, data['gene'], data['rsid'], data['chromosome'], position])
    
    os.remove(input_file)

if __name__ == "__main__":
    chrom = sys.argv[1]
    folder = sys.argv[2]

    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.abspath(os.path.join(script_dir, '..', '..', '..', '..'))

    input_file_path = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'output-files', folder, f'chr_{chrom}_stars.csv')
    output_file_path = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'output-files', folder, f'chr_{chrom}_pgx.csv')

    #current_directory = os.getcwd()
    #print("Current directory for condense:", current_directory)

    condense_variants(input_file_path, output_file_path)
    print("Condensed variants have been written to", output_file_path)