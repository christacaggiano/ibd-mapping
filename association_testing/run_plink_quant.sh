#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 12:00
#BSUB -q premium
#BSUB -R rusage[mem=60000]
#BSUB -J "plink[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/plink.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/plink.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate ibd

chr=$LSB_JOBINDEX 


# ##### dash cc 

pheno="comparison/height/height_pheno_vital.txt"
input_file="height/dash_output/dashcc/cluster2_"$chr
output_dir="comparison/height/dashcc/"
output_file=$output_dir"/cluster2_"$chr

mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
#     --out $output_file


##### dash adv  

pheno="comparison/height/height_pheno_vital.txt"
input_file="height/dash_output/adv_redone/cluster2_"$chr
output_dir="comparison/height/adv_redone/"
output_file=$output_dir"/cluster2_"$chr

mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
#     --out $output_file


##### dash adv default

pheno="comparison/height/height_pheno_vital.txt"
input_file="height/dash_output/adv_default/cluster2_"$chr
output_dir="comparison/height/adv_default/"
output_file=$output_dir"/cluster2_"$chr

# mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
#     --out $output_file


##### icurl 

pheno="comparison/height/height_pheno_vital.txt"
input_file="icurl/libd/pr_only/redone/cluster2_"$chr
output_dir="comparison/height/icurl/"
output_file=$output_dir"/cluster2_"$chr

# mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
#     --out $output_file



