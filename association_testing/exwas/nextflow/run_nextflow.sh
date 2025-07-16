#!/bin/bash

#BSUB -P acc_kennylab
#BSUB -J "nextflow_driver"
#BSUB -q premium
#BSUB -n 1
#BSUB -W 24:00
#BSUB -R "rusage[mem=8000]"
#BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/nextflow/logs/nextflow_driver.out.%J
#BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/nextflow/logs/nextflow_driver.err.%J


. /sc/arion/projects/igh/kennylab/christa/miniforge/etc/profile.d/conda.sh
conda activate nextflow

pop="EUR"
nextflow run main.nf \
   --pheno /sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/phecodes/${pop}/pcs5/phecodes_all_pcs_ID_phen.txt \
   --covar /sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/phecodes/${pop}/pcs5/phecodes_all_pcs_ID_covs.txt \
   --output_dir /sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/phecodes/${pop}/nextflow \
   --pop ${pop} \
   --test_type recessive \
   -profile lsf \
   -with-report \
   -with-trace \
   --cleanup 
