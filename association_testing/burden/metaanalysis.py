import pandas as pd
import numpy as np
from scipy.stats import norm
import os

# --- 1. CONFIGURATION ---
# Please set these variables to match your project structure.

# Path to the file containing the phenotype list in its header.
PHENOTYPE_FILE = "/sc/arion/projects/igh/kennylab/christa/mapping_ibd/rare_variant_gwas/burden/aj/pcs5/phecodes_all_pcs5_ID_phen.txt"

# List of population codes to include in the meta-analysis.
POPULATIONS = ["AFR", "EUR", "EAS", "SAS", "AMR"]

# Directory where the final meta-analysis CSV files will be saved.
OUTPUT_DIR = "metaanalysis/gene_p"

# Template for the input file paths.
# {pop} will be replaced by the population code (e.g., "AFR").
# {pheno} will be replaced by the phenotype name (e.g., "GE_961.81").
# IMPORTANT: Please verify this template matches your file naming convention.
FILE_PATH_TEMPLATE = "{pop}/nextflow/final_results/{pop}_{pheno}_combined.regenie"

TEST="GENE_P"  # The test type to filter on.

# --- Stouffer's Meta-Analysis Function (Unchanged) ---
def stouffers_meta(group):
    p_values = 10**(-group["LOG10P.Y1"])
    z_scores = norm.isf(p_values)
    weights = np.sqrt(pd.to_numeric(group["N"], errors="coerce"))
    numerator = np.nansum(weights * z_scores)
    denominator = np.sqrt(np.nansum(weights**2))
    if denominator == 0:
        return pd.Series({"N_TOTAL": 0, "Z_META": np.nan, "P_META": np.nan})
    z_meta = numerator / denominator
    p_meta = norm.sf(z_meta)
    n_total = group["N"].sum()
    return pd.Series({"N_TOTAL": n_total, "Z_META": z_meta, "P_META": p_meta})

# --- Main Script Logic ---
try:
    with open(PHENOTYPE_FILE, "r") as f:
        header = f.readline()
        pheno_list = header.strip().split("\t")[4:]
    print(f"✅ Successfully found {len(pheno_list)} phenotypes to process.")
except FileNotFoundError:
    print(f"❌ ERROR: Phenotype file not found at: {PHENOTYPE_FILE}")
    pheno_list = []

os.makedirs(OUTPUT_DIR, exist_ok=True)

meta_summary_log = []
# Iterate over each phenotype and perform the meta-analysis.
print("Starting meta-analysis for phenotypes...")
for pheno in pheno_list:
    print(f"\n--- Starting meta-analysis for phenotype: {pheno} ---")
    
    all_dfs_for_pheno = []
    
    for pop in POPULATIONS:
        file_path = FILE_PATH_TEMPLATE.format(pop=pop, pheno=pheno)
        if not os.path.exists(file_path):
            print(f"  - ⚠️ Warning: File not found for population {pop}. Skipping. Path: {file_path}")
            continue
        try:
            print(f"  - Loading data for {pop}...")
            df_pop = pd.read_csv(file_path, sep=" ", low_memory=False, comment="#")
            
            df_pop["N"] = pd.to_numeric(df_pop["N"], errors="coerce")
            df_pop["N"] = df_pop["N"].min()
            
            df_pop = df_pop[df_pop["TEST"] == TEST].copy()
            
            df_pop["POP"] = pop
         
            df_pop["LOG10P.Y1"] = pd.to_numeric(df_pop["LOG10P.Y1"], errors="coerce")
            df_pop = df_pop[df_pop["LOG10P.Y1"] > 0]
            df_pop = df_pop.dropna(subset=["LOG10P.Y1", "N"])

            if df_pop.empty:
                print(f"    - ⚠️ No valid data after filtering for population {pop}. Skipping.")
                continue
            
            all_dfs_for_pheno.append(df_pop)
            
        except Exception as e:
            print(f"  - ❌ Error processing file {file_path}: {e}")

    
    if len(all_dfs_for_pheno) >= 2:
        # If the condition is met, run the meta-analysis.
        print(f"  - Found data for {len(all_dfs_for_pheno)} populations. Proceeding with meta-analysis...")
        df_combined = pd.concat(all_dfs_for_pheno, ignore_index=True)
        
        # Get a list of unique populations that contributed data.
        contributing_pops = df_combined["POP"].unique().tolist()
        # Calculate the total sample size across all contributing populations.
        total_n = int(df_combined["N"].sum())
        
        # Add the summary info for this phenotype to our log list.
        meta_summary_log.append({
            "Phenotype": pheno,
            "Contributing_Populations": ", ".join(contributing_pops),
            "Total_Sample_Size": total_n
        })
        
        meta_results = df_combined.groupby("ID").apply(stouffers_meta).reset_index()
        meta_results_sorted = meta_results.sort_values(by="P_META", ascending=True)

        # Save the output to a phenotype-specific file.
        output_filename = os.path.join(OUTPUT_DIR, f"meta_analysis_{pheno}.csv")
        try:
            meta_results_sorted.to_csv(output_filename, index=False)
            print(f"  - ✨ Success! Results for {pheno} saved to: {output_filename}")
        except Exception as e:
            print(f"  - ❌ Error saving results for {pheno}: {e}")
    else:
        # If the condition is not met, print a message and skip to the next phenotype.
        print(f"  - Skipping meta-analysis for '{pheno}'. Found data for only {len(all_dfs_for_pheno)} population(s). At least 2 are required.")

if meta_summary_log:
    print("\nSaving meta-analysis summary log...")
    summary_df = pd.DataFrame(meta_summary_log)
    summary_filename = os.path.join(OUTPUT_DIR, "meta_analysis_summary_log.csv")
    try:
        summary_df.to_csv(summary_filename, index=False)
        print(f"✅ Summary log saved to: {summary_filename}")
    except Exception as e:
        print(f"❌ Error saving summary log: {e}")

print("\nAll phenotypes processed.")