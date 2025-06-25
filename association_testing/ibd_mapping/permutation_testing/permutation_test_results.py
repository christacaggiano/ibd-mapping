import pandas as pd 
import numpy as np


if __name__ == "__main__": 

    pheno = "pheno"
    pop = "aj"
    num = "pheno61"

    directory = f"all_phenotypes_binary/phecodes/{pop}/permutation_test/"
    regenie_dir = f"{directory}/{num}/icurl"
    results_dir = f"{directory}/results"

    perm_num = 3000 
    ibd_region_size = 22060

    sig_values = np.zeros(shape=(perm_num, ibd_region_size))

    for p in range(1, perm_num+1): 
        df = pd.read_csv(f"{regenie_dir}/{pop}_{pheno}_perm{p}_combined.regenie", sep=" ")
        df = df.sort_values(by="ID")

        df["p"] = 10**(-df["LOG10P.Y1"]) 
        sig_values[p-1, :] = df["p"].values

    pd.DataFrame(sig_values).to_csv(f"{results_dir}/{num}_CM_761_pvalues.csv", index=False)

    true = pd.read_csv("all_phenotypes_binary/phecodes/aj/pcs/regenie/icurl/aj_CM_761_combined.regenie", sep=" ")
    true = true[true["ID"].isin(df["ID"])].sort_values(by="ID")

    true["p"] = 10**(-true["LOG10P.Y1"])
    true = true.reset_index()

    emp_pval_list = []
    for i, row in true.iterrows(): 
        true_pval = row["p"] 

        perm_pval_count = np.sum(sig_values[:, i] < true_pval)

        if perm_pval_count == 0: 
            perm_pval_count += 0.05

        emp_pval = perm_pval_count/perm_num
        emp_pval_list.append(emp_pval)

    
    true["empirical pval"] = emp_pval_list
    true.to_csv("all_phenotypes_binary/phecodes/aj/permutation_test/results/aj_CM_761_permutation_combined.regenie", sep=" ", index=False)

