# Experimental log

* NOTE: all experimental run files below assume there are 12 cores available to spread the simulations over.  Adjust 'ncore' (to an even number) in each run file to suit your local environment.  More cores will be faster, though the bottleneck may become the write and plotting times, or for very high core counts python process spawning may instead become rate limiting.  I'd stay below ncore is 50, or so.  Running these on just 2 cores will take about 4 days (loosely speaking).
 
* Branched off so specific experimental runs are no longer part of the simfMRI code base, creating this repository.  As much as is possible all experiment specific files for 'A precise problem with model-based fMRI' will live here.

* The plan is to use my simfMRI framework to create top-level experimental runs (i.e. scripts run from the command line).  These top-level scripts are the experiments.  They all are named like:
		
		run_rw_EXPERIMENTALDETAIL.py

* And take no arguments.  While more general run files (that take arguments) could have been created, I felt it was best that experimental files were as explicit as possible.  This comes with a code-duplication cost, but that seems worth it for the gained transparency.  As least I hope.

* Much of the experiments here were initially done about a year and a half ago.  But as I have greatly altered/improved of the simfMRI code base, so the experimental runs are redone completely.  

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

		boldsim: 941a78533430c2b037087b5a19fc34de37ce459b
		simfMRI: 0622b477b7193051a45ac0f89ab83a32db56d29a

 - NOTE: a ./data directory will be created whereever you run run1.sh from and the data will live there
 - NOTE: run1.sh requires that the following files (from boldsim) are present in it's working directory.

		rw_2alpha.ini
		rw_orth.ini
		rw.ini

* There is a third set still to do - assessing robustness to design matrix or BOLD mis-specification.  This will e run2, along with any other reruns, and whatever else.

* Several tabulations were carried out on the run1 data.  To see/rerun these tabulations see tabulate1.sh

* A bit of file cleanup:
 - hdf5 data was left in ./data
 - pdfs were moved to ./plot; all plots will live here now.
 - tabulate1.sh results were moved to ./table

----
 
* The white noise tabulation should not include the reduced noise condition (white05), so it was rerun (from ./data) as below.  I updated the tabulate1.sh file to reflect this change.
		
		python ~/src/boldsim/bin/tabulate_compare.py t rw_5000_learn.hdf5 \
		rw_5000_learn_white20.hdf5 white

* Created tabulate3.sh to combine all the noise (robustness) runs into one table to make is easier to compare changes in magnitudes.  Name: allnoise (moved to ./table)

----

* After initial analysis all run1.sh was rerun.
 - Differences from last run:
  1. All noise/robust experiments have orth turned on.  This is the statistically correct way to do model-based regressions so we should use it to test noise robustness.... for these purposes we'll ignore the interpretability issues that come with orth.
  2. Replaced 2alpha with 4alpha - want to get a more fine grained look at parameter effects.
  3. Redid rw_4alpha.ini making it more focused than its 2alpha predecessor.  There were several superfluous design matrices.
  4. run1.sh now runs the relevant tabulate*.sh scripts
  5. deleted white05 -- it is not of use for the paper.

# Plots for paper

* NOTE: rename plots from, for example, *t2.681.pdf to *t2_681.pdf for latex compatibly.
* NOTE: Made the following plots (in R version 2.15.1, using ggplot2 version 0.9.2.1, CentOS 5.7 (code is (mostly) tested on MacOS 10.7.5, using R 9.3.4)).

* Plots for area above crit as function of MO, BM and OBM:

		boldsim commit: 17c381c74f75984902036306c05f86df1d55922a
		plot.above.combined2(c("table/rw_5000_learn_nobox_t2.681.csv", "table/rw_5000_learn_t2.681.csv", "./table/rw_5000_learn_orth_t2.681.csv"), c("MO", "BM", "OBM"), "plot/bsp_dmcompare_t2.681", sigline=0.01, width=6, height=3) 		

* Need example histograms for all sims
* Need alpha plots

# Alt or old plots (saved for later reference).

* First round of plots:

		boldsim commit: 941a78533430c2b037087b5a19fc34de37ce459b
		plot.compare("table/white_t.csv", "./plot/c_white", c(2.681,4.317))
		plot.compare("table/lowfreq_t.csv", "./plot/c_lowfreq", c(2.681,4.317))
		plot.compare("table/physio_t.csv", "./plot/c_physio", c(2.681,4.317))
		plot.compare("table/ar1_t.csv", "./plot/c_ar1",c(2.681,4.317))
		
		plot.above("./table/rw_5000_learn_t4.317.csv", "plot/above_learn_t4.317", 4, 4)
		plot.above("./table/rw_5000_learn_t2.681.csv", "plot/above_learn_t2.681", 4, 4)
		
		plot.above("./table/rw_5000_learn_2alpha_t4.317.csv", "plot/above_2alpha_t4.317", 4, 4)
		plot.above("./table/rw_5000_learn_2alpha_t2.681.csv", "plot/above_2alpha_t2.681", 4, 4)
		
		plot.above("table/rw_5000_learn_orth_t4.317.csv", "plot/above_orth_t4.317", 4, 4)
		plot.above("table/rw_5000_learn_orth_t2.681.csv", "plot/above_orth_t2.681", 4, 4)
		
----

* Want to compare to parametric models without a boxcar regressor, as all the above have. Created the below to that end.  Note, this simulation will be auto-run when calling run1.sh (so there is no need for run2.sh)

		boldsim commit: 459db86e536b4284fc4e30e0e3a0e252d31838a0
		boldsim/bin/rw_nobox.ini
		boldsim/bin/run_rwfit_5000_learn_nobox.py
		
* To process the results of the nobox simulation I created tabulate2.sh. Then moved the created csvs to ./table and plotted these results:

		boldsim commit: 9ad0765475a28e43b13a996f7977366f18536e7f
		plot.above("table/rw_5000_learn_nobox_t4.317.csv", "plot/above_nobox_t4.317", 4, 4)
		plot.above("table/rw_5000_learn_nobox_t2.681.csv", "plot/above_nobox_t2.681", 4, 4)

----

* tabulate3.sh data was not easily analyzed using the plot.compare() routine so after a much trial and error an alternate scheme was created using colors to denote datasets in place of axis markers.  This was so good I replotted all the noise data with it.
		
		boldsim commit: 9a86c825919f720be422a0ec3f60b1a5d34ed207
		plot.compare("table/white_t.csv", "./plot/c_white", width=10, height=5, c(2.681,4.317))
		plot.compare("table/physio_t.csv", "./plot/c_physio", width=10, height=5, c(2.681,4.317))
		plot.compare("table/lowfreq_t.csv", "./plot/c_lowfreq", width=10, height=5, c(2.681,4.317))
		plot.compare("table/ar1_t.csv", "./plot/c_ar1", width=10, height=5, c(2.681,4.317))
		plot.compare("table/allnoise_t.csv", "./plot/c_allnoise", width=10, height=5, c(2.681,4.317))
				
----

* Fig: model-only

		boldsim commit 88551be002a7062cecb979628834c52558b959bb
		plot.above.combined("./table/rw_5000_learn_nobox_t2.681.csv", "plot/bsp_nobox_t2.681", sigline=0.01, width=7, height=7)
		plot.above.combined("./table/rw_5000_learn_nobox_t4.317.csv", "plot/bsp_nobox_t4.317", sigline=0.0005, width=7, height=7)

* Fig: box and model

		plot.above.combined("./table/rw_5000_learn_t4.317.csv", "plot/bsp_bm_t4.317", sigline=0.0005, width=7, height=7)
		plot.above.combined("./table/rw_5000_learn_t2.681.csv", "plot/bsp_bm_t2.681", sigline=0.01, width=7, height=7)
		
* Fig: OBM
		
		plot.above.combined("./table/rw_5000_learn_orth_t2.681.csv", "plot/bsp_bmo_t2.681", sigline=0.01, width=7, height=7)
		plot.above.combined("./table/rw_5000_learn_orth_t4.317.csv", "plot/bsp_bmo_t4.317", sigline=0.0005, width=7, height=7)

----

* I also created a version that combined all three design matrix runs (MO, BM and OBM) into a single plot, but I think this might be both too dense and ambiguous, i.e. which bar belongs to which design matrix, inconsistent row, DMs, etc.

		boldsim commit: 29871bb40f4137a7a08948750324f93ba8e05722
		plot.above.combined2(c("table/rw_5000_learn_nobox_t2.681.csv", "table/rw_5000_learn_t2.681.csv", "./table/rw_5000_learn_orth_t2.681.csv"), c("MO", "BM", "OBM"), "plot/bsp_dmcompare_t2.681", sigline=0.01, width=7, height=8) 