source("R/cec_2015_problem_data.R")
library(plyr)
library(ggplot2)
library(reshape2)
library(ggthemes)

index = 5

results <- read.table(paste("documentation/output/",index, ".txt", sep=""))

results <- rename(results, c("V1" = "run", "V2" = "iterations", "V3" = "swarms"))

results <- transform(results, run = sprintf('run%d', run)) 

p1 = ggplot(results, aes(x = iterations, y = swarms, colour="theme_light"), linetype= run)
p1 + geom_line() + stat_summary(fun.y=mean, colour="black", geom="line", aes(group = 1)) + theme_tufte() + theme(legend.position = "none")

runs <- read.table(paste("output/", index,"_output.txt", sep =""))

# calculate convergence rates
mean(runs$V1)
sd(runs$V1)

mean(runs$V4)
sd(runs$V4)


# calculate sr
library(ascii)
library(memisc)
sr <- as.data.frame(matrix(seq(20),nrow=20,ncol=5))
for(i in 1:5){
	c_list <- read.table(paste("output/", i,"_output.txt", sep = ""))
	sr[i,] <- (apply(c_list, 2, function(x) length(which(x < gens[i]))/50))
}

sr <- rename(sr, c("V1" = "0.1", "V2" = "0.01", "V3" = "0.001", "V4" = "0.0001", "V5" = "0.00001"))

print(ascii(sr), caption="SR Values", style=c("d", "d", "d"), type="pandoc")


