import csv 
import sys 
import pandas as pd
from collections import defaultdict
import pickle as pkl 

def f():
    return defaultdict(int)

if __name__ == "__main__": 

    input_file = sys.argv[1]
    fam_file = sys.argv[2]
    chrom = sys.argv[3]
    output_file_name = sys.argv[4]

    MINIMUM_OCCURRENCES = 2

    relevant_fams = pd.read_csv(fam_file, sep="\t", header=None)[0].astype(str).values
    map_coordinates = defaultdict(dict)
    cluster_id_to_count = defaultdict(int)
    fam_dict =  defaultdict(f)

    with open(input_file, "r") as f: 

        input_reader = csv.reader(f, delimiter=" ")

        i = 0 
        for line in input_reader: 

            cluster_id = f"c{i}_{chrom}"

            map_coordinates[cluster_id] = [chrom, cluster_id, int(line[0]), int(line[1])]

            for hap in line[2:]:
                hap_fam = hap.split("_")[0]

                if hap_fam in relevant_fams: 

                    if "_1" in hap: 
                        fam_dict[hap_fam][f"{cluster_id}_1"] +=1 
                    else: 
                        fam_dict[hap_fam][f"{cluster_id}_0"] +=1
                    
                    cluster_id_to_count[cluster_id] += 1  

            i += 1

    cluster_ids_that_meet_threshold = [cluster_id for cluster_id in map_coordinates if cluster_id_to_count[cluster_id] >= MINIMUM_OCCURRENCES]

    with open(f"{output_file_name}.map", "w") as output_file: 
        output_writer = csv.writer(output_file, delimiter=" ")

        for cluster_id in cluster_ids_that_meet_threshold: 
            line = map_coordinates[cluster_id]
            output_writer.writerow(line)

    del map_coordinates

    diploid_cluster_ids = [item for pair in zip([f"{c}_0" for c in cluster_ids_that_meet_threshold], [f"{c}_1" for c in cluster_ids_that_meet_threshold]) for item in pair]

    pkl.dump(cluster_ids_that_meet_threshold, open(f"{output_file_name}_cluster_ids_that_meet_threshold.pkl", "wb"))
    pkl.dump(fam_dict, open(f"{output_file_name}_fam_dict.pkl", "wb"))
    
    with open(f"{output_file_name}.ped", "w") as output_file:
        fieldnames = ["ID", "FID", "PID", "MID", "SEX", "PHENO"] + diploid_cluster_ids
        output_writer = csv.writer(output_file,  delimiter=" ")
        # output_writer.writeheader()

        for fam in relevant_fams:
            # Write data incrementally
            row_list = [fam, fam, 0, 0, 0, -9]

            for cluster_id in cluster_ids_that_meet_threshold:
                # Write data for each cluster_id
                row_list.append(fam_dict[fam][f"{cluster_id}_0"] + 1)
                row_list.append(fam_dict[fam][f"{cluster_id}_1"] + 1)

                # Update fam_dict
                del fam_dict[fam][f"{cluster_id}_0"]
                del fam_dict[fam][f"{cluster_id}_1"]

            # Write the row to the output file
            output_writer.writerow(row_list)
