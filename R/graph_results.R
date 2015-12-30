### Single Calculations used in the documentation to graph the results of nmmso.

source("R/cec_2015_problem_data.R")
library(plyr)
library(ggplot2)
library(reshape2)
library(ggthemes)
library(gridExtra)


# set the output folder
setwd("output")

# first create plot which shows the number of swarms for all single functions
plots = list()
for(i in 1:20){
	results <- NA
	# read all files which match the following pattern (<functionumber>_<seed>.txt)
	filenames.swarms <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")(_.*)([[:digit:]].txt)$", sep=""))
	results <- lapply(filenames.swarms, read.table)
	names(results) <- paste0('run',seq_along(results))
	# put all table into one data.frame
	results <- ldply(results)

	results <- rename(results, c("V1" = "iterations", "V2" = "swarms"))

	# create ggplot with wished design
	p1 = ggplot(results, aes(x = iterations, y = swarms, group=.id, colour="grey"))
	p1 = p1 + ggtitle(paste0("F",i)) + geom_line() + theme_tufte() + theme(legend.position = "none")
	p1 = p1 + stat_summary(fun.y = mean, geom="line", colour="black", aes(group = 1))
	# add plot to list of plots
	plots[[i]] = p1
}
# plot all single plots and arrange them in grid
do.call("grid.arrange", c(plots, ncol = 4))

# calculate Success Rate
source("../R/cec_2015_problem_data.R")
# calculate sr
library(pander)
# create vector of Function names
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
# preallocate dataframes for comparison data
sr <- as.data.frame(matrix(0,nrow=20,ncol=6))
mean <- as.data.frame(matrix(0,nrow=20,ncol=6))
sd <- as.data.frame(matrix(0,nrow=20,ncol=6))
# do it for all 20 functions
for(i in 1:20){
	# read all files which match the following pattern: <functionumber>_<seed>output.txt
	filenames.output <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")_.*\\output.txt$", sep=""))
	if(length(filenames.output) != 0){
		results <- lapply(filenames.output, read.table)
		names(results) <- paste0('run',seq_along(results))
		# apply the needed calculations to create the single measures
		c_list <- ldply(results)
		sr[i,] <-c(apply(c_list[,2:6], 2, function(x) length(which(x < gens[i]))/length(x)), length(unique(c_list$.id)))
		mean[i, ] <- c(apply(c_list[,2:6], 2, function(x) mean(x)), length(unique(c_list$.id)))
		sd[i,] <-c(apply(c_list[,2:6], 2, function(x) sd(x)), length(unique(c_list$.id)))
	}
}
# put the fitting rownames in the data frames
rownames(sr) = names
rownames(mean) = names
rownames(sd) = names
# put the fitting column names in the data frames
sr <- rename(sr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
mean <- rename(mean, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
sd <- rename(sd, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
# create pander tables
set.caption('Success Ratio over 50 runs')
pander(sr)
set.caption('Convergence Rates over 50 runs')
pander(mean)


# the same as above for the peak ratio
# calculate pr
source("../R/cec_2015_problem_data.R")
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
pr <- as.data.frame(matrix(0,nrow=20,ncol=6))
for(i in 1:20){
	filenames.output <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")_.*\\clist.txt$", sep=""))
	if(length(filenames.output) != 0){
		results <- lapply(filenames.output, read.table)
		max <- lapply(results, function (x) sapply(x, max))
		names(max) <- paste0('run',seq_along(max))
		c_list <- ldply(max)
		pr[i,] <-c(apply(c_list[,2:6], 2, function(x) sum(x)/(nopt[i]*length(x))), length(unique(c_list$.id)))
	}
}
rownames(pr) = names
pr <- rename(pr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001", "V6" = "runs"))
set.caption('Mean Peak Ratio over given runs')
pander(pr)


pr <- rename(pr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))
rownames(pr) <- names
set.caption('Mean Peak Ratio')
pander(pr)


# added calculation for time consumption of single functions
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
times <- as.data.frame(matrix(0, nrow = 20, ncol = 2))
for(i in 1:20){
	filenames.times <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")_.*\\_time.txt$", sep=""))
	if(length(filenames.times) != 0){
		results <- lapply(filenames.times, read.table)
		time <- ldply(results)
		mean <- mean(time$V3)
		sd <- sd(time$V3)
		times[i,] <- c(mean, sd)
	}
}
rownames(times) = names
times <- rename(times, c("V1" = "Mean", "V2" = "Standard Deviation"))

pander(times)
