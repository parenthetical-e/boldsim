require("ggplot2")

plot.above <- function(csv, name, width=8, height=8){

	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	bolds <- unique(dt$boldmeta)
	for(bold in bolds){
		dtf <- dt[dt$boldmeta == bold, ]
		p <- qplot(x=cond, y=area, fill=cond, 
			data=dtf, geom="bar", stat="identity") + 	
			theme_bw() +
			ylim(0, 1) +
			theme(axis.text.x=element_blank()) +
			geom_hline(yintercept=0.05, color="red") +
			theme(strip.text.x = element_text(angle=-90)) +
			facet_grid(.~dmmeta, scales="free_x") +
			ggtitle(paste("Bold: ", bold, sep=""))

		print(p)  ## Add a page (of p) to the pdf() device
	}
	dev.off()
}


plot.above.combined <- function(csv, name, sigline=0.01, width=8, height=8){

	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...

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
		p <- ggplot(dtf, aes(x=dataset, y=mean, fill=dataset)) + 
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
