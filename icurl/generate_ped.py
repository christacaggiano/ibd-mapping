import csv 
import sys 
import pandas as pd
from collections import defaultdict

if __name__ == "__main__": 

    input_file = sys.argv[1]
    fam_file = sys.argv[2]
    chrom = sys.argv[3]
    output_file = sys.argv[4]

    MINIMUM_OCCURRENCES = 5

    relevant_fams = pd.read_csv(fam_file, sep="\t", header=None)[0].values

    map_coordinates = {}
    cluster_id_to_count = {}
    fam_dict = defaultdict(dict)

    with open(input_file, "r") as f: 

        input_reader = csv.reader(input_file, delimiter=" ")

        i = 0 
        for line in input_reader: 
            cluster_id = f"c{i}_{chrom}"
            map_coordinates[cluster_id] = [chrom, cluster_id, line[0], line[1]]

            for hap in line[2:]:
                hap_fam = hap.split("_")[0]

                if hap_fam in relevant_fams: 
                    fam_dict[hap_fam][cluster_id] +=1 
                    cluster_id_to_count[cluster_id] += 1  

                i += 1

    cluster_ids_that_meet_threshold = [cluster_id for cluster_id in map_coordinates if cluster_id_to_count[cluster_id] > MINIMUM_OCCURRENCES]

    with open(f"{output_file_name}.ped", "w") as output_file: 
        output_writer = csv.writer(output_file, delimiter=" ")

        for cluster_id in cluster_ids_that_meet_threshold: 
            line = map_coordinates[cluster_id]
            output_writer.writerow(line)

    diploid_cluster_ids = [f"{c}_{i}" for c in cluster_ids_that_meet_threshold for i in range(2)]
    
    with open(f"{output_file_name}.ped", "w") as output_file:
            fieldnames = ["ID"] + diploid_cluster_ids

            output_writer = csv.DictWriter(output_file, fieldnames=fieldnames, delimiter=" ")
            # output_writer.writeheader()

            for fam in relevant_fams:
                row_dict = {"ID": fam}

                row_dict.update({f"{cluster_id}_0": fam_dict [fam] [f"{cluster_id}_0"]})
                row_dict.update({f"{cluster_id}_1": fam_dict [fam] [f"{cluster_id}_1"]})

                output_writer.writerow(row_dict)