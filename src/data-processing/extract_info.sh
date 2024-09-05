#!/bin/bash

if [ -z "$1" ]; then
    echo "Usage: $0 <folder>"
    exit 1
fi

folder="$1"
data_dir=~/PGx-Data/"$folder"
output_dir=~/PGx-Imputation-Analysis/data/output-files/"$folder"

cd "$data_dir" || { echo "Directory not found: $data_dir"; exit 1; }
current_directory=$(pwd)
echo "Current directory for extract: $current_directory"

chromosomes=(7 10 12 13 19 22)

# Function to calculate MAF, missing data rate, and HWE
extract_var_info(){
    local chr="$1"
    echo "Processing chromosome: $chr"

    input_file="$data_dir/chr${chr}_pos.txt"
    maf_output_file="$output_dir/chr${chr}_maf.csv"
    miss_output_file="$output_dir/chr${chr}_miss.csv"
    hwe_output_file="$output_dir/chr${chr}_hwe.csv"
    norm_file="$data_dir/chr${chr}_norm.vcf.gz"

    local temp_files=()

    while read -r position; do
        position="${position%"${position##*[![:space:]]}"}"
        echo "Processing position: $position"

        # Calculate MAF
        plink2 --vcf "$norm_file" --freq --chr "$chr" --from-bp "$position" --to-bp "$position" --out freq_chr"$chr"_"$position"
        awk -v pos="$position" 'BEGIN { print "CHROM,POS,REF,ALT,ALT_FREQS" } { print $1","pos","$3","$4","$5 }' freq_chr"$chr"_"$position".afreq >> "$maf_output_file"

        # Calculate missing data rate
        plink2 --vcf "$norm_file" --missing --chr "$chr" --from-bp "$position" --to-bp "$position" --out miss_chr"$chr"_"$position"
        awk -v pos="$position" 'BEGIN { printf "CHROM,POS,F_MISS\n" } { printf "%s,%s,%s\n", $1, pos, $5 }' miss_chr"$chr"_"$position".vmiss >> "$miss_output_file"

        # Calculate HWE
        plink2 --vcf "$norm_file" --hardy --chr "$chr" --from-bp "$position" --to-bp "$position" --out hwe_chr"$chr"_"$position"
        awk -v pos="$position" 'BEGIN { print "CHROM,POS,A1,AX,P" } { print $1","pos","$3","$4","$10 }' hwe_chr"$chr"_"$position".hardy >> "$hwe_output_file"

        # Collect temp files for deletion
        temp_files+=(freq_chr"$chr"_"$position".* miss_chr"$chr"_"$position".* hwe_chr"$chr"_"$position".*)
    done <$input_file

    # Clean up MAF output
    sed -i '2,$s/^#CHROM.*//' "$maf_output_file"
    sed -i '2,$s/^CHROM.*//' "$maf_output_file"
    sed -i '/^$/d' "$maf_output_file"

    # Clean up missing data output
    sed -i '2,$s/^#CHROM.*//' "$miss_output_file"
    sed -i '2,$s/^CHROM.*//' "$miss_output_file"
    sed -i '/^$/d' "$miss_output_file"

    # Clean up HWE output
    sed -i '2,$s/^#CHROM.*//' "$hwe_output_file"
    sed -i '2,$s/^CHROM.*//' "$hwe_output_file"
    sed -i '/^$/d' "$hwe_output_file"

    # Remove temporary files
    rm "${temp_files[@]}"
}

export -f extract_var_info

# Run the combined process in parallel for each chromosome
parallel -j 6 extract_var_info ::: "${chromosomes[@]}"