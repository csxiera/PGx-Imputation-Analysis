#!/bin/bash
#SBATCH --output=%j_unzip.out
#SBATCH --error=%j_unzip.err
#SBATCH --nodes=1
#SBATCH --cpus-per-task=6
#SBATCH --mem=32G
#SBATCH --time=01:00:00

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 DIRECTORY PASSWORD"
    exit 1
fi

FOLDER="$1"
PASSWORD="$2"

data_dir=~/PGx-Data/"$FOLDER"
cd "$data_dir" || { echo "Directory not found: $data_dir"; exit 1; }

MAX_JOBS=6

unzip_file() {
    local file="$1"
    unzip -P "$PASSWORD" "$file" -d .
}

export PASSWORD
export -f unzip_file

find . -maxdepth 1 -type f -name '*.zip' | parallel -j "$MAX_JOBS" unzip_file

