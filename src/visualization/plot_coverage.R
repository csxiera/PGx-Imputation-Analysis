library(ggplot2)
library(dplyr)
library(tidyr)

# Select Tier 1 or Tier 2 PGx variant coverage for plotting
tier_number <- "2"

tier_file_path <- paste0("../data/tier_", tier_number, "_haplotypes.csv")
coverage_file_path <- "../results/master_coverage.csv"

tier_hap <- read.csv(tier_file_path)
df <- read.csv(coverage_file_path)

df$Haplotype <- sub(".*\\*", "*", df$Haplotype)
colnames(df)[3] <- "Star.Allele"

#--------------------- Filter Tier Haplotypes from Master ---------------------

unique_genes <- unique(tier_hap$gene)
filtered_df <- df[df$Gene %in% unique_genes, ]

tier_hap <- tier_hap %>%
  rename(Gene = gene, Star.Allele = haplotype)

df2 <- filtered_df %>%
  inner_join(tier_hap, by = c("Gene", "Star.Allele"))

#df2 <- df2 %>%
  #filter(Dataset %in% c("Raw","Unimputed Modified", "Unimputed Standard"))

df2 <- df2 %>%
  filter(Dataset %in% c("1000G Standard", "1000G Modified", "1000G 30x Standard", "1000G 30x Modified", "Topmed Standard", "Topmed Modified"))

df2 <- df2 %>%
  mutate(Star.Allele_numeric = as.numeric(gsub("[^0-9]", "", Star.Allele)),
         Dataset = factor(Dataset, levels = c("Raw", "Unimputed Standard", "Unimputed Modified", "1000G Standard", "1000G Modified", "1000G 30x Standard", "1000G 30x Modified", "Topmed Standard", "Topmed Modified"))) %>%
  arrange(Dataset, Gene, Star.Allele_numeric) %>%
  select(-Star.Allele_numeric)

# Combine gene with haplotype
df_combined <- unite(df2, Haplotype, Gene, Star.Allele, sep = "")

#----------------------------- Plot Tier Heatmaps -----------------------------

order <- unite(tier_hap, Star.Allele, Gene, Star.Allele, sep = "")

df_combined$Haplotype<- factor(df_combined$Haplotype, levels = rev(unique(df_combined$Haplotype)))

plot <- ggplot(data = df_combined, aes(x = Dataset, y = Haplotype, fill = factor(Coverage))) +
  geom_tile(color = "black", size = 0.5) +
  scale_fill_manual(values = c("none" = "white", "partial" = "#95C5F9", "full" = "#0068D7")) +
  coord_fixed(ratio = 0.5) +
  theme_minimal() +
  theme(
    axis.text.x = element_text(angle = 45, hjust = 1, color = "black"), 
    #axis.text.y = element_blank(), 
    #axis.title.y = element_blank(),
    axis.text.y = element_text(color = "black"),
    axis.title.y = element_text(vjust = 4), 
    legend.key.size = unit(0.6, "cm"),
    plot.background = element_rect(fill = "white", colour = "white"),
    plot.margin = margin(1, 1, 1, 1, "cm"),
    plot.title = element_text(size = 15, hjust = 0.5),
    legend.position = "none"
  ) +
  xlab(NULL) +
  guides(fill = guide_legend(title = NULL))+
  ggtitle(paste0("Tier ", tier_number, " Coverage"))

output_path <- paste0("../results/Tier ", tier_number, " Coverage Plot.png")
ggsave(output_path, plot = plot, width= 8, height = 10, dpi = 300)
