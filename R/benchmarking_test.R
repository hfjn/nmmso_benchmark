library(devtools)
load_all("../nmmso/")
source("./R/cec_2015_problem_data.R")
source("./R/niching_funcs.R")
source("./R/count_goptima.R")

library(pryr)

set.seed = Sys.time()

# using the CEC test problems

eval_list = c()
c_list = c()
pop_size = c()
initial_flag = 0
conv_evals = c()

acc = c(0.1, 0.01, 0.001, 0.0001, 0.00001)

state = list()

evaluations_after = 0
index = 7

count = c(0,0,0,0,0)

mode_loc_after = list()
mode_y_after = list()
nmmso_state = list()
evaluations_after = 0

while(evaluations_after < gens[[index]] && count[5] != nopt[index]){
	old_count = count
	result <- NMMSO_iterative(swarm_size = as.numeric(10*length(mx[[index]])), problem_function = vincent, max_evaluations = gens[[index]], mn = as.numeric(mn[[index]]), mx = as.numeric(mx[[index]]), evaluations = evaluations_after, nmmso_state = nmmso_state)
	mode_loc_after = result$mode_loc
	mode_y_after = result$mode_y
	evaluations_after = result$evaluations
	nmmso_state = result$nmmso_state
	best = which(mode_y_after > max(mode_y_after)-0.1)
	for(i in 1:5){
		count[i] = count_goptima(as.matrix(mode_loc_after[best, , drop=FALSE]), index, acc[i])$count
	}
	eval_list = rbind(eval_list, as.matrix(evaluations_after))
	c_list = rbind(c_list, rbind(count))
	pop_size = c(pop_size, length(mode_y_after))
}


if(evaluations_after > gens[index]){
	c_list = c_list[-length(c_list), ,drop=FALSE]
	count = old_count
}


for(j in 1:5){
	I = which(c_list[,j] == nopt[index])
	if(length(I) != 0)
		conv_evals[j] = eval_list[I[1]]
	else
		conv_evals[j] = gens[index] + 1
}

print(count)
print(conv_evals)
