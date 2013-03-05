""" Get the pairwise correlations (Pearson's r, Spearman's rho and Kendall's tau) between each design matrix column in each model for all simulations in the hdf.

Usage: tabulate_dmhist hdf tablename"""
import os
import sys
import csv
import numpy as np
from bigstats.hist import RHist
from scipy.stats import kendalltau, pearsonr, spearmanr
from simfMRI.io import read_hdf, get_model_names, get_model_meta


def main(hdf, name):
    # Create a csv file to tabulate into
    f = open('{0}.csv'.format(name), 'w')
    csvw = csv.writer(f)
    
    # Make a header for the table
    header = ["x", "count", "cond"]
    csvw.writerow(header)
    
    conds = set(["acc", "value", "rpe", "p", "rand", "box"])
    
    # Find a dmcol from models,
    # pick the first model with 
    # that dm cond. Conds across
    # models are the same.
    locations = {} 
    models = get_model_names(hdf)
    for model in models:

        # Get model meta data and compare it too conds
        meta = get_model_meta(hdf, model)
        for ii, dmname in enumerate(meta["dm"]):
            if dmname in conds:
                locations[dmname] = (model, ii)
                conds.remove(dmname)
                    ## conds loses elements!

        # If conds is empty, stop
        if not conds:
            print("All conds found. {0}".format(model))
            break
    
    # Get each dm's data and pick a col using pos;
    # pos matches cond.
    dmdata = {}
    for cond, loci in locations.items():
        print("Getting {0}".format(cond))
        
        model, pos = loci
        dm = np.array(read_hdf(hdf, '/' + model + '/dm'))
        dmdata[cond] = dm[:,:,pos].flatten()
    
    # Create a histogram then write it out.
    for cond, data in dmdata.items():
        print("Histogramming {0}".format(cond))
        
        # Instantiate a RHist instance and 
        # use it to make a histogram
        hist = RHist(name=cond, decimals=2)
        [hist.add(x) for x in data]
        
        # Tell that textfile a tale.
        [csvw.writerow([k, v, cond]) for k, v in hist.h.items()]
    
    f.close()


if __name__ == "__main__":
    # Process CL args
    possargs = sys.argv[1:]
    hdf = possargs[0]
    name = possargs[1]
    
    # And go
    main(hdf, name)