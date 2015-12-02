source("./R/niching_funcs.R")
source("./R/feval.R")
source("./R/count_goptima.R")

# Demonstration file on how to use the benchmark suite of the Competition 

dims = c(1, 1, 1, 2, 2, 2, 2, 3, 3, 2, 2, 2, 2, 3, 3, 5, 5, 10, 10, 20) # dimensionality of benchmark functions
max_fes = c(50000 * matrix(1, 1, 5), 200000, 200000, 400000, 400000, 200000 * matrix(1, 1, 4), 400000 * matrix(1, 1, 7))

# do not forget
initial_flag = 0 # the global flag used in test suite

for(func_num in 1:20) {
	# set the lower and upper bound for each function
	# do not forget
	initial_flag = 0 # should set the flag to 0 for each run, each function

	# dimension of the problem
	d = dims[func_num]

	# potential solution
	x = matrix(1, 1, d)
	# evaluate the solution
	val = niching_func(x, func_num) # fitness evaluation
	cat("f_", func_num, " : f(1...1) = ", val, "\n")
}

fgoptima = c(200.0, 1.0, 1.0, 200.0, 1.03163, 186.731, 1.0, 2709.0935, 1.0, -2.0, matrix(0, 1, 10))
np = 100
for(func_num in 1:20) {
	# do not forget
	initial_flag = 0 # should set the flag to 0 for each run, each function
	d = dims[func_num]

	# randomize population within optimization bounds
	# (here dummy initialization within [0, 1] only for demo)
	pop = matrix(runif(np * d), np, d)
	#pop = matrix(1:4, 4, 1)

	# how many global optima have been found?
	accuracy = 0.001
	result = count_goptima(pop, func_num, accuracy)
	count = result$count
	goptima_found = result$finalseeds
	cat("f_", func_num, ", In the current population there are ", count, " global optima.\n")

	# print some stuff :-)
	if(count != 0) {
		for(i in 1:size(goptima_found)[1]) {
			val = niching_func(goptima_found[i], func_num)
			cat("F_p: ", val, ", F_g: ", fgoptima[func_num], ", diff: ", abs(val - fgoptima[func_num]), ".\n")
			cat("F_p - F_g <= ", accuracy, " : ", abs(val - fgoptima[func_num]) < accuracy, ".\n")
		}
	} 
}
