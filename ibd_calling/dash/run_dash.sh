#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 12:00
#BSUB -q premium
#BSUB -R rusage[mem=60000]
#BSUB -J "dash[22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/dash.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/dash.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate ibd

match_files="../ibdne/ilash_files"
fam_files="../ibdne/fam_files/infomap/" 
input_files="input_files/"
output_dir="height/dash_output/dashcc/"
num="2"
chr=$LSB_JOBINDEX 

###### generate match files in the expected format for DASH 
awk -F ' ' '{print $1,$1"."$2,$3,$3"."$4,$6,$7}' $match_files"/cluster"$num"_"$chr".match" > $input_files"/cluster"$num"_"$chr".match" 

##### run dash 
# cat $input_files"/cluster"$num"_"$chr".match" | ../dash/dash-1-1/bin/dash_cc $input_files"/cluster"$num"_redone.fam" $output_dir"/cluster"$num"_"$chr

# ##### make map file out of DASH output 
# awk -v CHR="$chr" '{print CHR, $1, $2, $3}' $output_dir"/cluster"$num"_"$chr".clst" > $output_dir"/cluster"$num"_"$chr".map"

# ##### run association analysis -
# plink --file $output_dir"/cluster"$num"_"$chr --make-bed --freqx --out $output_dir"/cluster"$num"_"$chr


# plink2 --bfile $output_dir"/cluster"$num"_"$chr"_filtered_redone" --pheno "roohy_clusters/height_pheno_vital.txt" --glm recessive --out "height/plink_output/cluster"$num"_"$chr"_filtered_redone_vital_glm" 
# plink --file $output_dir"/cluster"$num"_"$chr"_filtered_redone" --freqx --out "height/plink_output/cluster"$num"_"$chr"_filtered_redone_vital"

# plink2 --bfile $output_dir"/cluster"$num"_"$chr"_filtered_redone" --pheno "all_phenotypes/all_pheno_cluster2.txt" --glm recessive firth --out "all_phenotypes/cluster"$num"_"$chr 

# plink2 --bfile $output_dir"/cluster"$num"_"$chr --pheno "roohy_clusters/height_pheno_vital.txt" --glm recessive --out "height/plink_output/cluster"$num"_"$chr 


####### asthma 
# plink2 --bfile $output_dir"/cluster"$num"_"$chr"_filtered_redone" --pheno "asthma_phenotype.txt" --glm recessive --covar "asthma_covs.txt" --out "asthma/plink_output/cluster"$num"_"$chr"_asthma" 
# plink --file $output_dir"/cluster"$num"_"$chr"_filtered_redone" --freqx --out "asthma/plink_output/cluster"$num"_"$chr"_asthma" 

####### breast cancer 

# match_files="../ibdne/ilash_files"
# fam_files="../ibdne/fam_files/infomap/" 
# input_files="input_files/"
# output_dir="breast_cancer/dash_output/cluster1/"
# num="1"
# chr=$LSB_JOBINDEX 

# cat $input_files"/cluster"$num"_"$chr".match" | ../dash/dash-1-1/bin/dash_cc $input_files"/cluster"$num".fam" $output_dir"/cluster"$num"_"$chr 
# awk -v CHR="$chr" '{print CHR, $1, $2, $3}' $output_dir"/cluster"$num"_"$chr".clst" > $output_dir"/cluster"$num"_"$chr".map"

# plink --file $output_dir"/cluster"$num"_"$chr --make-bed --out $output_dir"/cluster"$num"_"$chr
# plink --file $output_dir"/cluster"$num"_"$chr --keep "breast_cancer/bc_phenotype.txt" --freqx --out "breast_cancer/plink_output/cluster"$num"_"$chr

# plink2 --bfile $output_dir"/cluster"$num"_"$chr --pheno "breast_cancer/bc_phenotype.txt" --covar "breast_cancer/bc_covs.txt" --glm dominant firth --covar-variance-standardize --out "breast_cancer/plink_output/cluster"$num"_"$chr
# plink --file $output_dir"/cluster"$num"_"$chr --keep "breast_cancer/bc_phenotype.txt" --freqx --out "breast_cancer/plink_output/cluster"$num"_"$chr
