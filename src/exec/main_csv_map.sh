#!/bin/bash
#SBATCH --output=%j_stars.out
#SBATCH --error=%j_stars.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=100G
#SBATCH --time=12:00:00

# Activate conda environment
source ~/software/init-conda
conda activate pgx

# Move to directory with stars script
cd ~/PGx-Imputation-Analysis/src/star-mapping/vcf-to-csv-map

# Run stars script with data folder as argument
FOLDER="$1"
./find_stars.sh "$FOLDER"

# Merge star variants from each chr into single csv file
OUTPUT="stars_csv_map.csv"
python merge.py "$OUTPUT" "$FOLDER" stars.csv