""" A top-level script that produces (many) bar plots of area above criterion for every condition for every model in the provided simFMRI dataset.

Usage: plot_rw_above [nooptions] hdf stat criterion plotname
"""
import os
import sys
import numpy as np
from matplotlib.backends.backend_pdf import PdfPages
import matplotlib.pyplot as plt
from simfMRI.io import read_hdf, get_model_names, get_model_meta
from simfMRI.analysis.stat import create_hist_list

def main(posargs):

    # Check then handle the positional arguements
    # brough in from the command line
    if len(posargs) != 4:
        raise ValueError("plot_rw_above requires four arguments.\n")

    hdf = posargs[0]
    stat = posargs[1]
    criterion = float(posargs[2])
    name = posargs[3]

    # Open a pdf object to write to
    # and create a figure to plot to
    try:
        os.mkdir("plot")
    except OSError:
        pass
    pdf = PdfPages('./plot/{0}.pdf'.format(name))

    models = get_model_names(hdf)
    for model in models:
        
        fig = plt.figure()
        ax = fig.add_subplot(111)
        
        hist_list = create_hist_list(hdf, model, stat)
        
        # Loop over the hist_list adding
        # the results from each hist.above(criterion)
        # to a bar plot.
        areas = [hist.above(criterion) for hist in hist_list]
        names = [hist.name for hist in hist_list]
                
        width = .5
        idx = np.arange(len(areas))
        ax.bar(idx, areas, color="black", width=width)
        ax.set_xticks(idx+width/2)
        ax.set_xticklabels(names)
        
        # Pretty things up then save 
        # this barplot to the pdf
        # and move onto the next model
        meta = get_model_meta(hdf, model)
        
        plt.ylim(ymin=0, ymax=1)
        plt.title("Area above {3}, {0} - BOLD: {1}, DM: {2}".format(
            model, meta["bold"], meta["dm"], criterion))
        plt.savefig(pdf, format="pdf")
    
    pdf.close()


if __name__ == "__main__":
    
    posargs = sys.argv[1:]
    main(posargs)