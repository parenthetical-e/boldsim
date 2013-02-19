""" For every model in the provided hdf file, and for the selected stat and 
criterion, tabulate the AUC (area under the curve) at or above criterion for 
each condition in each model.  Save the result to a csv table named tablename 
(.csv is added automatically).

Usage: python plot_rw_above hdf stat criterion tablename
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
    if len(posargs) != 4:
        raise ValueError("Four arguments are required.\n")
    
    hdf = posargs[0]
    stat = posargs[1]
    criterion = float(posargs[2])
    name = posargs[3]

    # Create csv writer named name
    # And give it a header
    f = open('{0}_{1}{2}.csv'.format(name, stat, criterion), 'w')
    csvw = csv.writer(f)
    csvw.writerow(["area", "model", "boldmeta", "dmmeta", "cond"])

    models = get_model_names(hdf)
    for model in models:
        hist_list = create_hist_list(hdf, model, stat)
        
        # Loop over the hist_list adding
        # the results from each hist.above(criterion)
        # to a bar plot.
        areas = [hist.above(criterion) for hist in hist_list]
        names = [hist.name for hist in hist_list]
        
        # Pretty things up then save 
        # this barplot to the pdf
        # and move onto the next model
        meta = get_model_meta(hdf, model)
        boldmeta = "_".join([str(b) for b in meta["bold"]])
        dmmeta = "_".join([str(d) for d in meta["dm"]])
        
        for area, name in zip(areas, names):
            row = [area, model, boldmeta, dmmeta, name]
            csvw.writerow(row)
        
    f.close()


if __name__ == "__main__":
    
    posargs = sys.argv[1:]
    main(posargs)