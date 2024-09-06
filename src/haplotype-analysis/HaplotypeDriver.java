import java.nio.file.Path;
import java.nio.file.Paths;

public class HaplotypeDriver {
    
    public static void main (String [] args){

        String fileType = args[0];
        Path baseDir = Paths.get("").toAbsolutePath().normalize().getParent().getParent().getParent();
        System.out.println("Base Directory: " + baseDir.toString());

        Path masterMatch;
        Path result;
        if (fileType.equals("vcf-to-vcf")) {
            masterMatch = baseDir.resolve("PGx-Imputation-Analysis/results/master_stars_vcf_to_vcf.csv");
            result = baseDir.resolve("PGx-Imputation-Analysis/results/master_coverage_vcf_to_vcf.csv");
        } else if (fileType.equals("vcf-to-csv")) {
            masterMatch = baseDir.resolve("PGx-Imputation-Analysis/results/master_stars_vcf_to_csv.csv");
            result = baseDir.resolve("PGx-Imputation-Analysis/results/master_coverage_vcf_to_csv.csv");
        } else {
            System.out.println("Invalid argument. Please use 'vcf-to-vcf' or 'vcf-to-csv'.");
            return;
        }

        Path all_haplotypes = baseDir.resolve("PGx-Imputation-Analysis/data/star-allele-defs/all_haplotypes.csv");
        Path masterVars37 = baseDir.resolve("PGx-Imputation-Analysis/data/star-allele-defs/build37/pharmvar_variants_37.csv");
        Path masterVars38 = baseDir.resolve("PGx-Imputation-Analysis/data/star-allele-defs/build38/pharmvar_variants_38.csv");


        HaplotypeCoverage hc = new HaplotypeCoverage();
        hc.runAnalysis(masterMatch.toString(), all_haplotypes.toString(), masterVars37.toString(), masterVars38.toString(), result.toString());
    }
}
