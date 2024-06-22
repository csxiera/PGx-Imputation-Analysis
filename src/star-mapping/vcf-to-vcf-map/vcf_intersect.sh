#!/bin/bash

core_allele_dir="~/PGx-Imputation-Analysis/data/star-allele-def"
dose_file_dir="~/pgxproject/$1"
output_dir="~/PGx-Imputation-Analysis/data/gwas/$1"

# Declare an associative array for genes and their corresponding chrs
declare -A gene_chromosomes=(
    ["CYP2B6"]=19
    ["CYP2C9"]=10
    ["CYP2C19"]=10
    ["CYP2D6"]=22
    ["CYP3A4"]=7
    ["CYP3A5"]=7
    ["CYP4F2"]=19
    ["NUDT15"]=13
    ["SLCO1B1"]=12
)

process_gene() {
    local gene_chromosome="$1"
    IFS=':' read -r gene chromosome <<< "$gene_chromosome"

    echo "Processing $gene on chromosome $chromosome..."

    # Run bedtools intersect
    bedtools intersect -a ${core_allele_dir}/${gene}/${gene}_corealleles.vcf.gz \
                       -b ${dose_file_dir}/chr${chromosome}_norm.vcf.gz \
                       -wb -loj > ${output_dir}/${gene}_overlap.txt

    echo "Intersection completed for $gene. Output saved to ${gene}_overlap.txt"
}

export -f process_gene
export core_allele_dir
export dose_file_dir
export output_dir

# Create a list of gene:chr pairs
gene_chromosomes_list=()
for gene in "${!gene_chromosomes[@]}"; do
    gene_chromosomes_list+=("$gene:${gene_chromosomes[$gene]}")
done

# Run the process_gene function in parallel for each gene:chr pair
parallel -j 6 process_gene ::: "${gene_chromosomes_list[@]}"

echo "All intersections completed."