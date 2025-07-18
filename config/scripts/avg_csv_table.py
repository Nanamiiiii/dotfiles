#! /usr/bin/env nix-shell
#! nix-shell -i python3 -p python3Packages.pandas python3Packages.numpy
import pandas as pd
import numpy as np
import glob

csv_files = glob.glob("./*.csv")
base = pd.read_csv(csv_files[0], index_col=0).to_numpy()
for path in csv_files[1:]:
    data = pd.read_csv(path, index_col=0).to_numpy()
    base += data
average = base / len(csv_files)
df_avg = pd.DataFrame(average, index=pd.read_csv(
    csv_files[0], index_col=0).index, columns=pd.read_csv(csv_files[0], index_col=0).columns)
df_avg.to_csv("average.csv", index=True, header=True)
