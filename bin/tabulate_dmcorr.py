""" Get the pairwise correlations (Pearson's r, Spearman's rho and Kendall's tau) between each design matrix column in each model for all simulations in the hdf.

Usage: tabulate_dmcorr hdf tablename"""
import os
import sys
import csv
import numpy as np
from itertools import permutations
from scipy.stats import kendalltau, pearsonr, spearmanr
from simfMRI.io import read_hdf, get_model_names, get_model_meta


def main(hdf, name):
    # Create a csv file to tabulate into
    f = open('{0}.csv'.format(name), 'w')
    csvw = csv.writer(f)
    
    # A header for the table
    head = ["tau", "p_tau",
            "r", "p_r",
            "rho", "p_rho",
            "cond0",
            "cond1"] 
    
    csvw.writerow(head)
    
    conds = set(["acc", "value", "rpe", "p", "rand", "box"])
    pairs = permutations(conds, 2)
    
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
            print("All conds found by {0}".format(model))
            break
    
    # Get the data
    dmdata = {}
    for cond, loci in locations.items():
        print("Getting {0}".format(cond))
        
        model, pos = loci
        dm = np.array(read_hdf(hdf, '/' + model + '/dm'))
            ## Get all the dm's data
        dmdata[cond] = dm[:,:,pos].flatten()
            ## pick a col using pos, as this is 
            ## the data matching name
    
    # Calculate all pair-wise correlations
    for pair in pairs:
        print("Correlate: {0}".format(pair))
        
        cond0, cond1 = pair
        x0 = dmdata[cond0]
        x1 = dmdata[cond1]
        
        tau, p_tau = kendalltau(x0, x1)
        r, p_r = pearsonr(x0, x1)
        rho, p_rho = spearmanr(x0, x1)

        # then write it all out.
        csvw.writerow([
                tau, p_tau,
                r, p_r,
                rho, p_rho,
                cond0,
                cond1])
    
    f.close()


if __name__ == "__main__":
    # Process CL args
    possargs = sys.argv[1:]
    hdf = possargs[0]
    name = possargs[1]
    
    # And go
    main(hdf, name)
