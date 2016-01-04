# test comparison values out of matlab
data(vals)
test_that("all functions give the same values as in matlab", {
	for(func_num in 1:20) {
		# set the lower and upper bound for each function
		# do not forget
		initial_flag = 0 # should set the flag to 0 for each run, each function
		# dimension of the problem
		d = dims[func_num]	
		# potential solution
		x = matrix(1, 1, d)
		# evaluate the solution
		val = niching_func(x, func_num) 
		# fitness evaluation
		expect_true(val == vals[func_num])
	}
})