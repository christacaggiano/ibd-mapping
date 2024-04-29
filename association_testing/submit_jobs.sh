#!/bin/bash

# output_dir="all_phenotypes_continuous/phers/cluster2/"
# pheno=$output_dir"/phers_1_100_phen.txt" 
# covar=$output_dir"/phers_1_100_covs.txt"
pop="pr"
num="2" 

output_dir="all_phenotypes_binary/phecodes/pr/regenie/"
pheno=$output_dir"/phecodes1_100_phen.txt" 
covar=$output_dir"/phecodes1_100_covs.txt"
pop="pr"
num="2" 

for i in {3..50}
do 

    # pheno_num=$(awk -F '\t' -v  col="$i" 'NR==1 {print $col}' all_phenotypes_continuous/phers/cluster2/phers_1_100_phen.txt) 

    # bsub -P acc_kennylab \
    #     -n 1 \
    #     -W 12:00 \
    #     -q premium \
    #     -R rusage[mem=10000] \
    #     -J "plink[1-22]" \
    #     -e /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/plink.err.%J.%I \
    #     -o /sc/arion/projects/igh/kennylab/christa/mapping_ibd/logs/plink.out.%J.%I \
    #     "sh run_plink_quant.sh $output_dir $pheno $covar $pheno_num $pop $num"

    pheno_num=$(awk -F '\t' -v  col="$i" 'NR==1 {print $col}' all_phenotypes_binary/phecodes/pr/regenie/phecodes1_100_phen.txt) 

    bsub -P acc_kennylab \
        -n 28 \
        -W 12:00 \
        -R span[hosts=1] \
        -q premium \
        -R rusage[mem=2000] \
        -J "regenie[1-22]" \
        "sh run_regenie_binary.sh $output_dir $pheno $covar $pheno_num $pop $num"

#     awk 'FNR==1 && NR!=1 {next} {print}' $output_dir"/icurl/"$pop"_"*"_"$pheno_num".regenie"  > $output_dir"/icurl/"$pop"_"$pheno_num"_combined.regenie" 
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num".regenie"
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num"_snps_pass.log"
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num".log"
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num"_pred.list"
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num".regenie.Ydict"
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num"_snps_pass.snplist"
#     rm $output_dir"/icurl/"$pop"_"*"_"$pheno_num".loco"

done

