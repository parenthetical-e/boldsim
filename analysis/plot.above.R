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


plot.above.4alpha <- function(csv, name, sigline=0.01, width=8, height=8){
	## Needs more work
	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	# drop the baseline cond
	dt <- dt[dt$cond != "baseline", ]
	
	# Keep only all conds then all bold that are
	# either value* or rpe*
	condidx <- grep("value", as.character(dt$cond))
	condidx <- c(condidx, grep("rpe", as.character(dt$cond)))
	dt <- dt[condidx, ]
	
	boldidx <- grep("value", as.character(dt$boldmeta))
	boldidx <- c(boldidx, grep("rpe", as.character(dt$boldmeta)))
	dt <- dt[boldidx, ]
	
	# Create a rpe/value factor
	modelkind <- rep("value", nrow(dt))
	modelkind[grep("rpe", as.character(dt$cond))] <- "rpe"
	dt$modelkind <- factor(modelkind)
	
	# Rename the boldmeta
	new_name <- c(
		"rpe0"="rpe_a0.1", "rpe1"="rpe_a0.3", "rpe2"="rpe_a0.6", 
		"rpe3"="rpe_a1", 
		"value0"="value_a0.1", "value1"="value_a0.3", "value2"="value_a0.6",
		"value3"="value_a1")
	newbolds <- rep(0, nrow(dt))
	newconds <- rep(0, nrow(dt))
	for(ii in 1:nrow(dt)){
		newb <- as.character(dt$boldmeta[ii])
		newbolds[ii] <- new_name[[newb]]
		
		newc <- as.character(dt$cond[ii])
		newconds[ii] <- new_name[[newc]]
	}
	dt$newbolds <- factor(newbolds)
	dt$newconds <- factor(newconds)
	
	p <- ggplot(dt, aes(x=newbolds, y=area, colour=newconds)) +
		geom_point() +
		geom_line(aes(group=newconds)) +
		xlab("Bold") +
		facet_grid(.~modelkind, scales = "free_x") +
		scale_colour_brewer(palette="BrBG", name = "Predictor") +
		theme_bw() +
		ylim(0, 1) +
		ylab("Normalized area") +
		theme(axis.text.x=element_text(angle=-90, vjust=0.5)) +
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

