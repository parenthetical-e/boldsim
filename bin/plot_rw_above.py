""" A top-level script that takes produces (many) bar plots of area above criterion for every condition for every model in the provided simFMRI dataset.

Usage: plot_rw_above [nooptions] hdf stat criterion
"""
import sys
from simfMRI.io import read_hdf

if len(sys.argv[1:]) != 3:
    raise ValueError("plot_rw_above requires three arguments.")


