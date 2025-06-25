#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 16
#BSUB -W 8:00
#BSUB -q premium
#BSUB -R rusage[mem=8000]
#BSUB -J "regenie_bt[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/regenie.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/regenie.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate regenie_env

num="2"
chr=$LSB_JOBINDEX 
genotype_file="../clusters_ibd/infomap/plink_files/cluster"$num"_chr"$chr
output_dir="output_regenie/cluster2/redone/output_"$chr
dash_file="height/dash_output/adv_redone/cluster2_"$chr

# awk '{print $1, $2"-"$1, $3, $4, $5, $6}' "height/dash_output/redone/cluster"$num"_"$chr"_filtered_redone.bim" > "height/dash_output/redone/cluster"$num"_"$chr"_filtered_redone_temp.bim"
# mv "height/dash_output/redone/cluster"$num"_"$chr"_filtered_redone_temp.bim" "height/dash_output/redone/cluster"$num"_"$chr"_filtered_redone.bim"

# ../plink2 --pmerge-list "mergelist.txt" bfile --make-bed --out "height/dash_output/redone/merged"

# # ../plink2 \
# #   --bfile $dash_file \
# #   --mac 10 \
# #   --write-snplist \
# #   --out $output_dir"_snps_pass"

# regenie \
#   --step 1 \
#   --bed $dash_file \
#   --keep $dash_file".fam" \
#   --extract $output_dir"_snps_pass.snplist" \
#   --covarFile "all_phenotypes/covariates.txt" \
#   --phenoFile "output_regenie/cluster2/height_pheno.txt" \
#   --bsize 1000 \
#   --lowmem \
#   --lowmem-prefix $output_dir"tmp_rg"$chr \
#   --out $output_dir

# regenie \
#   --step 2 \
#   --bed $dash_file \
#   --keep $dash_file".fam" \
#   --covarFile "all_phenotypes/covariates.txt" \
#   --phenoFile "output_regenie/cluster2/height_pheno.txt" \
#   --bsize 1000 \
#   --minMAC 3 \
#   --approx --test recessive \
#   --pred $output_dir"_pred.list" \
#   --out $output_dir

# # ../plink2 --bfile $dash_file  \
#     --extract $output_dir"_snps_pass.snplist" \
#     --covar "output_regenie/cluster2/height_covs.txt" \
#     --pheno "output_regenie/cluster2/height_pheno.txt" \
#     --keep-if "height == 2" \
#     --geno-counts --out $output_dir

awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/cluster2/binary/adv/"*".regenie" > "output_regenie/cluster2/binary/adv/all_phen.regenie" 

######################################################################################


num="2"
chr=$LSB_JOBINDEX 
genotype_file="../clusters_ibd/infomap/plink_files/cluster"$num"_chr"$chr
output_dir="output_regenie/cluster2/binary/adv_spa/output_"$chr
dash_file="height/dash_output/adv_redone/cluster2_"$chr

# ../plink2 \
#   --bfile $dash_file \
#   --mac 7 \
#   --write-snplist \
#   --out $output_dir"_snps_pass"

regenie \
  --step 1 \
  --bed $dash_file \
  --keep $dash_file".fam" \
  --extract $output_dir"_snps_pass.snplist" \
  --covarFile "all_phenotypes/covariates.txt" \
  --phenoFile "all_phenotypes/all_pheno_cluster2_3count_num_test.txt" \
  --bsize 1000 \
  --force-step1 \
  --bt --minCaseCount	3 \
  --cc12 --lowmem \
  --loocv	\
  --lowmem \
  --lowmem-prefix $output_dir"tmp_rg"$chr \
  --out $output_dir

regenie \
  --step 2 \
  --bed $dash_file \
  --keep $dash_file".fam" \
  --covarFile "all_phenotypes/covariates.txt" \
  --phenoFile "all_phenotypes/all_pheno_cluster2_3count_num_test.txt" \
  --bsize 1000 \
  --minMAC 3 \
  --bt --cc12 \
  --minCaseCount 3	\
  --pThresh 0.01 \
  --af-cc --spa \
  --no-split	\
  --approx --test recessive \
  --pred $output_dir"_pred.list" \
  --out $output_dir







#####################################################################################

# num="1"
# chr=$LSB_JOBINDEX 
# output_dir="output_regenie/adv/cluster1_"$chr"spa"
# dash_file="breast_cancer/dash_output/cluster1/adv/cluster1_"$chr
# phen_file="breast_cancer/bc_phenotype.txt"
# covs_file="breast_cancer/bc_covs.txt"
# test="dominant"

# for i in {1..22}
# do
# echo "breast_cancer/dash_output/cluster1/cluster1"_$i >> mergelist_clst1.txt
# done

# ../plink2 --pmerge-list "mergelist_clst1.txt" bfile --make-bed --out "breast_cancer/dash_output/cluster1/merged"

# awk '{print $1, $2"-"$1, $3, $4, $5, $6}' "breast_cancer/dash_output/cluster1/cluster1_"$chr".bim" > "breast_cancer/dash_output/cluster1/cluster1_"$chr"_temp.bim"
# mv "breast_cancer/dash_output/cluster1/cluster1_"$chr"_temp.bim" "breast_cancer/dash_output/cluster1/cluster1_"$chr".bim"
# rm "breast_cancer/dash_output/cluster1/cluster1_"$chr"_temp.bim"

# ../plink2 --pmerge-list "mergelist_clst1.txt" bfile --make-bed --out "breast_cancer/dash_output/cluster1/merged"

# ../plink2 \
#   --bfile $dash_file \
#   --mac 3 \
#   --keep $phen_file \
#   --write-snplist \
#   --out $output_dir"_snps_pass"

# regenie \
#   --step 1 \
#   --bed $dash_file \
#   --extract $output_dir"_snps_pass.snplist" \
#   --covarFile $covs_file \
#   --phenoFile $phen_file \
#   --bsize 1000 \
#   --force-step1 \
#   --bt --minCaseCount	3 \
#   --cc12 --lowmem \
#   --lowmem-prefix $output_dir"_tmp_rg" \
#   --out $output_dir

# regenie \
#   --step 2 \
#   --bed $dash_file \
#   --covarFile $covs_file \
#   --phenoFile $phen_file \
#   --bsize 1000 \
#   --bt --cc12 \
#   --minCaseCount 3	\
#   --pThresh 0.01 \
#   --af-cc --minMAC 3 \
#   --spa --approx --test $test \
#   --pred $output_dir"_pred.list" \
#   --out $output_dir

# ../plink2 --bfile $dash_file  \
    # --extract $output_dir"_snps_pass.snplist" \
    # --covar "breast_cancer/bc_covs.txt" \
    # --pheno "breast_cancer/bc_phenotype.txt" \
    # --keep-if "CA_105 == 2" \
    # --geno-counts --out $output_dir

# awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/adv/"*".gcount" > "output_regenie/gcount/adv/breast_cancer.gcount"

# awk 'FNR==1 && NR!=1 {next} {print}' "breast_cancer/plink_output/cluster1_"*".CA_105.glm.firth" > breast_cancer/plink_output/breast_cancer_plink_firth_dom.txt 

# awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/adv/"cluster1_*"_pthres_firth_dom.txt_CA_105.regenie" > "output_regenie/adv/breast_cancer_firth_dom_pcs_pthres.txt" 
# awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/adv/cluster1_"*"_pthres.gcount" > "output_regenie/adv/breast_cancer_firth_pthresh.gcount" 

# awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/dashcc/"*"_firth_dom.txt_CA_105.regenie" > "output_regenie/dashcc/breast_cancer_firth_dom_pcs.txt" 
# awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/dashcc/"*".gcount" > "output_regenie/gcount/dash_cc/breast_cancer.gcount"

# awk 'FNR==1 && NR!=1 {next} {print}' "output_regenie/adv/"*"spa"*"regenie" > "output_regenie/adv/breast_cancer_spa_dom_pcs.txt" 
