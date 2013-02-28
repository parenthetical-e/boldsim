relevel.dataset <- function(csv, oldlevels, newlevels, name){
	
	# Get the csv data
	dt <- read.table(csv, sep=",", header=TRUE)
	
	# Extract datasets then loop,
	# getting old and new to swap them
	datasets <- as.character(dt$dataset)
	for(ii in 1:length(oldlevels)){
		oldl <- oldlevels[ii]
		newl <- newlevels[ii]
		mask <- datasets == oldl
		datasets[mask] <- newl
	}
	
	# Reattach datasets
	dt$dataset <- factor(datasets, levels=newlevels)
	
	# Write?

	print("Saving...")
	write.table(dt, name, row.names=FALSE, sep=",")

	#EOF
	dt
}
