# ...Needed to get R to work on calipso
SHELL=/bin/bash -O expand_aliases

# ----
# A Makefile for 'A precise problem with model-based fMRI?'
all: data tables plots

# ----
# Generate the data - goes in ./data automatically
data: dataprep basicdata basicvardata ardata noisedata alphadata

dataprep:
# Setup dirs
	mkdir ./data
	mkdir ./plot
	mkdir ./plot/qc
	mkdir ./table
	
basicdata: 
	python ./bin/run_rwfit_500_learn.py
	python ./bin/run_rwfit_5000_learn.py
	python ./bin/run_rwfit_5000_random.py
	python ./bin/run_rwfit_5000_random_orth.py
	mv ./data/*.pdf ./plot/

basicvardata:
	python ./bin/run_rwfit_5000_learn_nobox.py
	python ./bin/run_rwfit_5000_learn_nobox_nohrf.py
	python ./bin/run_rwfit_5000_learn_orth.py
	mv ./data/*.pdf ./plot/

noisedata:
	python ./bin/run_rwfit_5000_learn_lowfreq.py
	python ./bin/run_rwfit_5000_learn_physio.py
	python ./bin/run_rwfit_5000_learn_white20.py
	python ./bin/run_rwfit_5000_learn_ar1a02.py
	python ./bin/run_rwfit_5000_learn_ar1a04.py
	python ./bin/run_rwfit_5000_learn_ar1a08.py
	mv ./data/*.pdf ./plot/

alphadata: 
	python ./bin/run_rwalpha_5000_learn_4alpha.py
	mv ./data/*.pdf ./plot/


# ----
# Create the tables
tables: precisiontables noisetables nohrftable tautables randomorthtables

randomorthtables:
	python ./bin/tabulate_hist.py t ./data/rw_5000_random_orth.hdf5 random_orth
	python ./bin/tabulate_above.py ./data/rw_5000_random_orth.hdf5 t 2.6810 rw_5000_random_orth
	python ./bin/tabulate_above.py ./data/rw_5000_random_orth.hdf5 t 4.317 rw_5000_random_orth
	
precisiontables: 
	python ./bin/tabulate_above.py ./data/rw_5000_learn.hdf5 t 2.6810 rw_5000_learn
	python ./bin/tabulate_above.py ./data/rw_5000_learn.hdf5 t 4.317 rw_5000_learn
	python ./bin/tabulate_above.py ./data/rw_5000_random.hdf5 t 2.6810 rw_5000_random
	python ./bin/tabulate_above.py ./data/rw_5000_random.hdf5 t 4.317 rw_5000_random
	python ./bin/tabulate_above.py ./data/rw_5000_learn_orth.hdf5 t 2.6810 rw_5000_learn_orth
	python ./bin/tabulate_above.py ./data/rw_5000_learn_orth.hdf5 t 4.317 rw_5000_learn_orth
	python ./bin/tabulate_above.py ./data/rw_5000_learn_4alpha.hdf5 t 2.681 rw_5000_learn_4alpha
	python ./bin/tabulate_above.py ./data/rw_5000_learn_4alpha.hdf5 t 4.317 rw_5000_learn_4alpha
	python ./bin/tabulate_above.py ./data/rw_5000_learn_nobox.hdf5 t 2.6810 rw_5000_learn_nobox
	python ./bin/tabulate_above.py ./data/rw_5000_learn_nobox.hdf5 t 4.317 rw_5000_learn_nobox
	python ./bin/tabulate_hist.py t ./data/rw_5000_learn_orth.hdf5 orth
	mv *.csv table/
	
nohrftable: 
	python ./bin/tabulate_above.py ./data/rw_5000_learn_nobox_nohrf.hdf5 t 2.6810 rw_5000_learn_nobox_nohrf
	python ./bin/tabulate_above.py ./data/rw_5000_learn_nobox_nohrf.hdf5 t 4.317 rw_5000_learn_nobox_nohrf
	python ./bin/tabulate_compare.py t data/rw_5000_learn_nobox_nohrf.hdf5 data/rw_5000_learn_nobox.hdf5 nohrf
	mv *.csv table/

noisetables: 
	python ./bin/tabulate_compare.py t \
	    ./data/rw_5000_learn_nobox.hdf5 \
	    ./data/rw_5000_learn_ar1.hdf5 \
	    ./data/rw_5000_learn_ar1a04.hdf5 \
	    ./data/rw_5000_learn_ar1a08.hdf5 \
	    ./data/rw_5000_learn_physio.hdf5 \
	    ./data/rw_5000_learn_lowfreq.hdf5 \
	    allnoise
	mv *.csv table/

tautables: 
	python bin/tabulate_tau.py data/rw_5000_learn_nobox_nohrf.hdf5 nobox_nohrf_tau
	python bin/tabulate_tau.py data/rw_5000_learn_nobox.hdf5 nobox_tau
	
	python bin/tabulate_corr.py data/rw_5000_learn_nobox_nohrf.hdf5 nobox_nohrf_corr
	python bin/tabulate_corr.py data/rw_5000_learn_nobox.hdf5 nobox_corr
	
	python bin/tabulate_dmcorr.py data/rw_5000_learn_nobox_nohrf.hdf5 nobox_nohrf_dmcorr
	python bin/tabulate_dmcorr.py data/rw_5000_learn_nobox.hdf5 nobox_dmcorr
	
	python bin/tabulate_dmhist.py data/rw_5000_learn_nobox_nohrf.hdf5 nobox_nohrf_dmhist
	python bin/tabulate_dmhist.py data/rw_5000_learn_nobox.hdf5 nobox_dmhist
	
	mv *.csv table/

# ----
# Make plots
plots: qcplots pubplots

# Publication plots
pubplots:
	R CMD BATCH ./analysis/pubplots.R

# QC and developments plots
qcplots:
	python ./analysis/qcplots.py
	mv *.pdf /plot/qc


clean:
# Deleteing all the data, tables and plots
	rm -rf ./data
	rm -rf ./table
	rm -rf ./plot
	
# Get any stray files.
	rm -f *.hdf5
	rm -f *.csv
	rm -f *.pdf
