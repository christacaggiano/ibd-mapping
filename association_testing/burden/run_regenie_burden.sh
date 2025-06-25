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

output=$1
pheno=$2
covar=$3
code=$4
pop=$5
input_file="../geno/"$pop"/"$pop"_chr"$chr

mkdir -p $output 

##### icurl 
output_dir=$output"/burden/"
output_file=$output_dir"/"$pop"_"$chr"_"$code

mkdir -p $output_dir

../../../plink2 \
  --bfile $input_file \
  --keep $pheno \
  --mac 3 \
  --exclude exclude_snps.txt \
  --write-snplist \
  --out $output_file"_snps_pass"

regenie \
  --step 1 \
  --bed $input_file \
  --keep $input_file".fam" \
  --covarFile $covar \
  --phenoFile $pheno \
  --bsize 1000 \
  --force-step1 \
  --extract $output_file"_snps_pass.snplist" \
  --phenoCol $code \
  --bt --minCaseCount	3 \
  --cc12 \
  --loocv \
  --threads 32  \
  --out $output_file

regenie \
  --step 2 \
  --bed $input_file \
  --keep $input_file".fam" \
  --covarFile $covar \
  --phenoFile $pheno \
  --bsize 1000 \
  --bt --cc12 \
  --phenoCol $code \
  --minMAC 3 \
  --minCaseCount 3	\
  --firth --approx \
  --no-split	\
  --threads 32  \
  --aaf-bins	1,0.01,0.001,0.0001 \
  --anno-file annotation_files/all/annotation_file_chr${chr} \
  --set-list  annotation_files/all/set_file${chr} \
  --mask-def masks \
  --vc-tests skato,acato-full	 \
  --rgc-gene-p \
  --pred $output_file"_pred.list" \
  --out $output_file

# rm $output_file*"snps_pass"*
# rm $output_file*"log"

# ../plink2 --bfile $input_file \
#     --pheno $pheno \
#     --keep-if  "${code} == 2" \
#     --geno-counts  \
#     --out $output_file"_case"

# ../plink2 --bfile "icurl/libd/pr/cluster2_"$chr \
#     --pheno "all_phenotypes_binary/phecodes/pr/regenie/phecodes_all_phen.tsv" \
#     --keep-if  "CM_769.1 == 2" \
#     --geno-counts  \
#     --out "all_phenotypes_binary/phecodes/pr/regenie/icurl/pr_"$chr"_CM_769.1_case" 

# ../plink2 --bfile "icurl/libd_updated/pr/pr_"$chr \
#     --keep "input_files/updated/pr/pr.fam" \
#     --geno-counts  \
#     --out $output_dir"/"$pop"_"$chr


