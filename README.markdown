# Experimental log

* NOTE: all experimental run files below assume there are 12 cores available to spread the simulations over.  Adjust 'ncore' (to an even number) in each run file to suit your local environment.  More cores will be faster, though the bottleneck may become the write and plotting times, or for very high core counts python process spawning may instead become rate limiting.  I'd stay below ncore is 50, or so.  Running these on just 2 cores will take about 4 days (loosely speaking).
 
* Branched off so specific experimental runs are no longer part of the simfMRI code base, creating this repository.  As much as is possible all experiment specific files for 'A precise problem with model-based fMRI' will live here.

* The plan is to use my simfMRI framework to create top-level experimental runs (i.e. scripts run from the command line).  These top-level scripts are the experiments.  They all are named like:
		
		run_rw_EXPERIMENTALDETAIL.py

* And take no arguments.  While more general run files (that take arguments) could have been created, I felt it was best that experimental files were as explicit as possible.  This comes with a code-duplication cost, but that seems worth it for the gained transparency.  As least I hope.

* Much of the experiments here were initially done about a year and a half ago.  But as I have greatly alterated/improved of the simfMRI code base, so the experimental runs are redone completely.  

 - To see the old experiments and code go back through the simfMRI git repository.

* Most of the code of interest to outsiders will live in the bin/ module.
 - There are two kinds of files, run and tabuluate.  
 - Run files create rather large hdf5 files.  There is much data in these, more than is needed.  I opted for aggressive saving of simulation state over compactness.
 - As a result there are a set of tabulate scripts, these extract data from hdf5 files for plotting and what have you.

* Which brings us to the plot module.  As is my strong preference, plots are made in R, using tabulated data.  
 - With one exception.  Each of the run methods produce a large set of histograms, one for each model in the run.  I did this so immediately after a run it is easy to see, in a general way, how the simulations worked out.
 - The initial intent was to plot in python, but I quickly grew frustrated with matplotlib's syntax and limitations.

 
## Run 1

* Used simfMRI.expclass and simfMRI.runclass templates to create the local expclass module, a the set of 12 initial experimental runs.  These had two aims.
 1. A first pass at assessing precision
 
	 run_rwfit_5000_learn.py
	 run_rwfit_5000_random.py
	 run_rwfit_5000_learn_orth.py
	 run_rwalpha_5000_learn_2alpha.py
	 
 2. A first pass at assessing robustness of model-based designs
 
	 run_rwfit_5000_learn_ar1a02.py
	 run_rwfit_5000_learn_ar1a04.py
	 run_rwfit_5000_learn_ar1a08.py
	 run_rwfit_5000_learn_lowfreq.py
	 run_rwfit_5000_learn_orth.py
	 run_rwfit_5000_learn_physio.py
	 run_rwfit_5000_learn_white05.py
	 run_rwfit_5000_learn_white20.py

 - Though they were not run individually.  See run1.sh, which will fully reproduce the run1 datasets.  Run 1 data used in the paper matches the following commit #s

		boldsim: 
		simfMRI: 

 - NOTE: a ./data directory will be created whereever you run run1.sh from and the data will live there
 - NOTE: run1.sh requires that the following files (from boldsim) are present in it's working directory.

		rw_2alpha.ini
		rw_orth.ini
		rw.ini

* There is a third set still to do - assessing robustness to design matrix or BOLD mis-specification.  This will e run2, along with any other reruns, and whatever else.

* Several tabulations were carried out on the run1 data.  To see/rerun these tabulations see tabulate1.sh

