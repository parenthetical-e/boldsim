require("ggplot2")

plot.above <- function(csv, name, width=8, height=8){

	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	# drop the baseline cond
	dt <- dt[dt$cond != "baseline", ]
	
	bolds <- unique(dt$boldmeta)
	for(bold in bolds){
		dtf <- dt[dt$boldmeta == bold, ]
		p <- qplot(x=cond, y=area, fill=cond, 
			data=dtf, geom="bar", stat="identity") +
			theme_bw() +
			ylim(0, 1) +
			theme(axis.text.x=element_blank()) +
			geom_hline(yintercept=0.05, color="red") +
			theme(strip.text.x=element_text(angle=-90)) +
			facet_grid(.~dmmeta, scales="free_x") +
			ggtitle(paste("Bold: ",bold,sep=""))
			
		print(p)  ## Add a page (of p) to the pdf() device
	}
	dev.off()
}


plot.above.combined2 <- function(csvs, csv_labels, name, sigline=0.01, width=8, height=8){

	dt <- NULL
	for(ii in 1:length(csvs)){
		csv <- csvs[ii]
		lab <- csv_labels[ii]
		
		tempdt <- read.table(csv, sep=",", header=TRUE)
		tempdt$dataset <- factor(rep(lab, nrow(tempdt)))
		
		dt <- rbind(dt, tempdt)
	}
	
	# Drop the baseline predictor
	dt <- dt[dt$cond != "baseline", ]
	
	# We're focusing on the model-based outcomes,
	# not the binary case	
	dt <- dt[dt$cond != "box", ]	
	dt <- dt[dt$dmmeta != "baseline_box", ]
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...

	p <- ggplot(dt, aes(x=dataset, y=area, colour=cond)) +
		geom_point() +
		geom_line(aes(group=cond), stat="identity") +
		scale_colour_discrete(name = "Predictor") +
		xlab("Simulation") +
		facet_grid(.~boldmeta) +
		theme_bw() +
		ylim(0, 1) +
		ylab("Normalized area") +
		theme(axis.text.x=element_text(angle=-90, vjust=0.5),
				strip.text.y = element_text(angle=0)) +
		geom_hline(yintercept=sigline, color="red") +
		ggtitle(paste("Criterion: p < ", sigline, sep=""))

	print(p)  ## Add a page (of p) to the pdf() device
	dev.off()
}



plot.above.combined <- function(csv, name, sigline=0.01, width=8, height=8){

	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...

	# drop the baseline cond
	dt <- dt[dt$cond != "baseline", ]

	p <- qplot(x=cond, y=area, fill=cond, 
		data=dt, geom="bar", stat="identity") + 	
		facet_grid(dmmeta~boldmeta) +
		theme_bw() +
		ylim(0, 1) +
		ylab("Normalized area above criterion") +
		theme(axis.ticks.x=element_blank(), 
				axis.text.x=element_blank(),
				axis.title.x=element_blank(), 
				strip.text.y = element_text(angle=0)) +
		geom_hline(yintercept=sigline, color="red") +
		ggtitle(paste("Criterion: ", sigline, sep=""))

	print(p)  ## Add a page (of p) to the pdf() device
	dev.off()
}


plot.compare <- function(csv, name, marks, ymin=-6, ymax=8, width=8, height=8){
	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf", sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	bolds <- unique(dt$boldmeta)
	for(bold in bolds){
		dtf <- dt[dt$boldmeta == bold, ]
		limits <- aes(ymax = mean + se, ymin=mean - se)
		p <- ggplot(dtf, aes(x=dataset, y=mean/max(mean), fill=dataset)) + 
			geom_bar() +
			theme_bw() + 
			geom_hline(yintercept=marks, color="red") +
			theme(axis.text.x=theme_blank()) +
			theme(strip.text.y = element_text(angle=0)) +
			facet_grid(dmmeta~cond) +
			# geom_errorbar(limits, width=0.25) +
			ylim(ymin, ymax) +
			ggtitle(paste("Bold: ", bold, sep=""))

		print(p)  ## Add a page (of p) to the pdf() device
	}
	dev.off()
}

plot.compare2 <- function(csv, name, marks, ymin=-6, ymax=8, width=8, height=8){
	dt <- read.table(csv, sep=",", header=TRUE)
	
	# drop the baseline cond
	dt <- dt[dt$cond != "baseline", ]
	print(str(dt))
	
	# Keep only when bols matches cond
	conds <- as.character(dt$cond)
	bolds <- as.character(dt$boldmeta)
	mask <- conds == bolds
	print(mask)
	dt <- dt[mask, ]
	print(str(dt))
	
	pdf(file=paste(name, ".pdf", sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	limits <- aes(ymax = mean + se, ymin=mean - se)
	p <- ggplot(dt, aes(x=dataset, y=mean, colour=cond)) + 
		geom_point() +
		geom_line(aes(group=cond)) +
		theme_bw() + 
		geom_hline(yintercept=marks, color="red") +
		# theme(axis.text.x=element_blank()) +
		theme(axis.text.x = element_text(angle=-90)) +
		facet_grid(.~boldmeta) +
		# geom_errorbar(limits, width=0.25) +
		ylim(ymin, ymax)

	print(p)  ## Add a page (of p) to the pdf() device
	dev.off()
}


releveled.dataset <- function(csv, oldlevels, newlevels, save=TRUE){
	require("plyr")
	
	dt <- read.table(csv, sep=",", header=TRUE)	
	mapvalues(dt, from = oldlevels, to = newlevels)
	
	if(save){
		write.table(dt, paste("relevds_", csv), 
				row.names=FALSE, header=TRUE, sep=",")		
	}

	dt
}

