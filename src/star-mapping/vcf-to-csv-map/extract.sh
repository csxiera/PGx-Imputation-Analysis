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

#echo "Passed folder is '$folder'"
#echo "Data directory is '$data_dir'"
#echo "Output directory is '$output_dir'"

cd "$data_dir"

current_directory=$(pwd)
echo "Current directory for extract: $current_directory"

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
awk -F ',' 'NR>1 {print $5}' "$csv_file" | while read pos; do
    bcftools view -H -i "POS=$pos" "$vcf_file" >> "$output_vcf"
done

awk -F ',' 'NR>1 {print $3}' "$csv_file" | while read rsid; do
    bcftools view -H -i "ID=$rsid" "$vcf_file" >> "$output_vcf"
done

# Step 3: Sort output VCF and remove duplicates
bcftools sort "$output_vcf" | bcftools norm -d all - | bcftools view -h - > "$temp_vcf"
mv "$temp_vcf" "$output_vcf"

# Step 4: Normalize VCF
bcftools norm -d all "$output_vcf" > "$temp_vcf"

# Step 5: Query normalized VCF for CHROM and POS fields
bcftools query -f '%CHROM,%POS\n' "$temp_vcf" > "$output_csv"

# Remove the intermediate VCF files
rm "$output_vcf" "$temp_vcf"

echo "Variants Extracted"

