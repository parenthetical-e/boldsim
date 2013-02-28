# Make ALL plots for the boldsim data.
require("gplot2")
source("analysis/plot.above.R")
source("analysis/plot.compare.ts.R")
source("analysis/plot.compare.Ds.R")
source("analysis/plot.hist.R")
source("analysis/misc.R")

# ----
# Hist
plot.hist("table/orth_hist_t.csv", "plot/hist_orth", 
		sigline=2.681, width=4, height=5)

# ----
# Precision
plot.above.combined2(c(
		"table/rw_5000_learn_nobox_t2.681.csv",
		"table/rw_5000_learn_t2.681.csv",
		"./table/rw_5000_learn_orth_t2.681.csv"), 
		c("MO", "BM", "OBM"), 
		"plot/bsp_dmcompare_t2.681", sigline=0.01, width=3, height=6)

plot.above.combined2(c(
		"table/rw_5000_learn_nobox_t4.317.csv",
		"table/rw_5000_learn_t4.317.csv",
		"./table/rw_5000_learn_orth_t4.317.csv"), 
		c("MO", "BM", "OBM"), 
		"plot/bsp_dmcompare_t4.317", sigline=0.0005, width=3, height=6)

# plot.above.alpha(
	# csv="table/rw_5000_learn_4alpha_t2.681.csv", 
	# name="plot/4alpha",
	# sigline=0.01, width=4, height=6)


# ----
# Noise
# --
# Names for noise experiments were very bad, fix them.
# This fix hard codes the relation between old and new
# so change the allnoise_t tabulate call with great care
dt <- read.table("table/allnoise_t.csv", sep=",", header=TRUE)
old <- levels(dt$dataset)
new <- c("ar1_0.2", "ar1_0.4", "ar1_0.8", "low_freq", "white", "physio")
print(old)
print(new)

dtmp <- relevel.dataset("table/allnoise_t.csv", old, new,
		"table/relevel_allnoise_t.csv")
			## table/allnoise_t.csv gets overwritten in place

plot.compare2.D("table/relevel_allnoise_t.csv", "plot/c_allnoise_D", 
		ymin=0, ymax=0.20, width=3, height=6)

plot.compare2("table/relevel_allnoise_t.csv", "plot/c_allnoise_t", 
		ymin=0, ymax=8, width=3, height=6)