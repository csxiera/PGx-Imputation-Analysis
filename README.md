## Setup

**Note:** Due to GitHub's file size limitations, the GWAS data and reference genomes are not included in this repository. Data can be downloaded from shared OneDrive folder named `Thesis Data`. <br>

**Note:** The steps for QC filtering and normalization, outlined at the end of this file, have already been completed. The resulting `norm.vcf` files, found in the shared folder, are used in the subsequent analyses.

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

Both `PGx-Data` and `PGx-Imputation-Analysis` directories must be in the same main/home folder

Ensure a conda environment named `pgx` has been create and `bcftools`, `plink2`, `python`, and `java` are installed. To use a different conda environment, the conda activation line in all executable batch scripts must be changed:<br>

&emsp;&ensp;&nbsp;`source ~/software/init-conda`<br>
--> `conda activate <env-name>`

**Note:** All user-executed batch scripts are located in the `src/exec` subfolder. Other supporting programs and scripts are executed by these main scripts.

## VCF-to-VCF mapping (current method)

1. Navigate to `src/exec`.

2. Map PharmVar VCF files to GWAS data:
   - **Usage:** `sbatch main_vcf_map.sh <data-folder>`
   - **Output:** `stars_vcf_map.csv`

3. Repeat the mapping process for all data folders.

4. Merge output files into a master file:
   - **Usage:** `python main_merge.py`
   - **Output:** `master_stars.csv`
   - **Output Location:** `results`


## VCF-to-CSV mapping (previous method used in thesis)

**Note:** This method is considerably slower and memory intensive than the previous one. The memory and time allocated for the job may need to be adjusted in the `main_csv_map.sh` script.

1. Navigate to `src/exec`.

2. Map PharmVar CSV files to GWAS data:
   - **Usage:** `sbatch main_csv_map.sh <data-folder>`
   - **Output:** `stars_csv_map.csv`

3. Repeat the mapping process for all data folders.

4. Merge output files into a master file:
   - **Usage:** `python main_merge.py`
   - **Output:** `master_stars.csv`
   - **Output Location:** `results`


## Haplotype Analysis

1. Map star allele variants using either method above
   
2. Navigate to `src/exec`.

3. Run haplotype coverage analysis:
   - **Usage:** `sbatch main_coverage.sh`
   - **Output:** `master_coverage.csv`
   - **Output Location:** `results`

  
## Other

Other useful programs in the `src/exec` folder:

| Program Name      | Description                 | Usage                           |
|-------------------|----------------------------|---------------------------------|
| `download.sh`     | Downloads files from the imputation server   | Modify wget urls and run `sbatch download.sh <data-folder>`   |
| `unzip.sh`        | Unzips files downloaded from the imputation server   | `sbatch unzip.sh <data-folder> <password>`   |
| `merge_cores.sh`  | Removes non-core alleles from PharmVar VCF data and merges core alleles into a single file   | `./merge_cores.sh`   |
| `main_extract.sh` | Extracts HWE (Hardy-Weinberg Equilibrium), MAF (Minor Allele Frequency), and MISS (missingness) values for each variant   | `sbatch main_extract <data-folder>`   |


## Quality Control Filtering & Normalization

### Pre-imputation: 

1. General QC filtering procedure:<br>
   - Get variant information  
      - **Ex.** `plink2 --bfile gsa2018_clozinID4 --freq --out maf`
   - Keep individuals who passed QC in clozin study  
      - **Ex.** `plink2 --bfile gsa2018_clozinID4 --keep keep_ind.txt --make-bed --out g_qc1`<br>
   - Remove high SNP missingness  
      - **Ex.** `plink2 --bfile g_qc1 --geno 0.1 --make-bed --out g_qc2`

2. Standard QC filtering procedure (applied after general QC):
   - Remove MAF < 0.01  
      - **Ex.** `plink2 --bfile g_qc2 --maf 0.01 --make-bed --out s_qc3`
   - Check for and remove Hardy-Weinberg deviations  
      - **Ex.** `plink2 --bfile s_qc3 --hardy midp --hwe 10e-4 midp --make-bed --out s_qc4`
   - Exclude sex chromosomes  
      - **Ex.** `plink2 --bfile s_qc4 --autosome --make-bed --out s_qc5`
   - Create frequency file  
      - **Ex.** `plink2 --bfile s_qc5 --freq --out f_qc5`

3. Modified QC filtering procedure (applied after general QC):<br>
   - Exclude sex chromosomes  
      - **Ex.** `plink2 --bfile g_qc2 --autosome --make-bed --out m_qc3`<br>
   - Create frequency file  
      - **Ex.** `plink2 --bfile m_qc3 --freq --out f_qc3`

4. Convert to VCF and split by chromosome.
     - **Note**: Filtered files should follow the `chr${chr}_filtered.vcf.gz` naming convention
   
5. Normalize and split multialleleics.
      - **Usage:** `sbatch main_norm37.sh <data-folder>`
      - **Output:** `norm.vcf.gz` files for each chromosome 

### Post-imputation:

   1. Navigate to `src/exec`

   2. Apply rsq filter to imputed data:
      - **Usage:** `sbatch main_filter.sh <data-folder>`
      - **Output:** `filtered.vcf.gz` files for each chromosome

   3. Normalize filtered data:
      - **Usage:** `sbatch main_norm<#>.sh <data-folder>`
      - **Output:** `norm.vcf.gz` files for each chromosome
      - **Ex.** `sbatch main_norm38.sh topmed_s`

**Note:** Normalization can be performed using either GRCh37 or GRCh38 reference builds.
