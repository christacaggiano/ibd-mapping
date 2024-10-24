import pandas as pd 
import subprocess
import warnings
warnings.filterwarnings("ignore")

if __name__ == "__main__": 
    
    number_of_phecodes = 1000
    fam_file = "aj.fam"
    counts_file = "aj_counts"
    range_file = "aj_range"
    
    # read in raw genotyping and get correct IDs 
    geno = pd.read_csv(f"../icurl/libd/aj/aj_merged.raw", sep=" ", low_memory=False)
    id_map_file = pd.read_csv("../../../data/biome/pheno/ID_Masked_Mrn_Mapping.csv")
    id_map_file["MASKED_MRN"] = id_map_file["MASKED_MRN"].astype(str)
    
    geno = geno.merge(id_map_file, left_on="FID", right_on="MASKED_MRN")
    
    # perform analysis for top 100 candidates by score
    phecodes = pd.read_csv("../simulations/aj_phecode_with_predictions.csv")
    
    # top n phecodes
    phecodes = phecodes.sort_values(by="score", ascending=False)
    top_n = phecodes.drop_duplicates(subset="phecode").head(n=number_of_phecodes)
    print(len(phecodes.drop_duplicates(subset="phecode")))
    phecode_variant_predictions = []
    for i, row in top_n.iterrows(): 
        
        phe = row["phecode"]
        clique = row["name"]
        chr = row["0"]
        
        # range to look for variants in, determined by cliques overlapping significant regions
        min = phecodes[phecodes["phecode"] == phe]["2"].min()-250000
        max = phecodes[phecodes["phecode"] == phe]["2"].max()+250000
        range = f"{chr}:{min}-{max}"
        
        # make the range file to consider in plink 
        cmd = f"echo -e {chr} '\t' {min} '\t' {max} '\t' ID > {range_file}"
        subprocess.run(cmd, shell=True)

        # make fam file of individuals in clique to calculate counts for 
        geno[geno[f"{clique}_2"] == 2][["PAT", "SUBJECT_ID", "PAT",
                                        "MAT", "SEX", "PHENOTYPE"]].to_csv(fam_file, sep="\t", header=None, index=False)
        
        # calculate genotype counts for clique individuals using plink 
        cmd = f"./calculate_geno_counts.sh {fam_file} {chr} {range_file} {counts_file}"
        subprocess.run(cmd, shell=True)
        
        # read in counts 
        counts = pd.read_csv(f"{counts_file}.gcount", sep="\t")
        
        # number of individuals in clique with exome data 
        counts["count"] = counts["HOM_REF_CT"] + counts["HET_REF_ALT_CTS"] + counts["TWO_ALT_GENO_CTS"]
        num_indivs = counts["count"].max()
        
        # snps with recessive counts equal to the number of individuals 
        hom_counts = counts[counts["TWO_ALT_GENO_CTS"] == num_indivs]["ID"]
        
        # read in annotations 
        annotations = pd.read_csv(f"annotations/{chr}_vep.txt", sep="\t", low_memory=False)

        # find variants overlapping clique with their vep predictions and allele frequencies
        overlapping_variants = annotations[annotations["Plink_style_ID"].isin(hom_counts)][["Plink_style_ID", 
                                    "VEP:Consequence", "VEP:IMPACT", "VEP:SYMBOL", "VEP:gnomAD_AF", 
                                    "CLNVR:CLNSIG", "CLNVR:CLNDN","AllSamples_af", "AllSamples_counts"]].sort_values(by="VEP:gnomAD_AF")
        
        overlapping_variants["VEP:gnomAD_AF"] = pd.to_numeric(overlapping_variants["VEP:gnomAD_AF"], errors="coerce")
        
        rare_variants = overlapping_variants[(overlapping_variants["AllSamples_af"] < 0.05) | 
                                   (overlapping_variants["VEP:gnomAD_AF"] < 0.05)]
        
        rare_variants["number_of_exome_indivs"] = num_indivs
        
        for j, variant in rare_variants.iterrows():  
            output_row = list(row) + list(variant)
            phecode_variant_predictions.append(output_row)
    
    
    variant_results = pd.DataFrame(phecode_variant_predictions, columns = list(phecodes)+list(rare_variants))
    variant_results.to_csv("aj_top1000_variant_predictions_phecode.csv", index=False)
    
