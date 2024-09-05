#!/bin/bash

# Change to the pharmvar directory
cd ~/PGx-Imputation-Analysis/data/star-allele-defs

# List of genes
genes=("CYP2B6" "CYP2C9" "CYP2C19" "CYP2D6" "CYP3A4" "CYP3A5" "CYP4F2" "NUDT15" "SLCO1B1")

# Loop over the genes
for gene in "${genes[@]}"
do
    # Remove all non-core allele VCF files in the gene directory
    find $gene/GRCh38 -name '*.*.vcf' -delete

    # Get a list of all core allele VCF files in the gene directory
    vcf_files=$(ls $gene/GRCh38/*[^.].vcf)

    # Use bcftools concat to merge the VCF files and output to a new file
    bcftools concat $vcf_files -Ov -o $gene/${gene}_corealleles.vcf

    # Zip core allele vcf file
    bgzip $gene/${gene}_corealleles.vcf > $gene/${gene}_corealleles.vcf.gz
done