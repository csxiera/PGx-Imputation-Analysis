#!/bin/bash

# Define the directories
core_allele_dir="$HOME/mdsc508/pharmvar"
dose_file_dir=$1

# Declare an associative array for genes and their corresponding chromosomes
declare -A gene_chromosomes=(
    ["CYP2D6"]=22
)

# Function to process each gene
process_gene() {
    local gene_chromosome="$1"
    IFS=':' read -r gene chromosome <<< "$gene_chromosome"

    echo "Processing $gene on chromosome $chromosome..."

    # Run bedtools intersect
    bedtools intersect -a ${core_allele_dir}/${gene}/${gene}_corealleles.vcf.gz \
                       -b ${dose_file_dir}/chr${chromosome}_norm.vcf.gz \
                       -wb -loj > ${dose_file_dir}/${gene}_overlap.txt

    echo "Intersection completed for $gene. Output saved to ${gene}_overlap.txt"
}

export -f process_gene
export core_allele_dir="$HOME/mdsc508/pharmvar"
export dose_file_dir=$1

# Create a list of gene:chromosome pairs
gene_chromosomes_list=()
for gene in "${!gene_chromosomes[@]}"; do
    gene_chromosomes_list+=("$gene:${gene_chromosomes[$gene]}")
done

# Run the process_gene function in parallel for each gene:chromosome pair
parallel -j 6 process_gene ::: "${gene_chromosomes_list[@]}"

echo "All intersections completed."