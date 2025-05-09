## Net Bootstrap Support (NBS)

The Net Bootstrap Support (NBS) is estimated using the phylogenomic subsampling and upsampling (PSU) framework, and is an alternative to Felsenstein's Bootstrap Support (FBS) in phylogenomic analysis.
<br />

## Directory Structure 
The "Codes" directory contains files for three R functions: ``PSU_MSA_generator`` (PSU_MSA_generator.R), ``PSU_bagging`` (PSU_bagging.R), and ``NBS_automatic`` (NBS_automatic.R). <br />
<br />
The "Example" directory contains an example data file (example.fasta) and a file containing the phylogenetic tree in Newick format (example_tree.nwk) for use as a candidate phylogeny. <br />
<br />
<br />

## Description NBS pipeline

The R function ``NBS_automatic`` estimates Net Bootstrap Support using the PSU framework, which can select the subsample size and the number of subsamples automatically.

```
NBS_automatic(data_path, candidate_tree, evo_model = NULL, output_tree = NULL, del = 0.01, precision = FALSE)


data_path      : a character vector that specifies locations of the inferred ML trees. For example, fasta file mtCDNA for little bootstrap analysis in the Automatic folder. Therefore, the data_path will be "~/Automatic/mtCDNA.fas"

candidate_tree : an object of class "phylo" specifying the phylogeny for which NBS are desired. 

evo_model      : a string vector that specifies the substitution model for inferring ML trees from PSU replicates. If NULL, the model will be determined by IQTREE.

output_tree    : a character vector specifying the output file name. The output is an object of class "phylo"  in ‘.nwk’ format that contains NBSs. If output_tree = NULL, the output file name will be 'output_tree_lb.nwk'.

del            : a numeric value to specify the threshold of the change in the root mean squared difference (RMSD) of NBSs between subsamples for selecting the number of subsamples. The value should be less than 1. For example, if a user allows 5% change in average BCLs, the del = 0.05.

```
<br />

<br />

## Getting Started:

<br />

To perform the analysis for estimating NBS on your local computer, please follow these steps:<br /><br />
1.	Download and install R (https://www.r-project.org/) and Rstudio (https://rstudio.com/products/rstudio/download/).<br />
2.	Download ‘Codes’ directory on the local computer. <br />
3.	In the Rstudio session, type ``setwd(“directory path”)`` to change the working directory to the folder that contains ``NBS_automatic`` <br />
4.	Type ``source("NBS_automatic.R")`` to make these functions available in the global environment. <br />
5.	Download and install an ML tree inference software (e.g., IQ-TREE). <br />
6.	Install the following R packages if they are not installed. 

```R
install.packages("BiocManager")
BiocManager::install("Biostrings")
install.packages("stringr")
install.packages("ape")
install.packages("phangorn")
```

<br />

## Net Bootstrap Support estimation for an Example Dataset:

<br />
To perform the estimation of Net Bootstrap Support analyses on the example dataset, please follow these steps:<br /><br />
1.	Download the GitHub directory on the local computer. <br />
2.	Run the function in the R session by typing 

```R
NBS_automatic("~/Automatic/mtCDNA.fas", candidate_tree = "~/Automatic/mtCDNA.nwk", evo_model = "GTR+G4", output_tree = NULL, del = 0.01)

```

Both functions will output two trees, one tree (output_tree_nbs.nwk) with NBS and another tree (output_tree_nbs_consensus.nwk), a consensus tree with NBS.


#### Software and Packages' Version:

<br />

All R codes were tested using R version 3.6.3 in R studio (version 1.2.5033). We used IQ-TREE (multicore version 1.6.12 for Windows 64-bit built Aug 15 2019) for ML tree inferences.
<br />  
R packages used:
<br />

```
-BiocManager (version 1.30.10)
-Biostrings  (version 2.54.0)
-stringr     (version 1.4.0)
-ape         (version 5.3)
-phangorn    (version 2.5.5)
```

<br />
<br />


<br />
<br />
