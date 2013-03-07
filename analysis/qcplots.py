""" Plots in python. These are quality control plots. See the R code for pub quality. """
from simfMRI.analysis.plot import random_timecourses_all_models


def random_tc(selectn, toplot):
    """ Plot <selectn> random timecourses from <toplot> a dict structured as
    {plotname : pathtodata} """
    
    # And make the plots
    simnum = 5000
    for name, data in toplot.items():
        random_timecourses_all_models(data, selectn, simnum, name)


if __name__ == "__main__":
    
    # From these, plot randomly selected timcourses
    toplot = {
        "4alpha" : "./data/rw_5000_learn_4alpha.hdf5",
        "ar1a02" : "./data/rw_5000_learn_ar1.hdf5",
        "ar1a04" : "./data/rw_5000_learn_ar1a04.hdf5",
        "ar1a08" : "./data/rw_5000_learn_ar1a08.hdf5",
        "lowfreq" : "./data/rw_5000_learn_lowfreq.hdf5",
        "nobox_nohrf" : "./data/rw_5000_learn_nobox_nohrf.hdf5",
        "nobox" : "./data/rw_5000_learn_nobox.hdf5",
        "orth" : "./data/rw_5000_learn_orth.hdf5",
        "physio" : "./data/rw_5000_learn_physio.hdf5",
        "white20" : "./data/rw_5000_learn_white20.hdf5",
        "random" : "./data/rw_5000_random.hdf5"}
    
    random_tc(5, toplot)
    
