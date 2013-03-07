plot.hist <- function(csv, name, sigline, width, height){
	
	# Get the data
	dt <- read.table(csv, sep=",", header=TRUE)
	
	# Drop the baseline cond
	dt <- dt[dt$cond != "baseline", ]
	dt <- dt[dt$cond != "box", ]
	
	# Drop the box BOLD
	dt <- dt[dt$boldmeta != "box", ]
	
	# Open pdf device
	pdf(file=paste(name, ".pdf", sep=""), width=width, height=height)  
	
	# Build up the plot
	p <- ggplot(dt, aes(x=t, y=count, fill=cond)) +
	geom_density(stat="identity", alpha=0.5) +
	scale_fill_discrete(name = "Predictor") +
	theme_bw() + 
	geom_vline(xintercept=sigline, color="red") +
	facet_grid(boldmeta~.) +
	ylab("Counts") +
	xlab("t-value")

	# Plot it and clean up
	print(p)
	dev.off()
}


plot.dmhist_hrf <- function(csv, csv_nohrf, name, width, height){
	
	# Combined data using a factor 
	# To keep track of each
	with <- read.table(csv, sep=",", header=TRUE)
	with[["hrf"]] <- factor(rep("with_hrf", nrow(with)))
	
	without <- read.table(csv_nohrf, sep=",", header=TRUE)
	without[["hrf"]] <- factor(rep("without_hrf", nrow(without)))

	combined <- rbind(with, without)
 
	# Drop the baseline cond0s and box bold signals
	combined <- combined[combined$cond != "box", ]
	combined <- combined[combined$cond != "acc", ]
	# combined <- combined[combined$cond != "p", ]
	
	# Open pdf device
	pdf(file=paste(name, ".pdf", sep=""), width=width, height=height)  
	
	# Build up the plot
	p <- ggplot(combined, aes(x=x, y=count, colour=cond)) +
		geom_density(aes(fill=cond), stat="identity", alpha=0.2) +
		guides(fill=FALSE) +
		theme_bw() + 
		facet_grid(.~hrf, scale="free") +
		coord_cartesian(ylim=c(0,6000)) +
		ylab("Counts") +
		xlab("x")

	# Plot it and clean up
	print(p)
	
	dev.off()
}


