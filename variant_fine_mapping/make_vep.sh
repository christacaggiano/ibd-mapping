#!/bin/bash
# BSUB -P acc_kennylab
# BSUB -n 1
# BSUB -W 5:00
# BSUB -q premium
# BSUB -R rusage[mem=60000]
# BSUB -J "vep[22]"
# BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/exomes/logs/vep.out.%J.%I 
# BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/exomes/logs/vep.err.%J.%I 


##BSUB -P acc_kennylab
##BSUB -W 6:00
##BSUB -q premium
## BSUB -R span[ptile=16]
## BSUB -R himem
###BSUB -R rusage[mem=60000]
##BSUB -J "vep[1-22]"
##BSUB -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/exomes/logs/vep.out.%J.%I 
##BSUB -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/exomes/logs/vep.err.%J.%I 

. /sc/arion/projects/igh/kennylab/christa/miniforge/etc/profile.d/conda.sh

chr=$LSB_JOBINDEX 

########################### extract per chromosome information from exome files #################################
# conda activate ibd

# plink --bfile /sc/arion/projects/MSM/data/WES/combined/batch_001/plink/All/SINAI_MILLION_ALL_PASS \
#     --chr $chr \
#     --recode vcf \
#     --out "vep/chr"$chr"_only"

# gzip -f "vep/chr"$chr"_only.vcf"
# bcftools sort -i "vep/chr"$chr"_only.vcf.gz" -O z -o "vep/chr"$chr"_only.vcf.gz"
# tabix -f "vep/chr"$chr"_only.vcf"

# ../../plink2 --vcf "vep/chr"$chr"_only.vcf.gz" \
#     --geno-counts \
#     --out "vep/chr"$chr"_only"

# ../../plink2 --vcf "vep/chr"$chr"_only.vcf.gz" \
#     --make-bed \
#     --out "vep/chr"$chr"_only"

# gunzip "vep/chr"$chr"_only.vcf.gz"
# bgzip -c "vep/chr"$chr"_only.vcf" > "vep/chr"$chr"_only.vcf.gz"
# tabix -f "vep/chr"$chr"_only.vcf.gz"

# ../../plink2 --bfile "vep/chr22_only" \
#     --recode 'A' \
#     --extract test_ids.txt \
#     --out "vep/chr22_only"

########################### annotate with relevant VEP information #################################
conda activate vep

######### do vep annotation 
   
# vep -i "vep/chr"$chr"_only.vcf.gz" \
#     --plugin AlphaMissense,file=../../reference/alpha_missense/AlphaMissense_hg38.tsv.gz \
#     --plugin PrimateAI,../../reference/primateAI/PrimateAI_scores_v0.2_GRCh38_sorted.tsv.bgz \
#     --custom file=../../reference/clinvar/clinvar.vcf.gz,short_name=ClinVar,format=vcf,type=exact,coords=0,fields=CLNSIG%CLNREVSTAT%CLNDN \
#     --plugin REVEL,file=../../reference/revel/new_tabbed_revel_grch38.tsv.gz \
#     --plugin Phenotypes,dir=../../reference/vep/ \
#     --assembly GRCh38 \
#     --dir_cache ../../reference/vep/ \
#     --af \
#     --af_gnomad \
#     --allele_number \
#     --sift p \
#     --polyphen p \
#     --force_overwrite \
#     --fork 16 \
#     --cache \
#     --pick \
#     --offline \
#     --no_stats \
#     --tab \
#     --fields "Location,Uploaded_variation,Existing_variation,SYMBOL,Gene,Protein_position,Amino_acids,Codons,gnomADe_AF,gnomADe_AFR_AF,gnomADe_AMR_AF,gnomADe_ASJ_AF,gnomADe_EAS_AF,gnomADe_FIN_AF,gnomADe_MID_AF,gnomADe_NFE_AF,gnomADe_REMAINING_AF,gnomADe_SAS_AF,Consequence,CLIN_SIG,ClinVar,ClinVar_CLNSIG,ClinVar_CLNREVSTAT,PHENOTYPES,IMPACT,SIFT,PolyPhen,REVEL,am_class,PrimateAI" \
#     --output_file "vep/chr"$chr"_vep_clinvar.txt"
    

## re-format vep file for merging with significant cliques 

# grep -v "^##" "vep/chr"$chr"_vep_clinvar.txt" > "vep/chr"$chr"_vep2.txt"

# awk -F'\t' '{
#     if (NR == 1) {
#         print "0\t1\t2\t" $0
#     } else {
#         if ($1 ~ /-/) {  # If the first column contains a dash
#             split($1, a, "[:-]")  # Split on both colon and dash
#             print a[1] "\t" a[2] "\t" a[3] "\t" $0
#         } else {  # Original case without dash
#             split($1, a, ":")
#             print a[1] "\t" a[2] "\t" a[2]+1 "\t" $0
#         }
#     }
# }' "vep/chr"$chr"_vep2.txt" > "vep/chr"$chr"_vep.bed"

# rm "vep/chr"$chr"_vep2.txt"

########################### merge with the significant clique information #################################

# rm "pr_vep/chr"$chr"_vep_phers_clique_sig.txt"
# (paste <(head -n 1 "../all_phenotypes_continuous/significant_results/pr/results_by_chrom/recessive/pr_phers_sig_chr"$chr".txt") \
#        <(head -n 1 "vep/chr"$chr"_vep_frq.bed")) > "pr_vep/chr"$chr"_vep_phers_clique_sig.txt"

# # Run intersection without headers, skipping header lines
# (bedtools intersect -a <(tail -n +2 "../all_phenotypes_continuous/significant_results/pr/results_by_chrom/recessive/pr_phers_sig_chr"$chr".txt") \
#                    -b <(tail -n +2 "vep/chr"$chr"_vep_frq.bed") \
#                    -loj) >> "pr_vep/chr"$chr"_vep_phers_clique_sig.txt"


# head -n 1 "pr_vep/chr"$chr"_vep_phers_clique_sig.txt" > "pr_vep/chr"$chr"_vep_phers_clique_sig_header"
# tail -n +2 "pr_vep/chr"$chr"_vep_phers_clique_sig.txt" | split -l 1000 - "pr_vep/chr"$chr"chunk_"

# for f in "pr_vep/chr"$chr"chunk_"*; do
#     outf=$f"_out"
    
#     cat "pr_vep/chr"$chr"_vep_phers_clique_sig_header" $f > $f"tmp" && mv $f"tmp" $f

#     bsub -P acc_kennylab \
#         -n 1 \
#         -W 2:00 \
#         -q premium \
#         -R rusage[mem=5000] \
#         "python get_clique_counts.py $chr $f $outf"

# done


# awk 'FNR==1 && NR!=1 {next} {print}' "pr_vep/chr"$chr"chunk_"*out  > "pr_vep/chr"$chr"_clique_variant_counts_phers.csv" 
# rm "pr_vep/chr"$chr"chunk"*

# python filter.py
awk 'FNR==1 && NR!=1 {next} {print}' "pr_vep/"*"_vep_results_hom_only_phers.csv"  > "pr_vep/all_vep_results_hom_only_phers.csv"
