#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -n 24
#BSUB -W 24:00
#BSUB -q premium
#BSUB -R rusage[mem=12000]
#BSUB -J "saige[1-22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/saige.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/saige.err.%J.%I 

module load singularity/3.6.4

chr=$LSB_JOBINDEX 

singularity exec finngenn_saige.simg /sc/arion/projects/igh/kennylab/christa/mapping_ibd/pipeline_saige.sh $chr


# awk 'FNR==1 && NR!=1 {next} {print}' "height_saige/output_36/output_"*"_test.txt" > "height_saige/output_36/output_height_all.txt" 


############# create sparse GRM for a cluster based on genotypes 
# # createSparseGRM.R \
# #      --plinkFile="../clusters_ibd/infomap/plink_files/cluster"$num \
# #      --nThreads=24 \
# #      --outputPrefix="height_saige/grm/cluster"$num \
# #      --numRandomMarkerforSparseKin=2000 \
# #      --relatednessCutoff=0.125

# --useSparseGRMtoFitNULL=TRUE \
# --sparseGRMFile="height_saige/grm/cluster"$num"_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx" \
# --sparseGRMSampleIDFile="height_saige/grm/cluster"$num"_relatednessCutoff_0.125_2000_randomMarkersUsed.sparseGRM.mtx.sampleIDs.txt" \
