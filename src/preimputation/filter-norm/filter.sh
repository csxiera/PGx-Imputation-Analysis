#!/bin/bash

# Check if a directory name is provided
if [ -z "$1" ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

folder="$1"
output_dir=~/PGx-Data/"$folder"


# List of chromosomes
chromosomes=(7 10 12 13 19 22)

# Filter a single vcf file
filter_vcf() {
    local chr="$1"
    local input_vcf="${output_dir}/chr${chr}.dose.vcf.gz"
    local output_vcf="${output_dir}/chr${chr}_filtered.vcf.gz"

    bcftools filter -e 'INFO/R2<0.5' "${input_vcf}" -O z -o "${output_vcf}"

    echo "Processed chromosome ${chr}"
}

# Export the function so that parallel can use it
export -f filter_vcf

# Run tasks in parallel with 6 jobs at a time
parallel -j 6 filter_vcf ::: "${chromosomes[@]}"

