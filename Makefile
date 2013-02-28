# ...Needed to get R to work on calipso
SHELL=/bin/bash -O expand_aliases

# A Makefile for 'A precise problem with model-based fMRI?'
all: data tables plots

# Generate the data - goes in ./data automatically
data: dataprep basicdata basicvardata ardata noisedata alphadata

dataprep:
# Setup dirs
	mkdir ./data
	mkdir ./plot
	mkdir ./table
	
basicdata: 
	python ./bin/run_rwfit_500_learn.py
	python ./bin/run_rwfit_5000_learn.py
	python ./bin/run_rwfit_5000_random.py
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
	mv ./data/*.pdf ./plot/

alphadata: 
	python ./bin/run_rwalpha_5000_learn_4alpha.py
	mv ./data/*.pdf ./plot/

ardata:
	python ./bin/run_rwfit_5000_learn_ar1a02.py
	python ./bin/run_rwfit_5000_learn_ar1a04.py
	python ./bin/run_rwfit_5000_learn_ar1a08.py
	mv ./data/*.pdf ./plot/


tables: precisiontables noisetables corrtables
	mv *.csv table/

precisiontables: data
# Create the tables
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

corrtables: data
	python ./bin/tabulate_model_corr.py ./data/rw_5000_learn_nobox.hdf5 nobox_model_corr
	python ./bin/tabulate_model_corr.py ./data/rw_5000_learn_nobox_nohrf.hdf5 nobox_nohrf_model_corr
	mv *.csv table/

noisetables: data
# Create the tables
	python ./bin/tabulate_compare.py t \
	    ./data/rw_5000_learn_orth.hdf5 \
	    ./data/rw_5000_learn_ar1.hdf5 \
	    ./data/rw_5000_learn_ar1a04.hdf5 \
	    ./data/rw_5000_learn_ar1a08.hdf5 \
	    ./data/rw_5000_learn_physio.hdf5 \
	    ./data/rw_5000_learn_lowfreq.hdf5 \
	    allnoise
	mv *.csv table/


plots: 
	R CMD BATCH ./analysis/plots.R


clean:
# Deleteing all the data, tables and plots
	rm -rf ./data
	rm -rf ./table
	rm -rf ./plot
	
# Get any stray files.
	rm -f *.hdf5
	rm -f *.csv
	rm -f *.pdf
