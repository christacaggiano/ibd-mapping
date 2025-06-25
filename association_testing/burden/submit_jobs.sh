#!/bin/bash

pop="aj"
input_file="" 
output_dir=$pop
pheno=$output_dir"/phecodes_all_pcs_ID_phen.txt" 
covar=$output_dir"/phecodes_all_pcs_ID_covs.txt"

mkdir -p $output_dir

# for i in {5..5}
# do 

#     # pheno_num=$(awk -F '\t' -v  col="$i" 'NR==1 {print $col}' $pheno)
#     pheno_num="GE_970"
#    if [ ! -f $output_dir"/burden/"$pop"_"$pheno_num"_combined.regenie" ]; then
#        bsub -P acc_kennylab \
#            -n 1 \
#            -W 8:00 \
#            -R span[hosts=1] \
#            -q premium \
#            -R rusage[mem=32000] \
#            -o "logs/"$pop"_"$pheno_num".out.%J.%I" \
#            -J "burden[1-22]" \
#            "sh run_regenie_burden.sh $output_dir $pheno $covar $pheno_num $pop $input_file"
#    fi 


phenos=("GE_970" "CM_765" "SO_376.1" "SS_847.3" "CA_105" "CA_105.1" "MS_741.72" "GE_961.81" "CM_761.1" "CM_765")

for pheno_num in "${phenos[@]}"
do 
    if [ ! -f "$output_dir/burden/${pop}_${pheno_num}_combined.regenie" ]; then
        bsub -P acc_kennylab \
            -n 1 \
            -W 4:00 \
            -R span[hosts=1] \
            -q premium \
            -R rusage[mem=32000] \
            -o "logs/${pop}_${pheno_num}.out.%J.%I" \
            -J "burden[1-22]" \
            "sh run_regenie_burden.sh $output_dir $pheno $covar $pheno_num $pop $input_file"
    fi
    
    #  if [ -f $output_dir"/burden/"$pop"_22_"$pheno_num".regenie" ]; then
    #     echo $pheno_num
    #     awk 'FNR==1 && NR!=1 {next} {print}' $output_dir"/burden/"$pop"_"*"_"$pheno_num".regenie"  > $output_dir"/burden/"$pop"_"$pheno_num"_combined.regenie" 
    #     rm -f  $output_dir"/burden/"$pop"_"*"_"$pheno_num".regenie"
    #     rm -f $output_dir"/burden/"$pop"_"*"_"$pheno_num"_snps_pass.log"
    #     rm -f $output_dir"/burden/"$pop"_"*"_"$pheno_num".log"
    #     rm -f $output_dir"/burden/"$pop"_"*"_"$pheno_num"_pred.list"
    #     rm -f $output_dir"/burden/"$pop"_"*"_"$pheno_num".regenie.Ydict"
    #     rm -f $output_dir"/burden/"$pop"_"*"_"$pheno_num"_snps_pass.snplist"
    #     rm -f $output_dir"/burden/"$pop"_"*"_"$pheno_num"_1.loco"
    #     rm -f $output_dir"/burden/"$pop"*log"
    # fi 

done

# awk 'FNR==1 && NR!=1 {next} {print}' all_phenotypes_binary/phecodes/cb_combined/pcs/icurl/*gcount  >  all_phenotypes_binary/phecodes/cb_combined/pcs/icurl/combined_count.txt 



