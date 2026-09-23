# Genomic surveillance of *Pseudomonas aeruginosa* across One Health settings

This repository contains custom analysis scripts and processed data supporting the genomic epidemiological analyses of *Pseudomonas aeruginosa* isolates collected from hospitals, farms, and wastewater treatment plants across five provinces of China over four seasons.

The repository is provided to facilitate reproducibility of the principal analyses, including core-genome SNP analysis, identification of putative clonal transmission clusters, hospital-level risk assessment, genomic-context comparison, and visualization of genomic and epidemiological characteristics.

## Repository contents

### Analysis scripts

- `01_core_snp_analysis.sh`  
  Core-genome SNP analysis pipeline. Gubbins was then used to identify and remove recombinant regions, and polymorphic sites were extracted for downstream phylogenetic and pairwise SNP analyses.

- `02_snp_cluster_detection.py`  
  Identifies putative clonal transmission clusters based on pairwise core-genome SNP distances. Isolates are represented as nodes in a genomic relatedness network, and isolates separated by no more than the specified SNP threshold are connected. The script also identifies a representative central isolate for each cluster.

- `03_hospital_risk_score.py`  
  Implements the hospital-level risk assessment framework used in the study. 

- `04_gene_pattern_distance.py`  
  Compares genomic-context patterns using edit distance and Jaccard similarity. The script generates pairwise similarity/distance results and corresponding distance matrices.

- `05_plot_ani_density.R`  
  Generates density plots comparing average nucleotide identity (ANI) distributions between clinical and non-clinical isolates.

- `06_plot_plasmid_heatmap.R`  
  Generates the integrated plasmid heatmap showing isolation source, environment, geographic origin, plasmid mobility, circularity, antimicrobial resistance genes, replicon types, and plasmid length.

- `07_plot_province_stacked_bar.R`  
  Generates stacked bar plots showing the distribution of clinical and non-clinical isolates across provinces.

- `08_plot_geographic_distribution.R`  
  Generates geographic maps showing the distribution of isolates across provinces and sampling environments.

### Processed genomic data

- `gubbins.filtered_polymorphic_sites.fasta.gz`  
  Recombination-filtered core-genome SNP alignment generated using Gubbins and used for phylogenetic analysis and downstream genomic comparisons.

- `coreSNP.aln.fastree.treefile`  
  Phylogenetic tree reconstructed from the recombination-filtered core-genome SNP alignment.

- `coreSNP.distance.csv`  
  Pairwise core-genome SNP distance matrix used for identifying closely related isolates and putative clonal transmission clusters.

- `gene_presence_absence.Rtab`  
  Gene presence/absence matrix used for the pangenome-based comparative genomic analyses.