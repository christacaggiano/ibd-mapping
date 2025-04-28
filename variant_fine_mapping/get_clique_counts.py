import pandas as pd
import pickle as pkl
import pysam
import sys 

def id_conversion(id_array, id_map):
    """Convert IDs using a mapping, with fallback to the original values."""
    return set(pd.Series(id_array).map(id_map).fillna(pd.Series(id_array)))

def process_clique(clique, clique_membership, id_map, vcf):
    """Process a single clique and count het and hom genotypes."""
    # Convert IDs for het and hom individuals    
    het_ind = id_conversion(clique_membership[clique["name"]]["het"], id_map)
    hom_ind = id_conversion(clique_membership[clique["name"]]["hom"], id_map)

    chr, start, end = clique["0.1"][3:], int(clique["1"]), int(clique["2.1"])
    true_alleles = clique["Uploaded_variation"].split(":")[2], clique["Uploaded_variation"].split(":")[3]
    
    het = 0
    hom = 0

    # Fetch relevant records from VCF
    for record in vcf.fetch(chr, start - 1, end):  # Fetch is 0-based

        if record.pos == start and record.alleles == true_alleles:  # Match exact position
            for sample_name, sample_data in record.samples.items():
                if sample_name in het_ind:
                    genotype = sample_data["GT"]
                    counts = sum(x if x is not None else 0 for x in genotype)

                    if counts == 1:
                        het += 1
                    
                elif sample_name in hom_ind: 
                    genotype = sample_data["GT"]
                    counts = sum(x if x is not None else 0 for x in genotype)
                    
                    if counts == 2:
                        hom += 1
                    
    return het, hom

if __name__ == "__main__":
    
    chr = sys.argv[1]
    input_file = sys.argv[2]
    output_file = sys.argv[3]

    # Load and prepare ID map
    id_map_key = pd.read_csv("/sc/arion/projects/igh/data/MSM/id_maps/MSM_to_masked_mrn_map_updated_missing_MRNs.txt", sep="\t").drop_duplicates(subset="MM")
    id_map_key["ID"] = id_map_key["MILLION_ID"] + "_" + id_map_key["MILLION_ID"]
    id_map = dict(zip(id_map_key["MM"], id_map_key["ID"]))

    # Load clique membership and significant cliques
    clique_membership = pkl.load(open(f"../icurl/libd_updated/pr/pr_{chr}_clique_ind.pkl", "rb"))
    significant_cliques = pd.read_csv(input_file, sep="\t")

    # Open VCF file
    vcf = pysam.VariantFile(f"mssm_exome/chr{chr}_only.vcf.gz")

    # Process each clique and count genotypes
    results = []
    for _, clique in significant_cliques.iterrows():
        if clique["Uploaded_variation"] != ".": 
            het, hom = process_clique(clique, clique_membership, id_map, vcf)
            results.append((clique["name"], clique["phecode"], clique["Uploaded_variation"], het, hom))

    # Append results to the DataFrame and save 
    pd.DataFrame(results, columns=["clique", "phecode", "variant", "het", "hom"]).to_csv(output_file, index=False)

   