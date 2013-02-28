plot.compare.D <- function(csv, name, marks, ymin=-6, ymax=8, width=8, height=8){
	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf", sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	bolds <- unique(dt$boldmeta)
	for(bold in bolds){
		dtf <- dt[dt$boldmeta == bold, ]
		p <- ggplot(dtf, aes(x=dataset, y=D/max(D), fill=dataset)) + 
			geom_bar() +
			theme_bw() + 
			geom_hline(yintercept=marks, color="red") +
			theme(axis.text.x=theme_blank()) +
			theme(strip.text.y = element_text(angle=0)) +
			facet_grid(dmmeta~cond) +
			ylim(ymin, ymax) +
			ggtitle(paste("Bold: ", bold, sep=""))

		print(p)  ## Add a page (of p) to the pdf() device
	}
	dev.off()
}


plot.compare2.D <- function(csv, name, ymin=-6, ymax=8, width=8, height=8){
	dt <- read.table(csv, sep=",", header=TRUE)
	
	# drop the baseline cond
	dt <- dt[dt$cond != "baseline", ]
	
	# Keep only when bols matches cond
	conds <- as.character(dt$cond)
	bolds <- as.character(dt$boldmeta)
	mask <- conds == bolds
	dt <- dt[mask, ]
	
	pdf(file=paste(name, ".pdf", sep=""),
			width=width, height=height)  
			## Print to a pdf device...
				
	p <- ggplot(dt, aes(x=dataset, y=D, fill=cond)) +
		geom_bar(stat="identity") +
		scale_fill_discrete(name = "Predictor") +
		theme_bw() + 
		theme(axis.text.x = element_text(angle=-90,vjust=0.5)) +
		facet_grid(boldmeta~.) +
		ylim(ymin, ymax) +
		ylab("Avg. Cohen's D") +
		xlab("Simulation") 

	print(p)  ## Add a page (of p) to the pdf() device
	dev.off()
}
