## Setup

**Note:** Due to GitHub's file size limitations, the GWAS data is not included in this repository. Data can be downloaded from shared OneDrive folder named `Thesis Data` <br>

To prevent file path errors, store GWAS data in a directory named `PGx-Data` with the following folder names:

| Folder Name    | Data Treatment                              |
|----------------|---------------------------------------------|
| `1000g_m`      | 1000 Genomes Imputation, Modified QC        |
| `1000g_m_30x`  | 1000 Genomes 30x Imputation, Modified QC    |
| `1000g_s`      | 1000 Genomes Imputation, Standard QC        |
| `1000g_s_30x`  | 1000 Genomes 30x Imputation, Standard QC    |
| `topmed_m`     | TopMed Imputation, Modified QC              |
| `topmed_s`     | TopMed Imputation, Standard QC              |
| `unimputed_m`  | Unimputed, Modified QC                      |
| `unimputed_s`  | Unimputed, Standard QC                      |
| `raw`          | Original                                    |

Ensure workspace has `bcftools`, `plink2`, `python`, `java`, and `R` are installed (maybe samtools and vcftools?)

## To run VCF-to-VCF based analysis (current method):

1. Navigate to `src/star-mapping/exec`.

2. Map PharmVar VCF files to GWAS data:
   - **Usage:** `sbatch main_map.sh <data-folder>`
   - **Output:** `stars_output.csv`

3. Repeat the mapping process for all data folders.

4. Merge output files into a master file:
   - **Usage:** `python merge_master.py`
   - **Output:** `master_stars.csv`
   - **Output Location:** `results`

5. Navigate to `src/haplotype-analysis`.

6. Run haplotype coverage analysis:
   - **Usage:** `java HaplotypeDriver.java`
   - **Output:** `master_coverage.csv`
   - **Output Location:** `results`

## To run VCF-to-CSV based analysis (previous method used in thesis):

1. Navigate to `src/star-mapping/exec`.

2. Map PharmVar CSV file to GWAS data:
   - **Usage:** `sbatch main_stars.sh <data-folder>`
   - **Output:** 

3. Merge chromosome files together:
   - **Usage:** `python3 merge.py <output-csv> <data-folder> <??pgx.csv??>`

4. Export the output CSV and add column headers.
