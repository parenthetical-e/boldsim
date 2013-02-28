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


plot.above.alpha <- function(csv, name, sigline=0.01, width=8, height=8){
	## Needs more work
	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	# Keep only all conds then all bold that are
	# either value* or rpe*
	condidx <- grep("value", as.character(dt$cond))
	condidx <- c(condidx, grep("rpe", as.character(dt$cond)))
	dt <- dt[condidx, ]
	
	boldidx <- grep("value", as.character(dt$boldmeta))
	boldidx <- c(boldidx, grep("rpe", as.character(dt$boldmeta)))
	dt <- dt[boldidx, ]
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	p <- ggplot(dt, aes(x=cond, y=area)) +
		geom_bar(stat="identity") +
		# geom_line(aes(group=cond), stat="identity") +
		xlab("Predictor") +
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
		facet_grid(boldmeta~.) +
		theme_bw() +
		ylim(0, 1) +
		ylab("Normalized area") +
		theme(axis.text.x=element_text(angle=-90, vjust=0.5),
				strip.text.y = element_text(angle=-90)) +
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

