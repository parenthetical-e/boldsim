plot.dmcorr <- function(csv, csv_nohrf, name, width, height){
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	# Combined data using a factor 
	# To keep track of each
	with <- read.table(csv, sep=",", header=TRUE)
	with[["hrf"]] <- factor(rep("with_hrf", nrow(with)))
	
	without <- read.table(csv_nohrf, sep=",", header=TRUE)
	without[["hrf"]] <- factor(rep("without_hrf", nrow(without)))

	combined <- rbind(with, without)

	# Drop the baseline cond0s and box bold signals
	combined <- combined[combined$cond0 != "box", ]
	combined <- combined[combined$cond1 != "box", ]

	corrs <- c("tau", "r", "rho")
		
	# Process p values into a factor	
	for(corr in corrs){
		signif <- rep("insignificant", nrow(combined))
			## Init
		
		# Create p_name -> p and useit to 
		# lookup the p-values for corr
		p <- paste("p", corr, sep="_")
		signif[combined[[p]] <= 0.01] <- "p<0.01"

		# And add a factor
		combined[[paste("signif", corr, sep="_")]] <- factor(
				signif, levels=c("insignificant", "p<0.01"))
	}

	for(corr in corrs){
		# Normalize names for parts of the data
		tmpdata <- combined
		tmpdata[["corr"]] <- combined[[corr]]
		tmpdata[["signif"]] <- combined[[paste("signif", corr, sep="_")]]
		
		# And plot corr
		p <- ggplot(tmpdata, aes(x=hrf, y=corr, colour=cond0)) +
			geom_point() +
			geom_line(aes(group=cond0), stat="identity") +
			facet_grid(cond1~.) +
			scale_colour_discrete(name = "Predictor") +
			xlab("Simulation") +
			theme_bw() +
			ylim(-.1, 1) +
			ylab(corr) +
			theme(axis.text.x=element_text(angle=-90, vjust=0.5),
					strip.text.y = element_text(angle=-90))

		print(p)  
			## Add a page (of p) to the pdf() devic
	}
	dev.off()
}

