#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 12:00
#BSUB -q premium
#BSUB -R rusage[mem=60000]
#BSUB -J "plink[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/plink.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/plink.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniforge/etc/profile.d/conda.sh
conda activate ibd

chr=$LSB_JOBINDEX 

# output="comparison/dys/" 
# pheno=$output"/dys_phen.txt"
# covar=$output"/dys_covs.txt"
# code="GE_972.5"
# pop="aj"
# num=1

output=$1
pheno=$2
covar=$3
code=$4
pop=$5
num=$6

# ##### dash cc 

input_file="dash_output/"$pop"/dashcc/cluster"$num"_"$chr
output_dir=$output"/dashcc/"
output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --geno-counts \
#     --keep $pheno \
#     --glm recessive hide-covar \
#     --covar $covar \
#     --covar-variance-standardize \
#     --out $output_file

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if  "${code} == 2" \
#     --geno-counts  \
#     --out $output_file"_case"

# ../plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts  \
#     --out $output_file


##### dash adv  

input_file="dash_output/"$pop"/adv_redone/cluster"$num"_"$chr
output_dir=$output"/adv_redone/"
output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir


# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --geno-counts \
#     --keep $pheno \
#     --glm recessive hide-covar \
#     --covar $covar \
#     --covar-variance-standardize \
#     --out $output_file

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if  "${code} == 2" \
#     --geno-counts  \
#     --out $output_file"_case"

# ../plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts  \
#     --out $output_file


##### dash adv default

# input_file="dash_output/"$pop"/adv_default/cluster"$num"_"$chr
# output_dir=$output"/adv_default/"
# output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --geno-counts \
#     --keep $pheno \
#     --glm recessive hide-covar \
#     --covar $covar \
#     --covar-variance-standardize \
#     --out $output_file

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if "${code} == 2" \
#     --geno-counts  \
#     --out $output_file"_case"

# ../plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts  \
#     --out $output_file

##### icurl 

input_file="icurl/libd/"$pop"/cluster"$num"_"$chr
output_dir=$output"/icurl/"
output_file=$output_dir"/"$pop"_"$chr

mkdir -p $output_dir

../plink2 --bfile $input_file \
    --pheno $pheno \
    --geno-counts \
    --pheno-name $code \
    --keep $pheno \
    --glm recessive hide-covar \
    --covar $covar \
    --covar-variance-standardize \
    --out $output_file

../plink2 --bfile $input_file \
    --pheno $pheno \
    --keep-if "${code} == 2" \
    --geno-counts  \
    --out $output_file"_case"

../plink2 --bfile $input_file \
    --keep $pheno \
    --geno-counts  \
    --out $output_file

# plink --bfile ../../../height/dash_output/dashcc/cluster2_9 \
#     --extract allele.txt \
#     --pheno ../occ_phen.txt \
#     --recode-allele allele.txt \
#     --recode A \
#     --allow-extra-chr \
#     --out cluster2_9