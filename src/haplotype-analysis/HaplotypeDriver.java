public class HaplotypeDriver {
    
    public static void main (String [] args){

        String masterMatch = "../results/master_stars.csv",
            all_haplotypes =  "../data/all_haplotypes.csv",
            masterVars37 = "../data/star-allele-defs/pharmvar_variants_37.csv",
            masterVars38 = "../data/star-allele-defs/pharmvar_variants_38.csv",
            result = "../results/master_coverage_new.csv"
        ;

        HaplotypeCoverage hc = new HaplotypeCoverage();
        hc.runAnalysis(masterMatch, all_haplotypes, masterVars37, masterVars38, result);
    }
}
