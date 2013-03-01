""" Get the pairwise correlations (Kendall's tau) between each design matrix column in each model for all simulations in the hdf 

Usage: tabulate_tau hdf tablename"""
import os
import sys
import csv
import numpy as np
from itertools import combinations
from scipy.stats import kendalltau
from simfMRI.io import read_hdf, get_model_names, get_model_meta


def main(hdf, name):
    f = open('{0}.csv'.format(name), 'w')
    csvw = csv.writer(f)
    
    # A header for the table
    head = ["tau", "p",
            "dmcol",
            "bold", 
            "model"]
    csvw.writerow(head)
    
    models = get_model_names(hdf)
    for model in models:
        # Get mode meta data for the table
        meta = get_model_meta(hdf, model)
        
        # Get all the design matrices
        dm = np.array(read_hdf(hdf, '/' + model + '/dm'))

        # Get all the bold signals as a 1d array
        bold = np.array(read_hdf(hdf, '/' + model + '/bold')).flatten()
        boldmeta = "_".join([str(b) for b in meta["bold"]])
            ## And make a nice name; meta['bold'] can be a list
            ## but we need a string....
        
        # Loop over the dm cols in the dm:
        #  axis 1 is a sim index/count, 
        #  axis 2 is the dm row
        #  axis 3 is the dm cols
        for jj in range(dm.shape[2]):
            # Get all this cols in a 1d array
            # matching what was done to
            # bold above
            x1 = dm[:, :, jj].flatten()
            x1name = meta["dm"][jj]
            
            # And calc the corr between 
            # the two 1d arrays
            tau, p = kendalltau(bold, x1)
            
            # then write it all out.
            csvw.writerow([
                    tau, p, 
                    x1name,
                    boldmeta, 
                    model])
    f.close()


if __name__ == "__main__":
    # Process CL args
    possargs = sys.argv[1:]
    hdf = possargs[0]
    name = possargs[1]
    
    # And go
    main(hdf, name)