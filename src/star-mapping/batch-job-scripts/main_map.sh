#!/bin/bash
#SBATCH --output=%j_intersect.out
#SBATCH --error=%j_intersect.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=50G
#SBATCH --time=1:00:00

# Activate conda environment
source ~/software/init-conda
conda activate pgx

# Move to directory with intersect script
cd ~/mdsc508

# Run vcf_intersect.sh script
FOLDER="$1"
./vcf_intersect.sh "$FOLDER"

# Remove unnecessary data from intersection results
./cut_info.sh "$FOLDER"

# Combine results into single file
cd "$FOLDER"
cat *_overlap.txt > overlap_all.txt

# Extract star allele info from mapped variants
cd ..
python extract_vars.py "$FOLDER"
