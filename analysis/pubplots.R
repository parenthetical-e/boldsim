# Make ALL plots for the boldsim data.
require("gplot2")
source("analysis/plot.above.R")
source("analysis/plot.compare.ts.R")
source("analysis/plot.compare.Ds.R")
source("analysis/plot.hist.R")
source("analysis/plot.corr.R")
source("analysis/plot.dmcorr.R")
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
		"plot/bsp_dmcompare_t2.681", 
		sigline=0.01, width=3, height=6)

# Higher cutoff not used in the paper. 
# plot.above.combined2(c(
# 		"table/rw_5000_learn_nobox_t4.317.csv",
# 		"table/rw_5000_learn_t4.317.csv",
# 		"./table/rw_5000_learn_orth_t4.317.csv"), 
# 		c("MO", "BM", "OBM"), 
# 		"plot/bsp_dmcompare_t4.317", 
# 		sigline=0.0005, width=3, height=6)

# ----
# Alpha levels
plot.above.4alpha(
		csv="table/rw_5000_learn_4alpha_t2.681.csv", 
		name="plot/4alpha",
		sigline=0.01, width=4, height=3)

# ----
# Hrf effects as hist
plot.dmhist_hrf("table/nobox_dmhist.csv",
		"table/nobox_nohrf_dmhist.csv",
		"plot/b_nohrf_dmhist",
		width=5,
		height=4)

# ----
# HRF effects as corr - 
# DO NOT USE. Kept for reference, honesty. As both the non-parametric 
# correlations use ranks (and Pearson's was invalid), and as the precisions 
# effects under discussion here are not well observed by signed-rank methods 
# (signs don't change often when a double-gamma is convolved on the 
# model-series).  The data for HRF on/off data was best charaterized (we felt) 
# by comparing historgrams. A qualitative comparison is enough to make the point
# (see plot.dmhist_hrf above).
#
# plot.above.combined2(c(
# 		"table/rw_5000_learn_nobox_t2.681.csv",
# 		"table/rw_5000_learn_nobox_nohrf_t2.681.csv"), 
# 		c("MO", "no_hrf"),
# 		"plot/b_nohrf_t2.681",
# 		sigline=0.01, width=3, height=6)
# 
# plot.above.combined2(c(
# 		"table/rw_5000_learn_nobox_t4.317.csv",
# 		"table/rw_5000_learn_nobox_nohrf_t4.317.csv"), 
# 		c("MO", "MOnohrf"),
# 		"plot/b_nohrf_t4.317",
# 		sigline=0.0005, width=3, height=6)
# 
# # --
# # HRf effects using Kendall's tau
# plot.tau("table/nobox_tau.csv",
# 		"table/nobox_nohrf_tau.csv",
# 		"plot/b_nohrf_tau",
# 		width=3,
# 		height=6)
# 
# # Plot all three corrs in one pdf
# plot.corr("table/nobox_corr.csv",
# 		"table/nobox_nohrf_corr.csv",
# 		"plot/b_nohrf_corr",
# 		width=3,
# 		height=6)
# 
# plot.dmcorr("table/nobox_dmcorr.csv",
# 		"table/nobox_nohrf_dmcorr.csv",
# 		"plot/b_nohrf_dmcorr",
# 		width=3,
# 		height=6)


# ----
# Noise
# Names for noise experiments were very bad, fix them.
# This fix hard codes the relation between old and new
# so change the allnoise_t tabulate call with great care
dt <- read.table("table/allnoise_t.csv", sep=",", header=TRUE)
old <- levels(dt$dataset)
print(old)
new <- c("white", "ar1_0.2", "ar1_0.4", "ar1_0.8", "low_freq", "physio")
print(old)
print(new)

dtmp <- relevel.dataset("table/allnoise_t.csv", old, new,
		"table/relevel_allnoise_t.csv")
			## table/allnoise_t.csv gets overwritten in place

plot.compare2.D("table/relevel_allnoise_t.csv", "plot/c_allnoise_D", 
		ymin=0, ymax=0.20, width=3, height=6)

plot.compare2("table/relevel_allnoise_t.csv", "plot/c_allnoise_t", 
		ymin=0, ymax=8, width=3, height=6)
