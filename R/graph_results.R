source("R/cec_2015_problem_data.R")
library(plyr)
library(ggplot2)
library(reshape2)
library(ggthemes)
library(gridExtra)


## 1
setwd("output")
plots = list()
for(i in 1:20){
	results <- NA
	filenames.swarms <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")(_.*)([[:digit:]].txt)$", sep=""))
	results <- lapply(filenames.swarms, read.table)
	names(results) <- paste0('run',seq_along(results))
	results <- ldply(results)

	results <- rename(results, c("V1" = "iterations", "V2" = "swarms"))

	#results <- transform(results, run = sprintf('run%d', run)) 

	p1 = ggplot(results, aes(x = iterations, y = swarms, group=.id, colour="grey"))
	p1 = p1 + ggtitle(paste0("F",i)) + geom_line() + theme_tufte() + theme(legend.position = "none")
	p1 = p1 + stat_summary(fun.y = mean, geom="line", colour="black", aes(group = 1))
	plots[[i]] = p1
}
do.call("grid.arrange", c(plots, ncol = 4))



# calculate sr
source("../R/cec_2015_problem_data.R")
# calculate sr
library(pander)
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
sr <- as.data.frame(matrix(0,nrow=20,ncol=6))
mean <- as.data.frame(matrix(0,nrow=20,ncol=6))
sd <- as.data.frame(matrix(0,nrow=20,ncol=6))
for(i in 1:20){
	filenames.output <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")_.*\\output.txt$", sep=""))
	if(length(filenames.output) != 0){
		results <- lapply(filenames.output, read.table)
		names(results) <- paste0('run',seq_along(results))
		c_list <- ldply(results)
		sr[i,] <-c(apply(c_list[,2:6], 2, function(x) length(which(x < gens[i]))/length(x)), length(unique(c_list$.id)))
		mean[i, ] <- c(apply(c_list[,2:6], 2, function(x) mean(x)), length(unique(c_list$.id)))
		sd[i,] <-c(apply(c_list[,2:6], 2, function(x) sd(x)), length(unique(c_list$.id)))
	}
}
rownames(sr) = names
rownames(mean) = names
rownames(sd) = names
sr <- rename(sr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
mean <- rename(mean, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
sd <- rename(sd, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
# set.caption('Success Ratio over 50 runs')
# pander(sr)
# set.caption('Convergence Rates over 50 runs')
# pander(mean)


# calculate mpr
source("../R/cec_2015_problem_data.R")
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
mpr <- as.data.frame(matrix(0,nrow=20,ncol=6))
for(i in 1:20){
	filenames.output <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")_.*\\clist.txt$", sep=""))
	if(length(filenames.output) != 0){
		results <- lapply(filenames.output, read.table)
		max <- lapply(results, function (x) sapply(x, max))
		names(max) <- paste0('run',seq_along(max))
		c_list <- ldply(max)
		mpr[i,] <-c(apply(c_list[,2:6], 2, function(x) mean(x)/nopt[i]), length(unique(c_list$.id)))
	}
}
rownames(mpr) = names
mpr <- rename(mpr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
set.caption('Mean Peak Ratio over given runs')
pander(mpr)


mpr <- rename(mpr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))
rownames(mpr) <- names
set.caption('Mean Peak Ratio')
pander(mpr)


