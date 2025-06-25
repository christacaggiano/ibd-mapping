#!/bin/bash


. /sc/arion/projects/igh/kennylab/christa/miniforge/etc/profile.d/conda.sh
conda activate ibd

chr=$LSB_JOBINDEX 

output=$1
pheno=$2
covar=$3
code=$4
pop=$5
num=$6


# mkdir -p $output

# ##### dash cc 

# input_file="dash_output/"$pop"/dashcc/cluster"$num"_"$chr
# output_dir=$output"/dashcc/"
# output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
#     --out $output_file


##### dash adv  

# input_file="dash_output/"$pop"/adv_redone/cluster"$num"_"$chr
# output_dir=$output"/adv_redone/"
# output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
#     --out $output_file


##### dash adv default

# input_file="dash_output/"$pop"/adv_default/cluster"$num"_"$chr
# output_dir=$output"/adv_default/"
# output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir

# plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts \
#     --pheno $pheno \
#     --glm recessive \
    # --out $output_file


##### icurl 

input_file="icurl/libd/"$pop"/cluster"$num"_"$chr
output_dir=$output"/icurl/"
output_file=$output_dir"/"$pop"_"$chr


mkdir -p $output_dir

plink2 --bfile $input_file \
    --keep $pheno \
    --pheno-name $code \
    --geno-counts \
    --pheno $pheno \
    --glm recessive \
    --out $output_file



