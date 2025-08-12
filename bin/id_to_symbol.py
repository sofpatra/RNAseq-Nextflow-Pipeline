#!/usr/bin/env python


import argparse

#initializing the argparse object 
parser = argparse.ArgumentParser()

parser.add_argument("-i", "--input", help='a GTF file', dest="input", required=True)
parser.add_argument("-o", "--output", help='Output file', dest="output", required=True)

# this method will run the parser and input the data into the namespace object
args = parser.parse_args()

# you can access the values on the command line by using `args.input` or 'args.output`


def parse_gtf(gtf_file, output_file):
    """Parses a GTF file and extracts Ensembl gene IDs and gene names."""
    with open(gtf_file, 'r') as infile, open(output_file, 'w') as outfile:
        outfile.write("Ensembl_ID\tGene_Name\n")  # Writing header
        for line in infile:
            if line.startswith("#"):
                continue  # Skip comment lines
                
            fields = line.strip().split("\t")
            if len(fields) < 9 or fields[2] != "gene":  
                continue  # Only process gene entries
                
            attributes = fields[8]  # The last column contains key-value pairs
            gene_id = None
            gene_name = None
                
            # Extracting gene_id and gene_name from attributes
            for attr in attributes.split(";"):
                attr = attr.strip()
                if attr.startswith("gene_id"):
                    gene_id = attr.split(maxsplit=1)[1].strip('"')  # Extract Ensembl ID
                elif attr.startswith("gene_name"):
                    gene_name = attr.split(maxsplit=1)[1].strip('"')  # Extract gene name
                
            if gene_id and gene_name:
                outfile.write(f"{gene_id}\t{gene_name}\n")  # Write to file

# Run the function with parsed arguments
parse_gtf(args.input, args.output)