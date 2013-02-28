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
