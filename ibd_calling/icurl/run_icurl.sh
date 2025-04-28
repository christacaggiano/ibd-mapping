#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 5:00
#BSUB -q premium
#BSUB -R rusage[mem=80000]
#BSUB -J "ped[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/roohy_clusters/logs/out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/roohy_clusters/logs/err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate ibd


# chr=$LSB_JOBINDEX
# file_num=$((LSB_JOBINDEX - 1))
# input_file="/sc/arion/projects/igh/kennylab/data/biome/ibd/libd_pr/"$chr
# combined_file="libd_pr/input/chr"$chr"_combined.txt"
# fam_file="../input_files/cluster2_redone.fam"
# num="2"
# output_dir="libd/pr_only/cluster"$num"_"$chr

# gunzip "libd/"$chr"/"$LSB_JOBINDEX".gz" 
# python make_ped.py $input_file $fam_file $chr $output_dir 

# mkdir "libd_pr/input/" 
# zcat $input_file"/"*".gz" > $combined_file
# python make_ped.py $combined_file $fam_file $chr $output_dir 

# plink --file $output_dir --make-bed --out $output_dir
# plink2 --bfile $output_dir --glm recessive --pheno height_pheno_vital.txt --allow-no-sex --out $output_dir
# plink --bfile $output_dir --freqx --out $output_dir


chr=$LSB_JOBINDEX
# file_num=$((LSB_JOBINDEX - 1))
input_file="/sc/arion/projects/igh/kennylab/data/biome/ibd/libd/"$chr
combined_file="libd_aj/input/chr"$chr"_combined.txt"
fam_file="../input_files/cluster1.fam"
num="1"
output_dir="libd_aj/cluster"$num"_"$chr

# zcat $input_file"/"*".gz" > $combined_file
python make_ped.py $combined_file $fam_file $chr $output_dir 

