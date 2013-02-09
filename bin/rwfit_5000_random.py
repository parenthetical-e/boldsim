""" A top-level experimental script that run 5000 iterations of 
the RW() done *in parallel* on ncores. 

Random 'learning' mode is on. 

Note: See code to set parameters.  This script takes no arguments. """
import os
import functools
from multiprocessing import Pool
from simfMRI.io import write_hdf, get_model_names
from simfMRI.analysis.plot import hist_t
from simfMRI.mapreduce import create_chunks, reduce_chunks
from boldsim.base import RWfit


def _run(name, model_conf, TR, ISI):
    """ Runs a single simulation, returning a simfMRI results object. """
    
    n = 60 ## Number of trials
    exp = RWfit(n, 'random', TR, ISI)
    exp.populate_models(model_conf)
    
    return exp.run(name)


def main(names, model_conf, TR, ISI):
    """ Runs a simulation for each element of names, returning
    a results list. """
    
    return [_run(name, model_conf, TR, ISI) for name in names]


if __name__ == "__main__":
    TR = 2
    ISI = 2
    nrun = 5000
    model_conf = "rw.ini"
    
    ncore = 10
    
    # Create ./data if needed
    basedir = "data"
    try:
        os.mkdir(basedir)
    except OSError:
        pass
    
    # Setup multi
    pool = Pool(processes=ncore)
    
    # Create chunks for multi
    run_chunks = create_chunks(nrun, ncore)
    
    # Partial function application to setup main for easy
    # mapping (and later parallelization), creating pmain.
    pmain = functools.partial(main, model_conf=model_conf, TR=TR, ISI=ISI)
    results_in_chunks = pool.map(pmain, run_chunks)
    results = reduce_chunks(results_in_chunks)
    
    print("Writing results to disk.")
    results_name = "rwfit_{0}_random".format(nrun)
    hdfpath = os.path.join("data", results_name+".hdf5")
    write_hdf(results, hdfpath)
    
    # Make a list of the models 
    # to plot and plot them 
    print("Plotting results.")
    models = get_model_names(hdfpath)
    for mod in models:
        dataf = os.path.join("data", results_name+".hdf5") 
        pname = os.path.join("data",results_name+"_"+mod)
        hist_t(dataf, mod, pname) 
    
    