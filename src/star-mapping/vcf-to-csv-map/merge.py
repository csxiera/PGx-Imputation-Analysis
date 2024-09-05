import os
import csv
import sys

def merge_csv_files(input_file_dir, folder, output_file, csv_type):
    # Map the dataset directories to the dataset names
    dataset_names = {
        "1000g_s_30x": "1000G 30x Standard",
        "1000g_m_30x": "1000G 30x Modified",
        "1000g_s": "1000G Standard",
        "1000g_m": "1000G Modified",
        "topmed_s": "Topmed Standard",
        "topmed_m": "Topmed Modified",
        "unimputed_s": "Unimputed Standard",
        "unimputed_m": "Unimputed Modified",
        "raw": "Raw"
    }

    # Get dataset name based on folder
    dataset_name = dataset_names.get(folder, "Unknown Dataset")

    # Get list of CSV files in the current directory
    csv_files = [os.path.join(input_file_dir, file) for file in os.listdir(input_file_dir) if file.endswith(csv_type)]

    all_rows = []
    header = ["allele", "gene", "rsid", "chr", "pos", "dataset"]

    # Iterate over each CSV file and append its content to all_rows
    for file_name in csv_files:
        with open(file_name, 'r', newline='') as csv_file:
            reader = csv.reader(csv_file)
            for row in reader:
                row.append(dataset_name)
                all_rows.append(row)

    # Write the merged data to a single CSV file
    output_file_path = os.path.join(input_file_dir, output_file)
    with open(output_file_path, 'w', newline='') as merged_file:
        writer = csv.writer(merged_file)
        writer.writerow(header)
        writer.writerows(all_rows)

    print("Merged CSV file saved successfully.")

    with open(output_file_path, 'r') as file:
        lines = file.readlines()

    with open(output_file_path, 'w') as file:
        for line in lines:
            if line.startswith("CHROM"):
                file.write(line)
                break

        for line in lines:
            if not line.startswith("CHROM"):
                file.write(line)

    # Delete all intermediate files in input directory
    for file_name in os.listdir(input_file_dir):
        if file_name.endswith(csv_type):
            file_path = os.path.join(input_file_dir, file_name)
            os.remove(file_path)
            print(f"Deleted file: {file_path}")

if __name__ == "__main__":
    if len(sys.argv) != 4:
        print("Usage: python script.py <output_file> <folder> <.csv type>")
        sys.exit(1)

    output_file_name = sys.argv[1]
    folder = sys.argv[2]
    csv_type = sys.argv[3]

    script_dir = os.path.dirname(os.path.abspath(__file__))
    base_dir = os.path.abspath(os.path.join(script_dir, '..', '..', '..', '..'))

    input_file_dir = os.path.join(base_dir, 'PGx-Imputation-Analysis', 'data', 'output-files', folder)

    merge_csv_files(input_file_dir, folder, output_file_name, csv_type)