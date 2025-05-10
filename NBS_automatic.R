NBS_automatic <- function(data_path, candidate_tree, evo_model = NULL, output_tree = NULL, del = 0.001, precision = FALSE){
  
  # data_path     : Directory path where the fasta file located
  # candidate_tree: The candidate tree that will be assessed
  # evo_model     : Substitution model
  # output_tree   : Output tree file name
  # del           : Treshold value for choosing s and r
  
  
  ########## Package required #####################
  
  if (!requireNamespace("BiocManager", quietly = TRUE))
    install.packages("BiocManager")
  
  if (!requireNamespace("Biostrings", quietly = TRUE))
    BiocManager::install("Biostrings")
  
  if (!requireNamespace("stringr", quietly = TRUE))
    install.packages("stringr")
  
  if (!requireNamespace("ape", quietly = TRUE))
    install.packages("ape")
  
  if (!requireNamespace("phyclust", quietly = TRUE))
    install.packages("phyclust")
  
  if (!requireNamespace("phangorn", quietly = TRUE))
    install.packages("phangorn")
  
  
  ################# Library Required ##################
  
  
  if (!library('Biostrings',logical.return = TRUE)){
    stop("'Biostrings' package not found, please install it to run lb_automatic")
  }
  
  if (!library('stringr',logical.return = TRUE)){
    stop("'stringr' package not found, please install it to run lb_automatic")
  }
  
  if (!library('phyclust',logical.return = TRUE)){
    stop("'phyclust' package not found, please install it to run lb_automatic")
  }
 
  #########################################
  data_path <- "C:/Users/Administrator/Downloads/Manuscript/CR-article/Little-Bootstraps-master/Temp/mtCDNA.fas"
  f_name <- data_path                                                  # Mother data name
  sub_name <- str_replace(basename(data_path), ".fas", "")           # Replicate file generic name
  motherfile <- Biostrings::readAAStringSet(f_name, format = "fasta")  # Reading the mother file 
  sln <- as.numeric(fasta.seqlengths(f_name)[1])                       # Getting the sequence length
  directory <- getwd()
  a <- as.matrix(motherfile)
  a <- unique(a, MARGIN = 2)
  
  ######## Subsample Size Calculation #########
  
  if(dim(a)[2] < 10000){
    g <- 0.9
  }else if (dim(a)[2] >= 10000 && dim(a)[2] < 100000){
    g <- 0.8
  }else{
    g <- 0.7
  }
  rm(a)
  
############## Subsample Generator ################
  
  source("PSU_MSA_generator.R")
  PSU_MSA_generator(data_path, s = 6, r = 20, sub_num = 1, g = g)
  
############# IQ-TREE analysis ########
  

for(i in 1:6){
    lf_fasta <- list.files(paste0(getwd(), "/Subsample", i), pattern = ".fasta", full.names = T)
    
    for(j in 1:20){
      if(is.null(evo_model) == F){
          shell(paste("iqtree -s", lf_fasta[j], "-m", evo_model, sep = " "))
        }else{
          shell(paste("iqtree -s", lf_fasta[j], sep = " "))
        }
    }
  }
  
 
################ Compare RMSD ###################
  
 source("NBS_aggregator.R")  
 sub_avg <- c(0, 0, 0, 0)
 sub_sup <- NULL
 for(i in 5:6){
   sub_sup <- cbind(sub_sup, NBS_aggregator(getwd(), s = i, r = 20, candidate_tree = "mtCDNA.nwk", tree_format = ".treefile"))
 }  
  
 calculate_RMSD <- function(data){
   rmsd <- sqrt(mean((data[,2]-data[,1])^2))
   return(rmsd)
 } 
  
 sub_rmsd <- calculate_RMSD(data = sub_sup)

 ########## Iterative Step ###############
   
  current_sub <- 6
  while(sub_rmsd > del){
    current_sub <- current_sub + 1
    
    PSU_MSA_generator(data_path, s = 1, r = 20, sub_num = current_sub, g = g)
    
    for(i in current_sub:current_sub){
      lf_fasta <- list.files(paste0(getwd(), "/Subsample", i), pattern = ".fasta", full.names = T)
      
      for(j in 1:20){
        if(is.null(evo_model) == F){
          shell(paste("iqtree -s", lf_fasta[j], "-m", evo_model, sep = " "))
        }else{
          shell(paste("iqtree -s", lf_fasta[j], sep = " "))
        }
      }
    }
    
    sub_sup <- NULL
    for(i in (current_sub-1):current_sub){
      sub_sup <- cbind(sub_sup, NBS_aggregator(getwd(), s = i, r = 20, candidate_tree = "mtCDNA.nwk", tree_format = ".treefile"))
    }  
    
    sub_rmsd <- calculate_RMSD(data = sub_sup)
    
  }
  
 ########## Final Output ####################
  NBS_aggregator(getwd(), s = current_sub, r = 20, candidate_tree = "mtCDNA.nwk", tree_format = ".treefile")
  
}

