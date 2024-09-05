#!/bin/bash

# Check if correct number of arguments are passed
if [ "$#" -ne 2 ]; then
    echo "Usage: $0 <chromosome_number> <directory>"
    exit 1
fi

# Define directories
chr="$1"
folder="$2"
data_dir=~/PGx-Data/"$folder"
star_dir=~/PGx-Imputation-Analysis/data/star-allele-defs
output_dir=~/PGx-Imputation-Analysis/data/output-files/"$folder"

cd "$data_dir"

# Input file names
vcf_file="${data_dir}/chr${chr}_norm.vcf.gz"
csv_file="${star_dir}/chr_${chr}.csv"

# Output file names
output_vcf="${output_dir}/result_${chr}.vcf"
temp_vcf="${output_dir}/temp_${chr}.vcf"
output_csv="${output_dir}/chr_${chr}_matches.csv"

# Step 1: Extract header from VCF file
bcftools view -h "$vcf_file" > "$output_vcf"

# Step 2: Filter VCF based on positions or rsid from CSV and append to output VCF
awk -F ',' 'NR>1 {print $5}' "$csv_file" | while read -r pos; do
    bcftools view -H -i "POS=$pos" "$vcf_file" >> "$output_vcf"
done

awk -F ',' 'NR>1 {print $5}' "$csv_file" | while read -r pos; do
    bcftools view -H -i "POS=$pos" "$vcf_file" >> "$output_vcf"
done

# Step 3: 
bcftools sort "$output_vcf" | bcftools norm -d all - > "$temp_vcf"

# Step 5: Query normalized VCF for CHROM and POS fields
bcftools query -f '%CHROM,%POS\n' "$temp_vcf" > "$output_csv"

# Remove the intermediate VCF files
rm "$output_vcf" "$temp_vcf"

echo "Variants mapped & extracted"

