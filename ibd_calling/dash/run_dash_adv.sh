#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 12:00
#BSUB -q premium
#BSUB -R rusage[mem=60000]
#BSUB -J "dash_adv[2-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/dash_adv.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/dash_adv.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate ibd

match_files="../ibdne/ilash_files"
fam_files="../ibdne/fam_files/infomap/" 
input_files="input_files/"
output_dir="breast_cancer/dash_output/cluster1/adv/"
num="1"
chr=$LSB_JOBINDEX 

# cat $input_files"/cluster"$num"_"$chr".match" | ../dash/dash-1-1/bin/dash_adv -win 250000 -r2 1 -fam $input_files"/cluster"$num".fam" $output_dir"/cluster"$num"_"$chr 
# awk -v CHR="$chr" '{print CHR, $1, $2, $3}' $output_dir"/cluster"$num"_"$chr".hcl" > $output_dir"/cluster"$num"_"$chr".map"

# plink --file $output_dir"/cluster"$num"_"$chr --make-bed --out $output_dir"/cluster"$num"_"$chr
# plink --file $output_dir"/cluster"$num"_"$chr --keep "breast_cancer/bc_phenotype.txt" --freqx --out "breast_cancer/plink_output/adv/cluster"$num"_"$chr

# ../plink2 --bfile $output_dir"/cluster"$num"_"$chr \
#     --pheno "breast_cancer/bc_phenotype.txt" \
#     --covar "breast_cancer/bc_covs.txt" --glm dominant hide-covar \
#     --covar-variance-standardize \
#     --out "breast_cancer/plink_output/adv/cluster"$num"_"$chr

# awk 'FNR==1 && NR!=1 {next} {print}' "breast_cancer/plink_output/adv/cluster1_"*".CA_105.glm.logistic.hybrid" > "breast_cancer/plink_output/adv/breast_cancer_firth_dom_pcs.txt" 



match_files="../qc/ilash_ibd_pileup/filtered"
fam_files="../ibdne/fam_files/infomap/" 
input_files="input_files/redone/"
output_dir="height/dash_output/adv_redone/"
genotype_file="../../data/biome/geno/gght_v2_topmed_allchr"
num="2"
chr=$LSB_JOBINDEX 

# awk -F ' ' '{prinbt $1,$1"."$2,$3,$3"."$4,$6,$7}' $match_files"/cluster"$num"_"$chr".match" > $input_files"/cluster"$num"_"$chr".match" 

# cat $input_files"/b cluster"$num"_"$chr".match" | ../dash/dash-1-1/bin/dash_adv -win 250000 -r2 1 -fam $input_files"/cluster"$num"_redone.fam" $output_dir"/cluster"$num"_"$chr 
# awk -v CHR="$chr" '{print CHR, $1, $2, $3}' $output_dir"/cluster"$num"_"$chr".hcl" > $output_dir"/cluster"$num"_"$chr".map"

# plink --file $output_dir"/cluster"$num"_"$chr --make-bed --out $output_dir"/cluster"$num"_"$chr
plink --file $output_dir"/cluster"$num"_"$chr --freqx --out $output_dir"/cluster"$num"_"$chr 

# ../plink2 --bfile $output_dir"/cluster"$num"_"$chr \
#     --pheno "output_regenie/cluster2/height_pheno.txt" \
#     --covar "output_regenie/cluster2/height_covs.txt" --glm recessive hide-covar \
#     --covar-variance-standardize \
#     --out $output_dir"/cluster"$num"_"$chr

# awk '{print $1, $2"-"$1, $3, $4, $5, $6}' $output_dir"/cluster"$num"_"$chr".bim" > $output_dir"/cluster"$num"_"$chr"_temp.bim"
# mv $output_dir"/cluster"$num"_"$chr"_temp.bim"  $output_dir"/cluster"$num"_"$chr".bim"

# ../plink2 --pmerge-list "mergelist.txt" bfile --make-bed --out "pca/cluster2/merged_adv_redone"
# 

# plink --bfile "pca/cluster2/merged_adv_redone"  --maf 0.01 \
#     --indep-pairwise 50 10 0.1 --out "pca/cluster2/merged_adv_redone"

# plink --bfile "pca/cluster2/merged_adv_redone" \
#     --extract "pca/cluster2/merged_adv_redone.prune.in" \
#     --make-bed --pca 20 --out "pca/cluster2/merged_adv_redone"


# plink --bfile $genotype_file \
#     --keep $input_files"/cluster"$num"_redone.fam" --maf 0.01 \
#     --indep-pairwise 50 10 0.1 --out "pca/cluster2/merged_adv_redone_geno"

# plink --bfile $genotype_file \
#     --keep $input_files"/cluster"$num"_redone.fam" \
#     --extract "pca/cluster2/merged_adv_redone_geno.prune.in" \
#     --pca 20 --out "pca/cluster2/merged_adv_redone_geno" 