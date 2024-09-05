#!/bin/bash
#SBATCH --output=%j_map.out
#SBATCH --error=%j_map.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=64G
#SBATCH --time=1:00:00

source ~/software/init-conda
conda activate pgx

FOLDER="$1"

# Run vcf_intersect.sh script
~/PGx-Imputation-Analysis/src/star-mapping/vcf-to-vcf-map/vcf_intersect.sh "$FOLDER"

# Remove unnecessary data from intersection results
cd ~/PGx-Imputation-Analysis/data/output-files
~/PGx-Imputation-Analysis/src/star-mapping/vcf-to-vcf-map/clean_data.sh "$FOLDER"

# Combine results into single file
cd "$FOLDER"
cat *_overlap.txt > overlap_all.txt

# Extract star allele info from mapped variants
python ~/PGx-Imputation-Analysis/src/star-mapping/vcf-to-vcf-map/extract_vars.py "$FOLDER"
