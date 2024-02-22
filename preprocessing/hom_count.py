import pandas as pd 
import os.path


if __name__ == "__main__": 

    counts = pd.read_csv("all_phenotypes/all_pheno_cluster2_min3_counts.txt", sep="\t")

    total_counts = [] 
    for i in range(2, 1751): 
        
        if os.path.exists(f"all_phenotypes/gcount/adv/PHENO{i}.gcount"):

            df = pd.read_csv(f"all_phenotypes/gcount/adv/PHENO{i}.gcount", sep="\t", low_memory=False)
            
            c = df["TWO_ALT_GENO_CTS"].max()
            passing = len(df[df["TWO_ALT_GENO_CTS"] > 2])

            name = counts[counts["num"] == (i-1)]["index"].values[0]

            total_counts.append([name, c, passing])
            # print(i, df["#CHROM"].nunique())
            # if c >= 3: 
            #     print(name, c)

    output = pd.DataFrame(total_counts)
    output.to_csv("max_hom_counts_adv.csv", index=False)

