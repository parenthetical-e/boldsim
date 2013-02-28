""" Create and write out histograms for stat (at 0.1 decimal precision) from the given hdf file, storing the table as tablename.

Usage: python tabulate_hist stat hdf tablename
"""
import os, sys
import csv
from os.path import join, abspath
import numpy as np
import itertools
import h5py
from bigstats.hist import RHist
from simfMRI.io import read_hdf_inc, get_model_meta, get_model_names


def main(hdf, stat, name):
    """ Given a <path> and the <hdf> name, plot and save all the models in
    the <hdf>, prefixing each with <basename>.
    """

    stat = str(stat)
    
    # Create a csv file to tabulate into
    f = open('{0}_hist_{1}.csv'.format(name, stat), 'w')
    csvw = csv.writer(f)
    
    # Make a header for the table
    header = [stat, "count", "cond", "boldmeta", "model"]
    csvw.writerow(header)
    
    # Make a list of the models 
    # to tabulate and get going...
    models = get_model_names(hdf)
    for mod in models:
        meta = get_model_meta(hdf, mod)
        hist_list = create_hist(hdf, mod, stat)
        for hist in hist_list:
            cond = hist.name
            boldmeta = "_".join([str(b) for b in meta["bold"]])
            [csvw.writerow([k, v, cond, boldmeta, mod]) for 
                    k, v in hist.h.items()]

    f.close()


def create_hist(hdf, model, stat):
    """ 
    Create histograms of stat values in <hdf> for each condition in 
    <model>.
    """

    meta = get_model_meta(hdf, model)
    hist_list = []
    for dm_col in meta['dm']:
        # Make an instance RHist for the list.
        hist = RHist(name=dm_col, decimals=1)
        hist_list.append(hist)
    
    # read_hdf_inc returns a generator so....
    data = read_hdf_inc(hdf,'/'+ model + '/' + stat)
    for row in data:
        # get the row values for each instance of model
        # and add them to the hist_list,
        [hist_list[ii].add(row[ii]) for ii in range(len(row)-1)]
            ## The last t in ts is the constant, which we 
            ## do not want to plot.

    return hist_list


if __name__ == "__main__":
    posargs = sys.argv[1:]
    hdf = posargs[1]
    stat = posargs[0]
    name = posargs[2]
    
    main(hdf, stat, name)