#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 28
#BSUB -W 24:00
#BSUB -q premium
#BSUB -R span[hosts=1]
#BSUB -R rusage[mem=2000]
#BSUB -J "regenie[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/regenie.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/regenie.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniforge/etc/profile.d/conda.sh
conda activate regenie_env

chr=$LSB_JOBINDEX 


# ##### dash cc 

# output="all_phenotypes_binary/phecodes/cluster2/icurl/" 
# pheno=$output"/phecodes1_100_phen.txt"
# covar=$output"/phecodes1_100_covs.txt"
# # code="GE_972.5"
# pop="pr"
# num=2

output=$1
pheno=$2
covar=$3
code=$4
pop=$5
num=$6

mkdir -p $output 

# ##### dash cc 

input_file="dash_output/"$pop"/dashcc/cluster"$num"_"$chr
output_dir=$output"/dashcc/"
output_file=$output_dir"/"$pop"_"$chr

mkdir -p $output_dir


# ../plink2 \
#   --bfile $input_file \
#   --mac 2 \
#   --write-snplist \
#   --out $output_file"_snps_pass"

# regenie \
#   --step 1 \
#   --bed $input_file \
#   --keep $input_file".fam" \
#   --extract $output_file"_snps_pass.snplist" \
#   --covarFile $covar \
#   --phenoFile $pheno \
#   --bsize 1000 \
#   --force-step1 \
#   --bt --minCaseCount	1 \
#   --cc12 --lowmem \
#   --lowmem-prefix $output_dir"tmp_rg"$chr \
#   --out $output_file

# regenie \
#   --step 2 \
#   --bed $input_file \
#   --keep $input_file".fam" \
#   --covarFile $covar \
#   --phenoFile $pheno \
#   --bsize 1000 \
#   --bt --cc12 \
#   --minCaseCount 1	\
#   --af-cc \
#   --firth --approx \
#   --no-split	\
#   --approx --test recessive \
#   --pred $output_file"_pred.list" \
#   --out $output_file

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if "GI_542.8 == 2" \
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

mkdir -p $output_dir

# ../plink2 \
#   --bfile $input_file \
#   --mac 2 \
#   --write-snplist \
#   --out $output_file"_snps_pass"

# regenie \
#   --step 1 \
#   --bed $input_file \
#   --keep $input_file".fam" \
#   --extract $output_file"_snps_pass.snplist" \
#   --covarFile $covar \
#   --phenoFile $pheno \
#   --bsize 1000 \
#   --force-step1 \
#   --bt --minCaseCount	1 \
#   --cc12 --lowmem \
#   --lowmem-prefix $output_dir"tmp_rg"$chr \
#   --out $output_file

# regenie \
#   --step 2 \
#   --bed $input_file \
#   --keep $input_file".fam" \
#   --covarFile $covar \
#   --phenoFile $pheno \
#   --bsize 1000 \
#   --bt --cc12 \
#   --minCaseCount 1	\
#   --af-cc \
#   --firth --approx \
#   --no-split	\
#   --approx --test recessive \
#   --pred $output_file"_pred.list" \
  # --out $output_file

#   ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if "GI_542.8 == 2" \
#     --geno-counts  \
#     --out $output_file"_case"

# ../plink2 --bfile $input_file \
#     --keep $pheno \
#     --geno-counts  \
#     --out $output_file




##### dash adv default

input_file="dash_output/"$pop"/adv_default/cluster"$num"_"$chr
output_dir=$output"/adv_default/"
output_file=$output_dir"/"$pop"_"$chr

# mkdir -p $output_dir


# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --geno-counts \
#     --keep $pheno \
#     --glm firth recessive hide-covar \
#     --covar $covar \
#     --covar-variance-standardize \
#     --out $output_file


# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if "GI_542.8 == 2" \
#     --geno-counts  \
#     --out $output_file"_case"


##### icurl 

input_file="icurl/libd/"$pop"/cluster"$num"_"$chr
output_dir=$output"/icurl/"
output_file=$output_dir"/"$pop"_"$chr"_"$code 

mkdir -p $output_dir

# ../plink2 \
#   --bfile $input_file \
#   --keep $pheno \
#   --mac 5 \
#   --write-snplist \
#   --out $output_file"_snps_pass"

# regenie \
#   --step 1 \
#   --bed $input_file \
#   --keep $input_file".fam" \
#   --extract $output_file"_snps_pass.snplist" \
#   --covarFile $covar \
#   --phenoFile $pheno \
#   --bsize 1000 \
#   --force-step1 \
#   --phenoCol $code \
#   --bt --minCaseCount	3 \
#   --cc12 \
#   --loocv \
#   --threads 56  \
#   --out $output_file

# regenie \
#   --step 2 \
#   --bed $input_file \
#   --keep $input_file".fam" \
#   --covarFile $covar \
#   --phenoFile $pheno \
#   --bsize 1000 \
#   --bt --cc12 \
#   --phenoCol $code \
#   --minMAC 3 \
#   --minCaseCount 3	\
#   --firth --approx \
#   --no-split	\
#   --threads 56  \
#   --approx --test recessive \
#   --pred $output_file"_pred.list" \
#   --out $output_file

# # ../plink2 --bfile $input_file \
# #     --pheno $pheno \
# #     --keep-if  "${code} == 2" \
# #     --geno-counts  \
# #     --out $output_file"_case"

../plink2 --bfile $input_file \
    --keep $input_file".fam" \
    --geno-counts  \
    --out $output_dir"/pr_"$chr


