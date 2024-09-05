#!/bin/bash
#SBATCH --output=%j_norm.out
#SBATCH --error=%j_norm.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=16G
#SBATCH --time=02:00:00

# Activate conda environment
source ~/software/init-conda
conda activate pgx

# Move to directory with normalization script
cd ~/PGx-Imputation-Analysis/src/preimputation/filter-norm

# Run normalization script with data folder as argument
FOLDER="$1"
./norm37.sh "$FOLDER"



