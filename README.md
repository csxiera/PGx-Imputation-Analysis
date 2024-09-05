## Setup

**Note:** Due to GitHub's file size limitations, the GWAS data and reference genomes are not included in this repository. Data can be downloaded from shared OneDrive folder named `Thesis Data`. <br>

**Note:** The steps for QC filtering and normalization, outlined at the end of this file, have already been completed. The resulting `_norm.vcf` files, found in the shared folder, are used in the subsequent analyses.

To prevent file path errors, store GWAS data in a directory named `PGx-Data` under the following subdirectories:

| Folder Name    | Data Types                            |
|----------------|---------------------------------------------|
| `1000g_m`      | 1000 Genomes Imputation, Modified QC        |
| `1000g_m_30x`  | 1000 Genomes 30x Imputation, Modified QC    |
| `1000g_s`      | 1000 Genomes Imputation, Standard QC        |
| `1000g_s_30x`  | 1000 Genomes 30x Imputation, Standard QC    |
| `topmed_m`     | TopMed Imputation, Modified QC              |
| `topmed_s`     | TopMed Imputation, Standard QC              |
| `unimputed_m`  | Unimputed, Modified QC                      |
| `unimputed_s`  | Unimputed, Standard QC                      |
| `raw`          | Original GWAS Data                          |
| `references`   | Human Reference Genomes                     |

Ensure a conda environment named `pgx` has been create and `bcftools`, `plink2`, `python`, `java`, and `R` are installed. (maybe samtools and vcftools?)

## VCF-to-VCF mapping (current method)

1. Navigate to `src/star-mapping/exec`.

2. Map PharmVar VCF files to GWAS data:
   - **Usage:** `sbatch main_vcf_map.sh <data-folder>`
   - **Output:** `stars_output.csv`

3. Repeat the mapping process for all data folders.

4. Merge output files into a master file:
   - **Usage:** `python merge_master.py`
   - **Output:** `master_stars.csv`
   - **Output Location:** `results`

## VCF-to-CSV mapping (previous method used in thesis)

1. Navigate to `src/star-mapping/exec`.

2. Map PharmVar CSV files to GWAS data:
   - **Usage:** `sbatch main_csv_map.sh <data-folder>`
   - **Output:** `stars_output2.csv`

4. Merge output files into a master file:
   - **Usage:** `python merge_master.py`
   - **Output:** `master_stars.csv`
   - **Output Location:** `results`

## Haplotype Analysis
1. Map star allele variants using either method above
   
2. Navigate to `src/haplotype-analysis`.

3. Compile and run haplotype coverage analysis:
   - **Usage:** `java HaplotypeDriver.java`
   - **Output:** `master_coverage.csv`
   - **Output Location:** `results`

## Other

Other useful programs can be found in the `src/data-processing` folder:

| Program Name      | Description                 | Usage                           |
|-------------------|----------------------------|---------------------------------|
| `download.sh`     | Downloads files from the imputation server   | Modify wget urls and run `sbatch download.sh <data-folder>`   |
| `unzip.sh`        | Unzips files downloaded from the imputation server   | `sbatch unzip.sh <data-folder> <password>`   |
| `merge_cores.sh`  | Removes non-core alleles from PharmVar VCF data and merges core alleles into a single file   | `./merge_cores.sh`   |
| `main_extract.sh` | Extracts HWE (Hardy-Weinberg Equilibrium), MAF (Minor Allele Frequency), and MISS (missingness) values for each variant   | `sbatch main_extract <data-folder>`   |

## Quality Control Filtering & Normalization
