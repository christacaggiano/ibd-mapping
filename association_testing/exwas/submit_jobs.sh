#!/bin/bash

pop="pr"
input_file="" 
output_dir="phecodes/"$pop"/pcs20"
pheno=$output_dir"/phecodes_all_pcs20_ID_phen.txt" 
covar=$output_dir"/phecodes_all_pcs20_ID_covs.txt"

mkdir -p $output_dir

for i in {5..5}
do 

    # pheno_num=$(awk -F '\t' -v  col="$i" 'NR==1 {print $col}' $pheno)
    pheno_num="GE_970"

#    if [ ! -f $output_dir"/"$pop"_"$pheno_num"_combined.regenie" ]; then
#        bsub -P acc_kennylab \
#            -n 1 \
#            -W 1:00 \
#            -R span[hosts=1] \
#            -q premium \
#            -R rusage[mem=16000] \
#            -o "logs/"$pop"_"$pheno_num".out.%J.%I" \
#            -J "variant[1-22]" \
#            "sh run_regenie_binary.sh $output_dir $pheno $covar $pheno_num $pop $input_file"
# #    fi 
    
    #  if [ -f $output_dir"/exwas/"$pop"_22_"$pheno_num".regenie" ]; then
        echo $pheno_num
        awk 'FNR==1 && NR!=1 {next} {print}' $output_dir"/exwas/"$pop"_"*"_"$pheno_num".regenie"  > $output_dir"/exwas/"$pop"_"$pheno_num"_combined.regenie" 
        rm -f  $output_dir"/exwas/"$pop"_"*"_"$pheno_num".regenie"
        rm -f $output_dir"/exwas/"$pop"_"*"_"$pheno_num"_snps_pass.log"
        rm -f $output_dir"/exwas/"$pop"_"*"_"$pheno_num".log"
        rm -f $output_dir"/exwas/"$pop"_"*"_"$pheno_num"_pred.list"
        rm -f $output_dir"/exwas/"$pop"_"*"_"$pheno_num".regenie.Ydict"
        rm -f $output_dir"/exwas/"$pop"_"*"_"$pheno_num"_snps_pass.snplist"
        rm -f $output_dir"/exwas/"$pop"_"*"_"$pheno_num"_1.loco"
        rm -f $output_dir"/exwas/"$pop"*log"
    # fi 

done

# awk 'FNR==1 && NR!=1 {next} {print}' all_phenotypes_binary/phecodes/pr/dom/regenie/icurl/*gcount  >  all_phenotypes_binary/phecodes/pr/dom/regenie//combined_count.txt 



