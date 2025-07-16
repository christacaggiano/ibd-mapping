#!/usr/bin/env nextflow
nextflow.enable.dsl=2

// ====================================================================================
// ==               P I P E L I N E   P A R A M E T E R S
// ====================================================================================
params.output_dir = '/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/burden/aj/nextflow'
params.geno_dir   = '/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/geno'
params.pop        = 'aj'
params.annotation_files = '/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/burden/annotation_files/all'
params.mask       = '/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/burden/masks'
params.test_pheno = null // Set to a specific phenotype to test, or null for all
params.pheno = '/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/burden/aj/pcs5/phecodes_all_pcs5_ID_phen.txt' 
params.covar = '/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/burden/aj/pcs5/phecodes_all_pcs5_ID_covs.txt'

// ====================================================================================
// ==               P H E N O T Y P E   H A N D L I N G
// ====================================================================================

// --- Define Channels ---
def pheno_list = file(params.pheno).readLines().first().split('\t').drop(4)

if (params.test_pheno) {
    pheno_list = pheno_list.findAll { it == params.test_pheno }
}

ch_phenos = Channel.from(pheno_list)
ch_chromosomes = Channel.from(1..22)

// ====================================================================================
// ==                      W O R K F L O W
// ====================================================================================

workflow {
    // 1. Create every combination of (phenotype, chromosome)
    ch_phenos
        .combine(ch_chromosomes)
        .set { ch_jobs }

    // 2. Run the analysis for each combination
    run_analysis_per_chr(ch_jobs, file(params.pheno), file(params.covar))

    // 3. Group results by phenotype
    run_analysis_per_chr.out
        .groupTuple()
        .set { ch_for_combination }

    combine_and_cleanup(ch_for_combination)
}

// ====================================================================================
// ==                        P R O C E S S E S
// ====================================================================================

process run_analysis_per_chr {
    errorStrategy 'ignore'
    conda 'regenie_env'
    tag "${pheno_name}-chr${chr}"

    input:
    tuple val(pheno_name), val(chr)
    path pheno_file
    path covar_file 

    output:
    tuple val(pheno_name), path("${params.pop}_${chr}_${pheno_name}.regenie")

    script:
    def pop_chr = "${params.pop}_chr${chr}"
    def output_prefix = "${params.pop}_${chr}_${pheno_name}"
    def input_bfile = "${params.geno_dir}/${params.pop}/${pop_chr}"
    def annotation_file_chr = "${params.annotation_files}/annotation_file_chr${chr}"
    def set_file_chr = "${params.annotation_files}/set_file${chr}"

    """
    # COMMAND 1: PLINK
    plink2 \\
        --bfile ${input_bfile} \\
        --exclude ${input_bfile}_monomorphic.txt \\
        --keep ${pheno_file} \\
        --write-snplist \\
        --out ${output_prefix}_snps_pass

    # COMMAND 2: REGENIE STEP 1
    regenie \\
        --step 1 \\
        --bed ${input_bfile} \\
        --covarFile ${covar_file} \\
        --phenoFile ${pheno_file} \\
        --phenoCol "${pheno_name}" \\
        --bsize 1000 \\
        --force-step1 \\
        --bt --cc12 --loocv \\
        --threads ${task.cpus} \\
        --extract ${output_prefix}_snps_pass.snplist \\
        --out ${output_prefix}_step1

    # COMMAND 3: REGENIE STEP 2
    regenie \\
        --step 2 \\
        --bed ${input_bfile} \\
        --covarFile ${covar_file} \\
        --phenoFile ${pheno_file} \\
        --phenoCol "${pheno_name}" \\
        --bsize 1000 \\
        --bt --cc12 \\
        --minMAC 3 \\
        --minCaseCount 3 \\
        --firth \\
        --no-split \\
        --aaf-bins 1,0.01,0.001,0.0001 \\
        --anno-file ${annotation_file_chr} \\
        --set-list ${set_file_chr} \\
        --mask-def ${params.mask} \\
        --vc-tests skato,acato-full \\
        --rgc-gene-p \\
        --threads ${task.cpus} \\
        --pred ${output_prefix}_step1_pred.list \\
        --out ${output_prefix}
    """
}

process combine_and_cleanup {
    publishDir "${params.output_dir}/final_results", mode: 'copy'
    
    // Optimize for I/O intensive task
    cpus 2
    memory '4 GB'
    time '15m'

    input:
    tuple val(pheno_name), path(regenie_files)

    output:
    path "${params.pop}_${pheno_name}_combined.regenie"

    script:
    """
    # Use parallel processing for file combination
    awk 'FNR==1 && NR!=1 {next} {print}' ${regenie_files.join(' ')} > ${params.pop}_${pheno_name}_combined.regenie
    """
}