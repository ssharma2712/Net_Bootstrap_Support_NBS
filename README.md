## Net Bootstrap Support (NBS)

The Net Bootstrap Support (NBS) is estimated using the phylogenomic subsampling and upsampling (PSU) framework, and is an alternative to Felsenstein's Bootstrap Support (FBS) in phylogenomic analysis.
<br />

## Directory Structure 
The "Codes" directory contains files for three R functions: ``PSU_MSA_generator`` (PSU_MSA_generator.R), ``PSU_bagging`` (PSU_bagging.R), and ``NBS_automatic`` (NBS_automatic.R). <br />
<br />
The "Example" directory contains an example data file (example.fasta) and a file containing the phylogenetic tree in Newick format (example_tree.nwk) for use as a candidate phylogeny. <br />
<br />

## Introduction
The little bootstraps analyses have three different steps. 
<br />
#### First step: 
<br />
The first step is to create little bootstrap replicates using the ``PSU_MSA_generator``  function in the PSU_MSA_generator R file. <br /><br /> 

```
PSU_MSA_generator(data_path,  g,  s,  r)


data_path         : input sequence alignment in fasta format that will be used for inferring phylogenies to estimate NBS. 

g                 : a numeric value within the range (0.7<= g <= 0.9) that specifies the subsample size. The subsample size is equal to L^g where L is the length of the concatenated sequence alignment.  

s                 : a numeric value that specifies the number of subsamples. 

r                 : a numeric value that specifies the number of replicates for each subsample.
```
<br />

#### Second step:

<br />
In the second step, phylogenetic trees are inferred from these quasi-MSAs generated using PSU-MSA_generator. These phylogenies can be inferred using NJ or ML approaches using MEGA 12, IQTREE, or RAxML.  

<br />

#### Final step:

<br />

In the third or final step, all phylogenies from quasi-MSAs replicates are aggregated using ``PSU_bagging``, an R function in the PSU_bagging.R file.  Inputs for the PSU_bagging function are:

```
PSU_bagging(path, tree_format, candidate_tree, s = NULL, r = NULL, output_tree = NULL)


path           : a character vector that specifies locations of the inferred ML trees. 

tree_format    : a character vector that indicates the tree file format in the directory. Phylogenetic trees need to be provided in the Newick format.

candidate_tree : an object of class "phylo" specifying the phylogeny for which BCLs are desired. 

s              : a numeric value input that specifies the number of subsamples used. If s = NULL, inferred trees from all subsamples from the datapath will be used.  

r              : a numeric value specifying the number of quasi-MSAs used for tree inference. If r = NULL, inferred trees from all quasi-MSAs will be used. 

output_tree    : a character vector specifying the output file name. The output is an object of class "phylo"  in ‘.nwk’ format that contains NBS values. If output_tree = NULL, the output file name will be 'output_tree_nbs.nwk'.


```
<br />

<br />

## Getting Started:

<br />

To perform the little bootstraps analyses on your local computer, please follow these steps:<br /><br />
1.	Download and install R (https://www.r-project.org/) and Rstudio (https://rstudio.com/products/rstudio/download/).<br />
2.	Download ‘Codes’ directory on the local computer. <br />
3.	In the Rstudio session, type ``setwd(“directory path”)`` to change the working directory to the folder that contains ``lb_sampler`` and ``lb_aggregator`` function<br />
4.	Type ``source("PSU_MSA_generator.R")``, and ``source("PSU_bagging.R")`` to make these functions available in the global environment. <br />
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

## Net Bootstrap Support (NBS) Estimation for an Example Dataset:

<br />
To perform the little bootstraps analyses on the example dataset, please follow these steps:<br /><br />
1.	Download the ``Example`` directory on the local computer. <br />
2.	Run the function in the R session by typing 

```R
PSU_MSA_generator("~/Example/example.fasta", g = 0.9, s = 3, r = 3)
```

This function will create three directories in the working directory:

```
Subsample1
Subsample2
Subsample3
```

Each subsample directory will contain three little bootstrap replicate datasets. For example, the ``Subsample1`` directory will contain 

```
example_sub1rep1.fasta
example_sub1rep2.fasta
example_sub1rep3.fasta
```
<br />
3.	Infer ML phylogenetic tree for each replicate dataset using any tree-building software. Users specify the substitution model and other tree inference settings subjectively for the software. For example, we used the IQTREE analysis for the replicate 1 dataset in Subsample1:<br />

``` 
iqtree -s ~/Example/Subsample1/example_sub1rep1.fasta -m GTR+G5
```

Trees for replicate datasets will be stored in each Subsample directory. The tree file name for replicate 1 in Subsample1 will be `` example_sub1rep1.fasta.treefile``. <br /><br />
4.	For the final step, type 

```R
PSU_bagging("~/Example",".treefile", "~/Example/ex_candidate_tree.nwk", s = 3, r = 3,  output_tree = "example_output")
```
The function will output the candidate tree file with BCLs, and the name of the output tree file will be `` example_output.nwk``.<br />

<br />

#### Software and Packages' Version:

<br />

All R codes were tested using R version 3.6.3 in R studio (version 1.2.5033).
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
