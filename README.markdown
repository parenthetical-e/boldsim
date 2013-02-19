# Experimental log

* Branched off so specific experimental runs from the simfMRI code base, creating this repository.  As much as is possible all experiment specific files for 'A precise problem with model-based fMRI' will live here.

* The plan is to use my simfMRI framework to create top-level experimental runs (i.e. scripts run from the command line).  These top-level scripts are the experiments.  They all are named like:
		
		run_rw_EXPERIMENTALDETAIL.py

* And take no arguments.  While more general run files (that take arguements) could have been created, I felt it was best experimental files were as explicit as possible.  This comes with a code-duplication cost, but that seems worth it for the gained transparency.  As least I hope.

* Much of the experiments here were initially done about a year and a half ago.  But as I have greatly alterated/improved of the simfMRI code base, so the experimental runs are redone completely.  

 - To see the old experiments and code go back through the simfMRI git repository.

* Using simfMRI.expclass and simfMRI.runclass templates, as well as the local expclass module, a set of 12 initial experimental runs were defined.  THese had two aims.  Evaluate the

* Most of the code of interest to outsiders will live in the bin/ module.
 - There are two kinds of files, run and tabuluate.  
 - Run files (as alluded to above run files, creating rather large hdf5 files).  There is much data in these, more than is needed.  I opted for aggressive saving of simulation state over compactness.
 - As a result there are a set of tabulate files, these extract data from hdf5 files for plotting.
 
* Which brings us to the plot module.  As is my strong preference, plots made in R, using tabulated data.  
 - With one exception.  Each of the run methods produce a large set of histograms, one for each model in the run.  I did this so immediately after a run it is easy to see, in a general way, how the simulations worked out.  
 - The initial intent was to plot in python, but I quickly grew frustrated with matplotlibs syntax and limitation. Forgive me future reader/user.
 
 