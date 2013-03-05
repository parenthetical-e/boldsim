""" Get the pairwise correlations (Pearson's r, Spearman's rho and Kendall's 
tau) between each design matrix column and the BOLD signal in each model for 
all simulations in the hdf 


Usage: tabulate_corr hdf tablename"""
import os
import sys
import csv
import numpy as np
from itertools import combinations
from scipy.stats import kendalltau, pearsonr, spearmanr
from simfMRI.io import read_hdf, get_model_names, get_model_meta


def main(hdf, name):
    f = open('{0}.csv'.format(name), 'w')
    csvw = csv.writer(f)
    
    # A header for the table
    head = ["tau", "p_tau",
            "r", "p_r",
            "rho", "p_rho",
            "cond",
            "boldmeta", 
            "model"]
    csvw.writerow(head)
    
    models = get_model_names(hdf)
    for model in models:
        # Get model meta data
        meta = get_model_meta(hdf, model)
        boldmeta = "_".join([str(b) for b in meta["bold"]])
            ## meta['bold'] can be a list
            ## but we need a string....
        
        # Get all the design matrices and
        # Get all the bold signals as a 1d array
        dm = np.array(read_hdf(hdf, '/' + model + '/dm'))
        bold = np.array(read_hdf(hdf, '/' + model + '/bold')).flatten()
        
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
            tau, p_tau = kendalltau(bold, x1)
            r, p_r = pearsonr(bold, x1)
            rho, p_rho = spearmanr(bold, x1)
            
            # then write it all out.
            csvw.writerow([
                    tau, p_tau,
                    r, p_r,
                    rho, p_rho,
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