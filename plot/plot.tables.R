require("ggplot2")

plot.above <- function(csv, name, width, height){

	dt <- read.table(csv, sep=",", header=TRUE)
	
	pdf(file=paste(name, ".pdf",sep=""),
			width=width, height=height)  
			## Print to a pdf device...
	
	bolds <- unique(dt$boldmeta)
	for(bold in bolds){
		dtf <- dt[dt$boldmeta == bold, ]
		p <- qplot(x=cond, y=area, data=dtf, 
			geom="bar", stat="identity") + 
			theme_bw() + 
			theme(axis.text.x=element_text(angle=-90,vjust=0.5)) +
			theme(strip.text.y = element_text(angle=0)) +
			facet_grid(~dmmeta, scales="free_x") +
			ggtitle(paste("Bold: ", bold, sep=""))

		print(p)  ## Add a page (of p) to the pdf() device
	}
	dev.off()
}

plot.compare <- function(csv, name, width, height){
	# pass
}