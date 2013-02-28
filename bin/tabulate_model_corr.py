""" Get the pairwise correlations (Kendall's tau) between each design matrix column in each model for all simulations in the hdf 

Usage: tabulate_model_corr hdf tablename"""
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
    
    head = ["tau", "p", 
            "pairname", 
            "x1name", "x2name", 
            "bold", 
            "model"]
    csvw.writerow(head)
    
    models = get_model_names(hdf)
    for model in models:
        # Get mode meta data for the table
        meta = get_model_meta(hdf, model)
        
        # Get all the design matrices
        dm = np.array(read_hdf(hdf, '/' + model + '/dm'))
        
        # Create a list indices for all pairwise
        # combinations in the dm
        ncol = dm.shape[2]
        pairs_index = list(combinations(range(ncol), 2))
        boldmeta = "_".join([str(b) for b in meta["bold"]])
        for pair in pairs_index:
            # Get the pair's data
            # for all sims as a 1d array
            # in dm,
            #  axis 1 is a sim index/count, 
            #  axis 2 is the dm row
            #  axis 3 is the dm cols
            x1 = dm[:, :, pair[0]].flatten()
            x2 = dm[:, :, pair[1]].flatten()
            x1name = meta["dm"][pair[0]]
            x2name = meta["dm"][pair[1]]  ## Get the names too
                ## dm[:, :, pair[1]] alone returns
                ## a 2d array shaped as
                ## (nsim, npts_in_each_col)
            
            # And calc the corr
            tau, p = kendalltau(x1, x2)
            
            # And write it all out
            csvw.writerow([
                    tau, p, 
                    x1name + "_" + x2name,
                    x1name, x2name,
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