#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 12:00
#BSUB -q premium
#BSUB -R rusage[mem=60000]
#BSUB -J "dash[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/dash.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/dash.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate ibd

##### dash cc 
chr=$LSB_JOBINDEX 

pheno="comparison/height/height_pheno_vital.txt"
input_file="height/dash_output/dashcc/cluster2_"$chr
output_dir="comparison/height/dashcc/"
output_file=$output_dir"/cluster2_"$chr

mkdir -p $output_dir

plink2 --bfile $input_file \
    --freqx \
    --pheno $pheno \
    --glm recessive \
    --out $output_file
