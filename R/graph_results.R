source("R/cec_2015_problem_data.R")
library(plyr)
library(ggplot2)
library(reshape2)
library(ggthemes)
library(gridExtra)


## 1
plots = list()
for(i in 1:20){
	filenames.swarms <- list.files(full.names = TRUE, path='.', pattern=paste("(^",i,")(_.*)([[:digit:]].txt)$", sep=""))
	results <- lapply(filenames.swarms, read.table)
	results <- ldply(results)

	results <- rename(results, c("V1" = "iterations", "V2" = "swarms"))

	#results <- transform(results, run = sprintf('run%d', run)) 

	p1 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light")) + theme_tufte()
	p1 = p1 + ggtitle(paste("F", i, sep="")) + geom_line() + stat_summary(fun.y=mean, size=1.5, geom="line", aes(colour="mean")) + theme(legend.position = "none")
	plots[[i]] = p1
}
do.call("grid.arrange", c(plots, ncol = 4))



# calculate sr
source("../R/cec_2015_problem_data.R")
# calculate sr
library(pander)
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
sr <- as.data.frame(matrix(0,nrow=20,ncol=5))
mean <- as.data.frame(matrix(0,nrow=20,ncol=5))
sd <- as.data.frame(matrix(0,nrow=20,ncol=5))
for(i in 1:20){
	filenames.output <- list.files(fill.names = TRUE, path='.', pattern=paste("(^",i,")_.*\\output.txt$", sep=""))
	if(length(filenames.output) != 0){
		results <- lapply(filenames.output, read.table)
		c_list <- ldply(results)
		sr[i,] <-(apply(c_list, 2, function(x) length(which(x < gens[i]))/length(x)))
		mean[i, ] <- (apply(c_list, 2, function(x) mean(x)))
		sd[i,] <-(apply(c_list, 2, function(x) sd(x)))
	}
}
rownames(sr) = names
rownames(mean) = names
rownames(sd) = names
sr <- rename(sr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))
mean <- rename(mean, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))
sd <- rename(sd, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))
set.caption('Success Ratio over 50 runs')
pander(sr)
set.caption('Convergence Rates over 50 runs')
pander(mean)

for(i in 1:5){
	c_list <- read.table(paste("../output/", i,"_output.txt", sep = ""))
	sr[i,] <-(apply(c_list, 2, function(x) length(which(x < gens[i]))/50))
}

# calculate mpr
source("../R/cec_2015_problem_data.R")
mpr <- as.data.frame(matrix(0,nrow=20,ncol=5))
for(i in 1:5){
	c_list <- read.table(paste("../output/", i,"_clist.txt", sep = ""))
	mpr[i,] <- (apply(c_list, 1, function(x) mean(x/nopt[i])))
}
mpr <- rename(mpr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))
rownames(mpr) <- names
set.caption('Mean Peak Ratio')
pander(mpr)


