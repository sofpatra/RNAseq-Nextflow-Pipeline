#!/usr/bin/env python3

import argparse
import pandas as pd
import os

# Set up argument parsing
parser = argparse.ArgumentParser(description="Concatenate VERSE output files into a single counts matrix.")
parser.add_argument('-i', '--input', nargs='+', required=True, help="List of VERSE output files.")  # Accepts multiple files
parser.add_argument('-o', '--output', required=True, help="Output file for the concatenated counts matrix.")
args = parser.parse_args()


concat = pd.concat([pd.read_csv(df, sep='\t', header=0, names = ['gene', '{}'.format(os.path.basename(df.split('.')[0]))], index_col='gene') for df in args.input], axis=1)

concat.to_csv(args.output) 