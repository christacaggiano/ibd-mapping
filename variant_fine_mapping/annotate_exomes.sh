#!/bin/bash
#BSUB -P acc_kennylab
#BSUB -n 1
#BSUB -W 12:00
#BSUB -q premium
#BSUB -R rusage[mem=30000]
#BSUB -J "exomes[22]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/exomes.out.%J.%I 
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/exomes.err.%J.%I 


. /sc/arion/projects/igh/kennylab/christa/miniconda/etc/profile.d/conda.sh
conda activate ibd


chrom=$LSB_JOBINDEX

# file="annotations/"$chrom".clinvar20240611_vep110.regen.exome.biallelic.over18.withoutRelatives.txt"
file="/sc/arion/projects/kennylab/kathleen/deCAP/results/chrom_level/regen_exome/"$chrom".clinvar20240611_vep110.regen.exome.multiallelic.over18.withoutRelatives.txt" 

awk -v OFS='\t' '{print $1, $2, $2}' $file > "annotations/multi/"$chrom
paste "annotations/multi/"$chrom $file > "annotations/multi/"$chrom".bed"
tail -n +5 "annotations/multi/"$chrom".bed" > "annotations/multi/"$chrom
mv "annotations/multi/"$chrom "annotations/multi/"$chrom".bed"

# cat annotations/*.bed > combined_annotations.bed

