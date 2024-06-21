#!/bin/bash
#SBATCH --output=%j_filter.out
#SBATCH --error=%j_filter.err
#SBATCH --partition=cpu2019
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=32000M
#SBATCH --time=03:00:00

# Activate conda environment
source ~/software/init-conda
conda activate pgx

# Move to directory with filter script
cd ~/mdsc508

# Run filter script with data folder as argument
FOLDER="$1"
./filter.sh "$FOLDER"