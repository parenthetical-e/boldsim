# A Makefile for 'A precise problem with model-based fMRI?'
all: data tables plots


data:
	# Setup all the data directories first thing
	mkdir ./data
	mkdir ./plot
	mkdit ./table

	# Generate the data - goes in ./data automatically
	python ./bin/run_rwalpha_5000_learn_4alpha.py
	python ./bin/run_rwfit_500_learn.py
	python ./bin/run_rwfit_5000_learn_ar1a02.py
	python ./bin/run_rwfit_5000_learn_ar1a04.py
	python ./bin/run_rwfit_5000_learn_ar1a08.py
	python ./bin/run_rwfit_5000_learn_lowfreq.py
	python ./bin/run_rwfit_5000_learn_nobox.py
	python ./bin/run_rwfit_5000_learn_orth.py
	python ./bin/run_rwfit_5000_learn_physio.py
	python ./bin/run_rwfit_5000_learn_white20.py
	python ./bin/run_rwfit_5000_learn.py
	python ./bin/run_rwfit_5000_random.py

	mv *.pdf ./plot/	## 'make data' makes plots, move them
		 				## to the right place


tables: data
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

	python ./bin/tabulate_compare.py t \
	    ./data/rw_5000_learn_orth.hdf5 \
	    ./data/rw_5000_learn_ar1.hdf5 \
	    ./data/rw_5000_learn_ar1a04.hdf5 \
	    ./data/rw_5000_learn_ar1a08.hdf5 \
	    ./data/rw_5000_learn_physio.hdf5 \
	    ./data/rw_5000_learn_lowfreq.hdf5 \
	    allnoise

	python ./bin/tabulate_hist.py t ./data/rw_5000_learn_orth.hdf5 orth
	
	# Move the csv tables to a new dir
	mv *.csv table/

		
plots: tables
	R CMD BATCH ./analysis/plots.R
	mv *.pdf ./plot/  ## Just in case


clean:
	# Delete all the data, tables and plots
	# made by this Makefile
	rm -rf ./data
	rm -rf ./table
	rm -rf ./plot
	
	# Also get any stray files 
	# if make died early
	rm -f *.hdf5
	rm -f *.csv
	rm -f *.pdf



