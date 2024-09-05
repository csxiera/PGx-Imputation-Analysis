#!/bin/bash

# Check if a directory name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

folder="$1"
output_dir=~/PGx-Data/"$folder"
reference_genome=~/PGx-Data/references/Homo_sapiens.GRCh37.dna.primary_assembly.fa

# List of chromosomes
chromosomes=(7 10 12 13 19 22)

# Normalize a single vcf file
normalize_vcf() {
    local chr="$1"
    local input_vcf="${output_dir}/chr${chr}_filtered.vcf.gz"
    local output_vcf="${output_dir}/chr${chr}_norm.vcf.gz"

    bcftools +fixref "${input_vcf}" -Oz -o chr${chr}_fixref.vcf.gz  -- -f "${reference_genome}" -m top
    bcftools norm -f "${reference_genome}" -m -any "chr${chr}_fixref.vcf.gz" -O z -o "${norm_vcf}"

    echo "Normalized chromosome ${chr}"
}

# Export the function so that parallel can use it
export -f normalize_vcf

# Use GNU Parallel to run tasks in parallel
parallel -j 6 normalize_vcf ::: "${chromosomes[@]}"

