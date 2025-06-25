import pandas as pd
import sys 
import os 
import numpy as np

def return_covs(df, pca_file): 
    id_map_file = pd.read_csv("../../data/biome/pheno/ID_Masked_Mrn_Mapping.csv")
    id_map_file["MASKED_MRN"] = id_map_file["MASKED_MRN"].astype(str)

    questionnaire = pd.read_csv("../pheno/Questionnaire.txt", sep="|", low_memory=False)
    questionnaire = questionnaire.merge(id_map_file, left_on="subject_id", 
                                    right_on="SUBJECT_ID", how="left")

    pcs = pd.read_csv(pca_file, sep="\t")
    pcs["IID"] = pcs["IID"].astype(str)
    
    questionnaire["age"] = 2024 - questionnaire["YEAR_OF_BIRTH"]
    questionnaire["GENDER"] = questionnaire["GENDER"].replace({"Male":0, "Female":1, "Unknown":np.nan})

    covs = df.merge(questionnaire[["age", "GENDER", "MASKED_MRN"]], left_on="MASKED_MRN", right_on="MASKED_MRN", how="left")
    covs_pca = covs.merge(pcs, left_on=0, right_on="IID")
    covs_pca = covs_pca.rename(columns={0:"FID"})

    return covs_pca[["FID", "IID", "age", "GENDER"]].drop_duplicates(subset="FID").dropna()

    # return covs_pca[["FID", "IID", "age", "GENDER"] + [f"PC{i}" for i in range(1, 11)]].drop_duplicates(subset="FID").dropna()

def return_phen(df, covs):

    keep_ids = covs["FID"].unique()

    df_keep = df[df[0].isin(keep_ids)]
    df_keep = df_keep.replace({False:1, True:2})
    df_keep = df_keep.rename(columns={0:"FID", 1:"IID"})

    return_columns = [0, 1] + list(range(7, len(list(df))))

    return df_keep.iloc[:, return_columns].drop_duplicates(subset="FID")


if __name__ == "__main__":

    phecode_str = sys.argv[1]
    output_file_name = sys.argv[2]
    fam_file = sys.argv[3]
    pca_file = sys.argv[4]

    phecode_file = pd.read_csv("../pheno/phecodeTable_BioMe_withSexPhecode_MinCount1_mrn.csv")
    phecode_file["MASKED_MRN"] = phecode_file["MASKED_MRN"].astype(str)

    phecode = phecode_file[["MASKED_MRN", phecode_str]]

    fam = pd.read_csv(fam_file, sep="\t", header=None)
    fam[0] = fam[0].astype(str)

    fam_pheno = fam.merge(phecode, left_on=0, right_on="MASKED_MRN")
   
    covs = return_covs(fam_pheno, pca_file)
    # covs = covs[covs["GENDER"] == 1]
    # covs = covs.drop(["GENDER"], axis=1)

    phen = return_phen(fam_pheno, covs)

    print(phen[phecode_str].value_counts())

    covs.to_csv(f"{output_file_name}_covs.txt", sep="\t", index=False)
    phen.to_csv(f"{output_file_name}_phen.txt", sep="\t", index=False)

