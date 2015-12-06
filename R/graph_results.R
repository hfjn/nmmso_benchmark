source("R/cec_2015_problem_data.R")
library(plyr)
library(ggplot2)
library(reshape2)
library(ggthemes)

## 1
index = 1

results <- read.table(paste("../output/",index, ".txt", sep=""))

results <- rename(results, c("V1" = "run", "V2" = "iterations", "V3" = "swarms"))

results <- transform(results, run = sprintf('run%d', run)) 

p1 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light"), linetype= run)
p1 = p1 + geom_line() + stat_summary(fun.y=mean, colour="black", geom="line", aes(group = 1)) + theme_tufte() + theme(legend.position = "none")


## 2
index = 2

results <- read.table(paste("../output/",index, ".txt", sep=""))

results <- rename(results, c("V1" = "run", "V2" = "iterations", "V3" = "swarms"))

results <- transform(results, run = sprintf('run%d', run)) 

p2 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light"), linetype= run)
p2 = p2 + geom_line() + stat_summary(fun.y=mean, colour="black", geom="line", aes(group = 1)) + theme_tufte() + theme(legend.position = "none")

## 3

index = 3

results <- read.table(paste("../output/",index, ".txt", sep=""))

results <- rename(results, c("V1" = "run", "V2" = "iterations", "V3" = "swarms"))

results <- transform(results, run = sprintf('run%d', run)) 

p3 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light"), linetype= run)
p3 = p3 + geom_line() + stat_summary(fun.y=mean, colour="black", geom="line", aes(group = 1)) + theme_tufte() + theme(legend.position = "none")


## 4
index = 4

results <- read.table(paste("../output/",index, ".txt", sep=""))

results <- rename(results, c("V1" = "run", "V2" = "iterations", "V3" = "swarms"))

results <- transform(results, run = sprintf('run%d', run)) 

p4 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light"), linetype= run)
p4 = p4 + geom_line() + stat_summary(fun.y=mean, colour="black", geom="line", aes(group = 1)) + theme_tufte() + theme(legend.position = "none")

## 5
index = 5

results <- read.table(paste("../output/",index, ".txt", sep=""))

results <- rename(results, c("V1" = "run", "V2" = "iterations", "V3" = "swarms"))

results <- transform(results, run = sprintf('run%d', run)) 

p5 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light"), linetype= run)
p5 = p5 + geom_line() + stat_summary(fun.y=mean, colour="black", geom="line", aes(group = 1)) + theme_tufte() + theme(legend.position = "none")

grid.arrange(p1, p2, p3,p4,p5,p2, p3,p4,p5, p1, p1, p2, p3,p4,p5,p2, p3,p4,p5, p1, ncol=4)

# calculate convergence rates
mean(runs$V1)
sd(runs$V1)

mean(runs$V4)
sd(runs$V4)


# calculate sr
source("../R/cec_2015_problem_data.R")
# calculate sr
library(pander)
names <- c("F1", "F2", "F3", "F4", "F5", "F6", "F7", "F8", "F9", "F10", "F11", "F12", "F13", "F14", "F15", "F16", "F17", "F18", "F19", "F20")
sr <- as.data.frame(matrix(0,nrow=20,ncol=5))
mean <- as.data.frame(matrix(0,nrow=20,ncol=5))
sd <- as.data.frame(matrix(0,nrow=20,ncol=5))
for(i in 1:5){
	c_list <- read.table(paste("../output/", i,"_output.txt", sep = ""))
	sr[i,] <-(apply(c_list, 2, function(x) length(which(x < gens[i]))/50))
	mean[i, ] <- (apply(c_list, 2, function(x) mean(x)))
	sd[i,] <-(apply(c_list, 2, function(x) sd(x)))
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


