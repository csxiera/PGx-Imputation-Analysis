GWAS data is stored in a seperated directory named "PGx-Data" due to file size constraints on Github
To avoid file path errors, store GWAS data within a PGx-Data directory with the following folder names:
  1. 1000g_m
  2. 1000g_m_30x
  3. 1000g_s
  4. 1000g_s_30x
  5. topmed_m
  6. topmed_s
  7. unimputed_m
  8. unimputed_s
  9. raw

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
