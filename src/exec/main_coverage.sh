#!/bin/bash
#SBATCH --output=%j_coverage.out
#SBATCH --error=%j_coverage.err
#SBATCH --nodes=1
#SBATCH --mem=8G
#SBATCH --time=00:15:00

# Activate conda environment
source ~/software/init-conda
conda activate pgx

# Check if the argument (vcf-to-vcf or vcf-to-csv) is provided
if [ "$#" -ne 1 ]; then
  echo "Usage: sbatch main_coverage.sh <vcf-to-vcf|vcf-to-csv>"
  exit 1
fi

# Move to directory with stars script
cd ~/PGx-Imputation-Analysis/src/haplotype-analysis

javac *.java
java HaplotypeDriver "$1"