""" For every model in the provided hdf file(s), and for the selected stat, tabulate mean and standard error for each condition in each model.  Save the result to a csv table named tablename (.csv is added automatically).

Usage: python tabulate_compare stat hdf1 hdf2 [...] tablename
"""
import os
import sys
import csv
import numpy as np
from simfMRI.io import read_hdf, get_model_names, get_model_meta
from simfMRI.analysis.stat import create_hist_list

def main(posargs):

    # Check then handle the positional arguements
    # brough in from the command line
    if len(posargs) < 3:
        raise ValueError("At least three arguments are required.\n")

    name = posargs.pop()
    stat = posargs[0]
    tocompare = posargs[1:]
    
    # Create a csv file to tabulate into
    f = open('{0}_{1}.csv'.format(name, stat), 'w')
    csvw = csv.writer(f)
    csvw.writerow(["mean", "se", "dataset", "model", "boldmeta",
    "dmmeta", "cond"])
    
    models = get_model_names(tocompare[0])  ## Assume models are identical for 
                                            ## each hdf to compare
    for model in models:
        for ii, comp in enumerate(tocompare):
            meta = get_model_meta(comp, model)
            boldmeta = "_".join([str(b) for b in meta["bold"]])
            dmmeta = "_".join([str(d) for d in meta["dm"]])
            
            # Generate the data to add to the table.
            hist_list = create_hist_list(comp, model, stat)
            means = [hist.mean() for hist in hist_list]
            ses = [hist.se() for hist in hist_list]
            names = [hist.name for hist in hist_list]
        
            # And add it.
            databasename = os.path.splitext(comp)[0]
            for mean, se, name in zip(means, ses, names):
                row = [mean, se, databasename, model, boldmeta, dmmeta, name]
                csvw.writerow(row)
    
    f.close()


if __name__ == "__main__":
    
    posargs = sys.argv[1:]
    main(posargs)