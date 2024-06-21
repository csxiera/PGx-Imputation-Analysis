#!/bin/bash

# Move to directory
cd $1

# Define the list of genes
genes=("CYP2B6" "CYP2C9" "CYP2C19" "CYP2D6" "CYP3A4" "CYP3A5" "CYP4F2" "NUDT15" "SLCO1B1")

# Loop through each gene
for gene in "${genes[@]}"; do
    # Extract the first 17 fields and overwrite the original file
    awk -F'\t' '{for(i=1;i<=17;i++) printf "%s\t",$i; print ""}' ${gene}_overlap.txt > temp.txt && mv temp.txt ${gene}_overlap.txt
done
