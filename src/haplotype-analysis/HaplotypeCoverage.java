import java.io.File;
import java.io.BufferedReader;
import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.List;

public class HaplotypeCoverage {

public HaplotypeCoverage(){}

    public void runAnalysis (String master, String haplotypes, String vars37, String vars38, String resultOut) {
        
        String matchFile = master;
        String haplotypeFile = haplotypes;
        String vars37File = vars37;
        String vars38File = vars38;
        String resultFile = resultOut;

        HashMap<String, HashMap<String, List<Integer>>> dataTables = new HashMap<>();
        dataTables.put("Raw", new HashMap<String, List<Integer>>());
        dataTables.put("Unimputed Modified", new HashMap<String, List<Integer>>());
        dataTables.put("Unimputed Standard", new HashMap<String, List<Integer>>());
        dataTables.put("1000G Modified", new HashMap<String, List<Integer>>());
        dataTables.put("1000G Standard", new HashMap<String, List<Integer>>());
        dataTables.put("1000G 30x Modified", new HashMap<String, List<Integer>>());
        dataTables.put("1000G 30x Standard", new HashMap<String, List<Integer>>());
        dataTables.put("Topmed Modified", new HashMap<String, List<Integer>>());
        dataTables.put("Topmed Standard", new HashMap<String, List<Integer>>());

        HashMap<String, List<Integer>> vars37Table = new HashMap<>();
        HashMap<String, List<Integer>> vars38Table = new HashMap<>(); 
        ArrayList<String> haplotypeList = new ArrayList<>();

        //-------------------------------- Read variant tables to hashmaps ---------------------------------------

            // Read vars37 file
        try (BufferedReader vars37reader = new BufferedReader(new FileReader(vars37File))) {
            String header = vars37reader.readLine();
        
            String line;
            while ((line = vars37reader.readLine()) != null) {
                String[] columns = line.split(",");
                String haplotypeName = columns[0].trim();
                int position = Integer.parseInt(columns[4].trim());

                if (!vars37Table.containsKey(haplotypeName)) {
                    vars37Table.put(haplotypeName, new ArrayList<>());
                }
                
                // Add position to the list of positions for the haplotype
                vars37Table.get(haplotypeName).add(position);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        // Read vars38 file
        try (BufferedReader vars38reader = new BufferedReader(new FileReader(vars38File))) {
            String header = vars38reader.readLine();

            String line;
            while ((line = vars38reader.readLine()) != null) {
                String[] columns = line.split(",");
                String haplotypeName = columns[0].trim();
                int position = Integer.parseInt(columns[4].trim());

                if (!vars38Table.containsKey(haplotypeName)) {
                    vars38Table.put(haplotypeName, new ArrayList<>());
                }
                
                // Add position to the list of positions for the haplotype
                vars38Table.get(haplotypeName).add(position);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        try (BufferedReader br = new BufferedReader(new FileReader(haplotypeFile))) {
            String header = br.readLine();

            String line;
            while ((line = br.readLine()) != null) {
                String hap = line;
                hap = hap.replaceAll("^\"|\"$", "");
                // Assuming your CSV file has no headers and just one column
                haplotypeList.add(hap);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        /*
        for (Map.Entry<String, List<Integer>> entry : vars37Table.entrySet()) {
            String haplotypeName = entry.getKey();
            List<Integer> positions = entry.getValue();
            System.out.println("Haplotype: " + haplotypeName + ", Positions: " + positions);
        }
        */

        //-------------------------------- Read match file to hashmap ---------------------------------------

        try (BufferedReader matchReader = new BufferedReader(new FileReader(matchFile))) {
            String header = matchReader.readLine();

            String line;
            while ((line = matchReader.readLine()) != null) {
                //System.out.println("Reading line: " + line);
                String[] columns = line.split(",");
                String starAllele = columns[0].trim();
                starAllele = starAllele.replaceAll("^\"|\"$", "");
                String gene = columns[1].trim();
                gene = gene.replaceAll("^\"|\"$", "");
                String chromosome = columns[3].trim();
                int position = Integer.parseInt(columns[4].trim());
                String dataset = columns[5].trim();
                dataset = dataset.replaceAll("^\"|\"$", "");

                // Generate haplotype name by concatenating gene and starAllele
                String haplotypeName = gene + starAllele;

                // Get the inner HashMap based on the dataset value
                HashMap<String, List<Integer>> innerMap = dataTables.get(dataset);

                // Check if haplotype exists in the inner map
                if (!innerMap.containsKey(haplotypeName)) {
                    innerMap.put(haplotypeName, new ArrayList<>());
                }
                
                // Add position to the list of positions for the haplotype in the inner map
                innerMap.get(haplotypeName).add(position);
            }
        } catch (IOException e) {
            e.printStackTrace();
        }

        /*
        for (Map.Entry<String, HashMap<String, List<Integer>>> entry : dataTables.entrySet()) {
            String dataset = entry.getKey();
            System.out.println("Dataset: " + dataset);

            HashMap<String, List<Integer>> innerMap = entry.getValue();
            for (Map.Entry<String, List<Integer>> innerEntry : innerMap.entrySet()) {
                String haplotype = innerEntry.getKey();
                List<Integer> positions = innerEntry.getValue();
                System.out.println("Haplotype: " + haplotype + ", Positions: " + positions);
            }
            System.out.println();
        }
        */

        //-------------------------------- Write haplotype coverage for each array ---------------------------------------

        String filePath = resultFile;

        // Add haplotype keys with empty lists for haplotypes that were not identified in the dataset
        for (String dataName : dataTables.keySet()) {
            HashMap<String, List<Integer>> dataHashMap = (HashMap<String, List<Integer>>) dataTables.get(dataName);
            System.out.println();
            System.out.println("Dataset: " + dataName);

            for (String haplotype : haplotypeList) {
                System.out.println("Checking for: " + haplotype);
                if (!dataHashMap.containsKey(haplotype)) {
                    // If haplotype not in datas's hash map, add it with an empty list
                    dataTables.get(dataName).put(haplotype, new ArrayList<>());
                }
            }
        }

        try {
            FileWriter writer = new FileWriter(filePath);
            writer.write("Dataset,Gene,Haplotype,Coverage,Variant(s) Present,Variant(s) Missing\n");

            // Compare array tables to comparison table
            for (String dataName : dataTables.keySet()) {
                HashMap<String, List<Integer>> dataVariants = dataTables.get(dataName);
                HashMap<String, List<Integer>> sourceTable;

                if (dataName.equals("Raw") || dataName.equals("Unimputed Modified") || dataName.equals("Unimputed Standard")) {
                    sourceTable = vars37Table;
                } else {
                    sourceTable = vars38Table;
                }                

                for (String haplotypeName : dataVariants.keySet()) {
                    String geneName = haplotypeName.split("\\*")[0];
                    List<Integer> variants = dataVariants.get(haplotypeName);
                    List<Integer> sourceVariants = sourceTable.get(haplotypeName);
            
                    String variantsPresent = "";
                    String variantsMissing = "";
                    String coverage;

                    // Check if all necessary variants are present in array
                    boolean allVariantsPresent = true;
                    if (sourceVariants != null) {
                        for (int snp : sourceVariants) {
                            if (variants.contains(snp)) {
                                variantsPresent += snp+ "; ";
                            } 
                            else {
                                variantsMissing += snp + "; ";
                                allVariantsPresent = false;
                            }
                        }

                        if (!variantsPresent.isEmpty()) {
                            variantsPresent = variantsPresent.substring(0, variantsPresent.length() - 2);
                        }
                        
                        if (!variantsMissing.isEmpty()) {
                            variantsMissing = variantsMissing.substring(0, variantsMissing.length() - 2);
                        }                    
                
                        // Write array, haplotype, and coverage to file
                        if(sourceVariants.size() == 0 && haplotypeName.contains("*1")){
                            coverage = "full";
                        }
                        if(sourceVariants.size() == 0 && !haplotypeName.contains("*1")){
                            coverage = "N/A";
                        }
                        else if (allVariantsPresent) {
                            coverage = "full";
                        } 
                        else if (variants.isEmpty()) {
                            coverage = "none";
                        } 
                        else {
                            coverage = "partial";
                        }

                    } else {
                        coverage = "none";
                    }

                    writer.write(dataName + "," + geneName + "," + haplotypeName + "," + coverage + "," + variantsPresent + "," + variantsMissing + "\n");
                }
            }

            writer.close();
            System.out.println("Coverage written successfully!");
        }

        catch (IOException e) {
            System.err.println("Error writing to coverage file:" + e.getMessage());
        }


    }
}