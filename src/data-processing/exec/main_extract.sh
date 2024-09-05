#!/bin/bash
#SBATCH --output=%j_extract.out
#SBATCH --error=%j_extract.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=32G
#SBATCH --time=01:00:00

start_time=$(date +%s)

source ~/software/init-conda
conda activate pgx

FOLDER="$1"

cd ~/PGx-Imputation-Analysis/src/data-processing
./extract_info.sh "$FOLDER"

end_time=$(date +%s)

elapsed_time=$((end_time - start_time))
minutes=$((elapsed_time / 60))
seconds=$((elapsed_time % 60))

echo "Elapsed time: $minutes minutes and $seconds seconds"