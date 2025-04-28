from collections import defaultdict
import csv

input_file = "mini_test.txt"
output_file = "test_output.txt"
# Should be dict with key = individual, key = dict of cluster_id, list of [mom, dad]
cluster_counts = defaultdict(lambda: defaultdict(lambda: [0, 0]))
with open(input_file, "r") as f:

    input_reader = csv.reader(f, delimiter="\t")
    header = next(input_reader)[3:]

    max_in_line = 0
    for line in input_reader:

        line_addition = max_in_line
        chrom = line[0]
        start = line[1]
        cm = line[2]

        for ind_idx, ind in enumerate(line[3:]):
            clst0, clst1 = int(ind.split("|")[0]), int(ind.split("|")[1])
            
            clst0 += line_addition
            clst1 += line_addition
            
            max_in_line = max(max_in_line, clst0, clst1)
            
            cluster_counts[header[ind_idx]][f"c{clst0}_{chrom}"][0] += 1
            cluster_counts[header[ind_idx]][f"c{clst1}_{chrom}"][1] += 1

with open(output_file, "w") as outf: 
    csv_writer = csv.writer(outf, delimiter=" ")

    for ind in header: 
        row = [ind]

        for clst in cluster_counts: 
            row.append(cluster_counts[ind][clst][0])
            row.append(cluster_counts[ind][clst][1])
        
        csv_writer.writerow(row)




# import csv 
# import sys 
# import pandas as pd
# from collections import defaultdict

# if __name__ == "__main__": 

#     # input_file = sys.argv[1]
#     # chrom = sys.argv[3]
#     # output_file_name = sys.argv[4]
#     input_file = "test.txt"
#     chrom = 5 

#     position_dict = defaultdict(dict)
#     map_coordinates = defaultdict(dict)
#     cluster_counts = defaultdict(list)

#     with open(input_file, "r") as f: 

#         input_reader = csv.reader(f, delimiter="\t")
#         header = next(input_reader)[3:] 

#         i=1
#         for line in input_reader: 

#             chrom = line[0]
#             start = line[1]
#             cm = line[2]

#             for ind_idx, ind in enumerate(line[3:]): 
#                 clst0, clst1 = int(ind.split("|")[0]), int(ind.split("|")[1])
                
#                 cluster_counts[f"c{clst0*i}_{chrom}"].append(f"{header[ind_idx]}_0") 
#                 cluster_counts[f"c{clst1*i}_{chrom}"].append(f"{header[ind_idx]}_1") 

#             i += 1 


#     for id in header:
#         row_dict = {"ID": fam}   


