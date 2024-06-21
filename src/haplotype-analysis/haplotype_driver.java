public class HaplotypeDriver {
    
    public static void main (String [] args){

        String masterMatch = "C:/Users/court/OneDrive/Desktop/master_stars.csv",
            all_haplotypes =  "C:/Users/court/OneDrive/Desktop/UCalgary/Year 4/MDSC 508 - Honours Thesis & Research Communication/Excel Files/Coverage Analysis Files/all_haplotypes.csv",
            masterVars37 = "C:/Users/court/OneDrive/Desktop/UCalgary/Year 4/MDSC 508 - Honours Thesis & Research Communication/Excel Files/Coverage Analysis Files/pharmvar_variants_37.csv",
            masterVars38 = "C:/Users/court/OneDrive/Desktop/UCalgary/Year 4/MDSC 508 - Honours Thesis & Research Communication/Excel Files/Coverage Analysis Files/pharmvar_variants_38.csv",
            result = "C:/Users/court/OneDrive/Desktop/master_coverage_new.csv"
        ;

        HaplotypeCoverage hc = new HaplotypeCoverage();
        hc.runAnalysis(masterMatch, all_haplotypes, masterVars37, masterVars38, result);
    }
}
