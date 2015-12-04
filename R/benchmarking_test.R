library(devtools)
load_all("../nmmso/")
source("./R/cec_2015_problem_data.R")
source("./R/niching_funcs.R")
source("./R/count_goptima.R")

library(pryr)

set.seed = Sys.time()
niching_funcs = c(five_uneven_peak_trap, equal_maxima, uneven_decreasing_maxima,
                  himmelblau, six_hump_camel_back, shubert, vincent, shubert, vincent,
                  modified_rastrigin_all, CF1, CF2)
# using the CEC test problems, all 20.
for(index in 1:20){
  # run each 50 times.
  for(run in 1:50){
    # set new seed
    set.seed = Sys.time()
    eval_list = c()
    c_list = c()
    pop_size = c()
    initial_flag = 0
    conv_evals = c()

    acc = c(0.1, 0.01, 0.001, 0.0001, 0.00001)

    state = list()

    evaluations_after = 0

    count = c(0,0,0,0,0)

    mode_loc_after = list()
    mode_y_after = list()
    nmmso_state = list()
    evaluations_after = 0

    while(evaluations_after < gens[[index]] && count[5] != nopt[index]){
    	old_count = count
    	result <- NMMSO_iterative(swarm_size = as.numeric(10*length(mx[[index]])), problem_function = niching_funcs[[index]], max_evaluations = gens[[index]], mn = as.numeric(mn[[index]]), mx = as.numeric(mx[[index]]), evaluations = evaluations_after, nmmso_state = nmmso_state)
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
    	write(c(evaluations_after, length(nmmso_state$swarms)), file = paste("./output/", index,"_", run, ".txt", sep = ""), append = TRUE)
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

    write(conv_evals, paste("./output/", index,"_output.txt", sep = ""), append = TRUE)
    write(c_list, paste("./output/", index, "_", run, "_clist.txt", sep = ""), append = TRUE)
  }
}

