#!/bin/bash

if [ "$#" -ne 1 ]; then
    echo "Usage: $0 <directory>"
    exit 1
fi

#source_dir=~/PGx-Imputation-Analysis/data/star-allele-defs/
data_dir=~/PGx-Data/"$1"

#cp "$source_dir"/*.csv "$data_dir"
######cp *.csv ~/PGx-Data/"$directory"

chromosomes=(7 10 12 13 19 22)

# Loop through each chromosome number
find_stars(){
    local chr="$1"
    local dir="$2"

    echo "Directory received in find_stars function: $dir"

    # Step 1: Extract all variants from VCF present in '*' list
    ./extract.sh "$chr" "$dir"

    wait

    # Step 2: Combine extracted variants with associated '*'s
    python get_stars.py "$chr" "$dir"

    wait

    # Step 3: Combine all '*'s for each position into 1 row each
    python condense.py "$chr" "$dir"

    echo "Stars identified for chr '$chr'"
}

export -f find_stars

# Run the find_stars function in parallel for each chromosome
parallel -j 6 find_stars {} "$data_dir" ::: "${chromosomes[@]}"

cd "$data_dir"

# Remove all .csv files except for those ending with pgx.csv
find . -maxdepth 1 -type f -name "*.csv" ! -name "*pgx.csv" -exec rm -f {} +
