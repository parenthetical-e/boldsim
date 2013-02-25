# Make ALL plots for the boldsim data.
require("gplot2")
source("analysis/plot.tables.R")

# ----
# Precision
plot.above.combined2(c(
		"table/rw_5000_learn_nobox_t2.681.csv",
		"table/rw_5000_learn_t2.681.csv",
		"./table/rw_5000_learn_orth_t2.681.csv"), 
		c("MO", "BM", "OBM"), 
		"plot/bsp_dmcompare_t2.681", sigline=0.01, width=6, height=3)

plot.above.combined2(c(
		"table/rw_5000_learn_nobox_t4.317.csv",
		"table/rw_5000_learn_t4.317.csv",
		"./table/rw_5000_learn_orth_t4.317.csv"), 
		c("MO", "BM", "OBM"), 
		"plot/bsp_dmcompare_t4.317", sigline=0.01, width=6, height=3)

plot.above.alpha(
	csv="table/rw_5000_learn_4alpha_t2.681.csv", 
	name="4alpha",
	sigline=0.01, width=4, height=6)


# ----
# Noise
# --
# Names for noise experiments were very bad, fix them.
# This fix hard codes the relation between old and new
# so change the allnoise_t tabulate call with great care
dt <- read.table("table/allnoise_t.csv", sep=",", header=TRUE)
old <- levels(dt$dataset)
new <- c("ar1_0.2", "ar1_0.4", "ar1_0.8", "low_freq", "white", "physio")
relevel.dataset("table/allnoise_t.csv", old, new, TRUE)
		## table/allnoise_t.csv get overwritten in place

plot.compare2("table/allnoise_t.csv", 
		"plot/c_allnoise", c(2.681), width=3, height=6)

