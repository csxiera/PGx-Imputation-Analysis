GWAS data is stored in a seperated directory named "PGx-Data" due to file size constraints on Github
To avoid file path errors, store GWAS data within a PGx-Data directory using following subfolder names:
  1. 1000g_m &emsp;&emsp;&emsp;-> 1000 Genomes Imputation, Modified QC
  2. 1000g_m_30x &emsp;&emsp;-> 1000 Genomes 30x Imputation, Modified QC
  3. 1000g_s &emsp;&emsp;&emsp;-> 1000 Genomes Imputation, Standard QC
  4. 1000g_s_30x &emsp;&emsp;-> 1000 Genomes 30x Imputation, Standard QC
  5. topmed_m &emsp;&emsp;&emsp;-> TopMed Imputation, Modified QC
  6. topmed_s &emsp;&emsp;&emsp;-> TopMed Imputation, Standard QC
  7. unimputed_m &emsp;&emsp;-> Unimputed, Modified QC
  8. unimputed_s &emsp;&emsp;-> Unimputed, Standard QC
  9. raw &emsp;&emsp;&emsp;&emsp;-> Original Data

To run VCF-to-VCF based analysis (current method):
  1. Navigate to src>star-mapping>exec
  2. Run main_intersect.sh to map PharmVar vcf files to imputed data
       - Usage: sbatch main_map.sh <imputation-data-folder>
       - Output: stars_output.csv
  3. Repeat for all imputation data folders
  4. Run merge_master.py to merge all output.csv files into master.csv
       - Usage: python merge_master.py
       - Output: master_stars.csv
       - Output Location: ../results
  5. Run haplotype coverage analysis
       - Usage: java HaplotypeDriver.java
       - Output: master_coverage.csv
       - Output Location: ../results

To run VCF-to-TXT based analysis (previous method used in thesis):
  1. Navigate to src>star-mapping>exec
  2. Run main_stars.sh to map PharmVar txt file to imputed data
       - Usage: sbatch main_stars.sh <imputation-data-folder>
       - Output: 
! -> 3. Merge chr files together
       - Usage: python3 merge.py <output-csv> <imputation-data-folder> ??pgx.csv??
  4. Export output-csv and add column headers
