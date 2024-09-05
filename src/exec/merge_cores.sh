#!/bin/bash

# Check if the build number is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <build_number>"
    exit 1
fi

build=$1

# Validate build number
if [ "$build" != "37" ] && [ "$build" != "38" ]; then
    echo "Invalid build number. Please use 37 or 38."
    exit 1
fi

# Map build number to directory name
if [ "$build" == "37" ]; then
    build_dir="GRCh37"
elif [ "$build" == "38" ]; then
    build_dir="GRCh38"
fi

cd ~/PGx-Imputation-Analysis/data/star-allele-defs

genes=("CYP2B6" "CYP2C9" "CYP2C19" "CYP2D6" "CYP3A4" "CYP3A5" "CYP4F2" "NUDT15" "SLCO1B1")

# Loop over the genes
for gene in "${genes[@]}"
do
    # Remove all non-core allele VCF files in the gene directory
    find "$gene/$build_dir" -name '*.*.vcf' -delete

    # Get a list of all core allele VCF files in the gene directory
    vcf_files=$(ls "$gene/$build_dir"/*[^.].vcf)

    # Use bcftools concat to merge the VCF files and output to a new file
    bcftools concat $vcf_files -Ov -o $gene/${gene}_corealleles${build}.vcf

    # Zip core allele vcf file
    bgzip -f $gene/${gene}_corealleles${build}.vcf > $gene/${gene}_corealleles${build}.vcf.gz
done