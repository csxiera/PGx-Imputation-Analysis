#!/bin/bash
#SBATCH --output=%j_coverage.out
#SBATCH --error=%j_coverage.err
#SBATCH --nodes=1
#SBATCH --mem=8G
#SBATCH --time=00:15:00

# Activate conda environment
source ~/software/init-conda
conda activate pgx

# Move to directory with stars script
cd ~/PGx-Imputation-Analysis/src/haplotype-analysis

javac *.java
java HaplotypeDriver