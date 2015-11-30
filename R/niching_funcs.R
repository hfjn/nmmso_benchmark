library(pracma)

#' @title niching_func
#' @description Benchmark Functions for CEC'2013 Special Session and Competition on Niching Methods for Multimodal Function Optimization.
#' This benchmark set includes the following 12 multimodal test functions:
#' F1 : Five-Uneven-Peak Trap (1D)
#' F2 : Equal Maxima (1D)
#' F3 : Uneven Decreasing Maxima (1D)
#' F4 : Himmelblau (2D)
#' F5 : Six-Hump Camel Back (2D)
#' F6 : Shubert (2D, 3D)
#' F7 : Vincent (2D, 3D)
#' F8 : Modified Rastrigin - All Global Optima (2D)
#' F9 : Composition Function 1 (2D)
#' F10 : Composition Function 2 (2D)
#' F11 : Composition Function 3 (2D, 3D, 5D, 10D)
#' F12 : Composition Function 4 (3D, 5D, 10D, 20D)
#'
#' For more information please refer to the Technical Report of the
#' Special Session/Competition at: http://goanna.cs.rmit.edu.au/~xiaodong/cec13-niching/
#'
#' @param x is a 1xD input vector for evaluation.
#' @param func_num denotes the number of the objective function which is going to be used.
#' @return The objective function value of the x input vector.
#'
#' @export
niching_func = function(x, func_num) {
	total_func_no = 20
	MINMAN = 1 # maximization

	if(func_num == 1) {
		f = feval(five_uneven_peak_trap, x)
	} else if(func_num == 2) {
		f = feval(equal_maxima, x)
	} else if(func_num == 3) {
		f = feval(uneven_decreasing_maxima, x)
	} else if(func_num == 4) {
		f = feval(himmelblau, x)
	} else if(func_num == 5) {
		f = feval(six_hump_camel_back, x)
	} else if(func_num == 6) {
		f = feval(shubert, x)
	} else if(func_num == 7) {
		f = feval(vincent, x)
	} else if(func_num == 8) {
		f = feval(shubert, x)
	} else if(func_num == 9) {
		f = feval(vincent, x)
	} else if(func_num == 10) {
		f = feval(modified_rastrigin_all, x)
	} else if(func_num == 11) {
		f = feval(CF1, x)
	} else if(func_num == 12) {
		f = feval(CF2, x)
	# } else if(func_num == 13) {
	# 	fname = "CF3"
	# } else if(func_num == 14) {
	# 	fname = "CF3"
	# } else if(func_num == 15) {
	# 	fname = "CF4"
	# } else if(func_num == 16) {
	# 	fname = "CF3"
	# } else if(func_num == 17) {
	# 	fname = "CF4"
	# } else if(func_num == 18) {
	# 	fname = "CF3"
	# } else if(func_num == 19) {
	# 	fname = "CF4"
	# } else if(func_num == 20) {
	# 	fname = "CF4"
	} else {
		cat("ERROR: Wrong function number: (", func_num, "). \n")
		cat("		Please provide a function number in {1, 2, ..., ", total_func_no, "}\n")
		cat("		For now function number == 1\n")
		f = feval(five_uneven_peak_trap, x)
	}

	f_bias = matrix(0, 1, total_func_no)
	fit = f_bias[func_num] + MINMAN * f

	return(fit)
}

#' @title F1: Five-Uneven-Peak Trap
#' @description Variables ranges: x in [0, 30]
#' No. of global peaks: 2
#' No. of local peaks: 3
#'
#' @param x
#' @return
#'
#' @export
five_uneven_peak_trap = function(x) {
	result = -1.0
	if(x >= 0 && x < 2.5) {
		result = 80 * (2.5 - x)
	} else if(x >= 2.5 && x < 5.0) {
		result = 64 * (x - 2.5)
	} else if(x >= 5.0 && x < 7.5) {
		result = 64 * (7.5 - x)
	} else if(x >= 7.5 && x < 12.5) {
		result = 28 * (x - 7.5)
	} else if(x >= 12.5 && x < 17.5) {
		result = 28 * (17.5 - x)
	} else if(x >= 17.5 && x < 22.5) {
		result = 32 * (x - 17.5)
	} else if(x >= 22.5 && x < 27.5) {
		result = 32 * (27.5 - x)
	} else if(x >= 27.5 && x <= 30) {
		result = 80 * (x - 27.5)
	}

	return(result)
}

#' @title F2: Equal Maxima
#' @description Variables ranges: x in [0, 1]
#' No. of global peaks: 5
#' No. of local peaks: 0
#'
#' @param x
#' @return
#'
#' @export
equal_maxima = function(x) sin(5 * pi * x)^6

#' @title F3: Uneven Decreasing Maxima
#' @description Variables ranges: x in [0, 1]
#' No. of global peaks: 1
#' No. of local peaks: 4
#'
#' @param x
#' @return
#'
#' @export
uneven_decreasing_maxima = function(x) {
	tmp1 = exp(-2 * log(2) * ((x - 0.08)/0.854)^2)
	tmp2 = sin(5 * pi * (x^0.75 - 0.05))^6
	return(tmp1 * tmp2)
}

#' @title F4: Himmelblau
#' @description Variables ranges: x, y in [-6, 6]
#' No. of global peaks: 4
#' No. of local peaks: 0
#'
#' @param x
#' @return
#'
#' @export
himmelblau = function(x) 200 - (x[1] * x[1] + x[2] - 11) * (x[1] * x[1] + x[2] - 11) - (x[1] + x[2] * x[2] - 7) * (x[1] + x[2] * x[2] - 7)

#' @title F5: Six-Hump Camel Back
#' @description Variables ranges: x in [-1.9, 1.9]; y in [-1.1, 1.1]
#' No. of global peaks: 2
#' No. of local peaks: 2
#'
#' @param x
#' @return
#'
#' @export
six_hump_camel_back = function(xx){
  x1 <- xx[1]
  x2 <- xx[2]

  term1 <- (4-2.1*x1^2+(x1^4)/3) * x1^2
  term2 <- x1*x2
  term3 <- (-4+4*x2^2) * x2^2

  y <- term1 + term2 + term3
  return(y)
}
#' @title F6: Shubert
#' @description Variables ranges: x_i in [-10, 10]^n, i = 1, 2, ..., n
#' No. of global peaks: n * 3^n
#' No. of local peaks: many
#'
#' @param x
#' @return
#'
#' @export
shubert = function(x) {
	d = size(x)[2]
	result = 1
	j = 1:5

	for(i in 1:d) {
		result = result * sum(j * cos((j + 1) * x[i] + j))
	}
	return(-result)
}

#' @title F7: Vincent
#' @description Variables ranges: x_i in [0.25, 10]^n, i = 1, 2, ..., n
#' No. of global peaks: 6^n
#' No. of local peaks: 0
#'
#' @param x
#' @return
#'
#' @export
vincent = function(x) {
	d = size(x)[2]
	return(sum(sin(10 * log(x)))/d)
}

#' @title F8: Modified Rastrigin - All Global Optima
#' @description Variables ranges: x_i in [0, 1]^n, i = 1, 2, ..., n
#' No. of global peaks: \prod_{i=1}^n k_i
#' No. of local peaks: 0
#'
#' @param x
#' @return
#'
#' @export
modified_rastrigin_all = function(x) {
	MMP = 0
	d = size(x)[2]
	if(d == 2) {
		MMP = c(3, 4)
	} else if(d == 8) {
		MMP = c(1, 2, 1, 2, 1, 3, 1, 4)
	} else if(d == 16) {
		MMP = c(1, 1, 1, 2, 1, 1, 1, 2, 1, 1, 1, 3, 1, 1, 1, 4)
	}
	return(-sum(10 + 9 * cos(2 * pi * MMP * x)))
}

eval_functions = function(fname, x) {
	switch(fname,
		FGriewank = feval(FGriewank, x),
		FWeierstrass = feval(FWeierstrass, x),
		FSphere = feval(FSphere, x),
		FRastrigin = feval(FRastrigin, x),
		FEF8F2 = feval(FEF8F2, x)
	)
}

# Global variables for composition functions
initial_flag = 0

#' @title Composition Function 1
#' @description n = 6
#'
#' @param x
#' @return
#'
#' @export
CF1 = function(x) {
	d = size(x)[2]
	func_num = 6
	lb = -5
	ub = 5
	o = 0
	if(initial_flag == 0) {
		#load data/optima.mat # saved the predifined optima
		if(length(o) >= d) {
			o = o[1:d]
		} else {
			o = lb + (ub - lb) * matrix(runif(func_num * d), func_num, d)
		}
		initial_flag = 1
		func = c("FGriewank", "FGriewank", "FWeierstrass", "FWeierstrass", "FSphere", "FSphere")
		bias = matrix(0, 1, func_num)
		sigma = matrix(1, 1, func_num)
		lambda = rbind(1, 1, 8, 8, 1/5, 1/5)
		lambda = repmat(lambda, 1, d)

		M = diag(1, d)
	}
	return(hybrid_composition_func(x, func_num, func, o, sigma, lambda, bias, M))
}

#' @title Composition Function 2
#' @description n = 8
#'
#' @param x
#' @return
#'
#' @export
CF2 = function(x) {
	d = size(x)[2]
	func_num = 8
	lb = -5
	ub = 5
	o = c()
	if(initial_flag == 0) {
		initial_flag = 1
		#load data/optima.mat # saved the predifined optima
		if(length(o) >= d) {
			o = o[1:d]
		} else {
			o = c(o, lb + (ub - lb) * matrix(runif(func_num * d), func_num, d))
		}
		func = c("FRastrigin", "FRastrigin", "FWeierstrass", "FWeierstrass", "FGriewank", "FGriewank", "FSphere", "FSphere")
		bias = matrix(0, 1, func_num)
		sigma = matrix(1, 1, func_num)
		lambda = rbind(1, 1, 10, 10, 1/10, 1/10, 1/7, 1/7)
		lambda = repmat(lambda, 1, d)

		M = diag(1, d)
	}
	return(hybrid_composition_func(x, func_num, func, o, sigma, lambda, bias, M))
}

#' @title Composition Function 3
#' @description n = 6
#'
#' @param x
#' @return
#'
#' @export
CF3 = function(x) {
	d = size(x)[2]
	func_num = 6
	lb = -5
	ub = 5
	o = c()
	if(initial_flag == 0) {
		initial_flag = 1
		#load data/optima.mat # saved the predifined optima
		if(length(o) >= d) {
			o = o[1:d]
		} else {
			o = c(o, lb + (ub - lb) * matrix(runif(func_num * d), func_num, d))
		}
		func = c("FEF8F2", "FEF8F2", "FWeierstrass", "FWeierstrass", "FGriewank", "FGriewank")
		bias = matrix(0, 1, func_num)
		sigma = c(1, 1, 2, 2, 2, 2)
		lambda = rbind(1/4, 1/10, 2, 1, 2, 5)
		lambda = repmat(lambda, 1, d)
		c = matrix(1, 1, 6)

		if(d == 2) {
			#load data/CF3_M_D2.mat
		} else if(d == 3) {
			#load data/CF3_M_D3.mat
		} else if(d == 5) {
			#load data/CF3_M_D5.mat
		} else if(d == 10) {
			#load data/CF3_M_D10.mat
		} else if(d == 20) {
			#load data/CF3_M_D20.mat
		} else {
			M = rot_matrix_condition(4, 1)
			for(i in 1:6) {
			# eval(['M.M' int2str(i) '= RotMatrixCondition( D,c(i) );']);
				print(rot_matrix_condition(4, c[i]))
			}
		}
	}
	return(hybrid_composition_func(x, func_num, func, o, sigma, lambda, bias, M))
}

#' @title Composition Function 4
#' @description n = 8
#'
#' @param x
#' @return
#'
#' @export
CF4 = function(x) {
	d = size(x)[2]
	func_num = 8
	lb = -5
	ub = 5
	o = c()
	if(initial_flag == 0) {
		initial_flag = 1
		#load data/optima.mat # saved the predifined optima
		if(length(o) >= d) {
			o = o[1:d]
		} else {
			o = c(o, lb + (ub - lb) * matrix(runif(func_num * d), func_num, d))
		}
		func = c("FRastrigin", "FRastrigin", "FEF8F2", "FEF8F2", "FWeierstrass", "FWeierstrass", "FGriewank", "FGriewank")
		bias = matrix(0, 1, func_num)
		sigma = c(1, 1, 1, 1, 1, 2, 2, 2)
		lambda = rbind(4, 1, 4, 1, 1/10, 1/5, 1/10, 1/40)
		lambda = repmat(lambda, 1, d)
		c = matrix(1, 1, func_num)

		if(d == 2) {
			#load data/CF4_M_D2.mat
		} else if(d == 3) {
			#load data/CF4_M_D3.mat
		} else if(d == 5) {
			#load data/CF4_M_D5.mat
		} else if(d == 10) {
			#load data/CF4_M_D10.mat
		} else if(d == 20) {
			#load data/CF4_M_D20.mat
		} else {
			for(i in 1:func_num) {
			# eval(['M.M' int2str(i) '= RotMatrixCondition( D,c(i) );']);
			}
		}
	}
	return(hybrid_composition_func(x, func_num, func, o, sigma, lambda, bias, M))
}

#' @title Hybrid Composition General Framework
#'
#' @param x
#' @param func_num
#' @param func
#' @param o
#' @param sigma
#' @param lambda
#' @param bias
#' @param M
#' @return
#'
#' @export
hybrid_composition_func = function(x, func_num, func, o, sigma, lambda, bias, M) {
	d = size(x)[2]
	ps = size(x)[1]
	weight = matrix(0, ps, func_num)

	for(i in 1:func_num) {
		oo = repmat(o[i, ], ps, 1)
		weight[, i] = exp(-sum((x - oo)^2)/2/(d * sigma[i]^2))
	}

	tmp = t(apply(weight, 1, sort))
	for(i in 1:ps) {
		weight[i, ] = (weight[i, ] == tmp[i, func_num]) * weight[i, ] + (weight[i, ] != tmp[i, func_num]) * (weight[i, ] * (1 - tmp[i, func_num]^10))
	}

	if(sum(weight) == 0) { # still need to check for more than 1 row
		weight = weight + 1
	}

	weight = weight / repmat(as.matrix(apply(weight, 1, sum)), 1, func_num)

	it = 0
	res = 0
	for(i in 1:func_num) {
		oo = repmat(o[i, ], ps, 1)
		print(((x - oo) / repmat(lambda[i, ], ps, 1)) %*% M)
		f = eval_functions(func[i], ((x - oo) / repmat(lambda[i, ], ps, 1)) %*% M)
		x1 = 5 * matrix(1, 1, d)
		f1 = eval_functions(func[i], (x1 / lambda[i, ]) %*% M)
		fit = 2000 * f / f1

		print("res")
		print(res)
		print("weight[, i]")
		print(weight[, i])
		print("fit")
		print(fit)
		print("bias[i]")
		print(bias[i])
		print("_____________")

		res = res + weight[, i] * (fit + bias[i])
	}
	return(-res)
}

# Basic functions

#' @title Sphere Function
#'
#' @param x
#' @return
#'
#' @export
FSphere = function(x) apply(x^2, 2, sum)

#' @title Griewank's Function
#'
#' @param x
#' @return
#'
#' @export
FGriewank = function(x) {
	d = size(x)[2]
	f = 1
	for(i in 1:d) {
		f = f * cos(x[, i]/sqrt(i))
	}
	print(f)
	return(apply(x^2, 1, sum)/4000 - f + 1)
}

#' @title Rastrigin's Function
#'
#' @param x
#' @return
#'
#' @export
FRastrigin = function(x) apply(x^2 - 10 * cos(2 * pi * x) + 10, 1, sum)

#' @title Weierstrass Function
#'
#' @param x
#' @return
#'
#' @export
FWeierstrass = function(x) {
	d = size(x)[2]
	x = x + 0.5
	a = 0.5
	b = 3
	kmax = 20
	c1 = a^(0:kmax)
	c2 = 2 * pi * b^(0:kmax)
	f = 0
	c = -w(as.matrix(0.5), c1, c2)
	for(i in 1:d) {
		f = f + w(t(x[, i]), c1, c2)
	}
	return(f + as.vector(c) * d)
}

w = function(x, c1, c2) {
	y = matrix(0, length(x), 1)
	for(k in 1:length(x)) {
		y[k] = sum(c1 * cos(c2 * x[, k]))
	}
	print(y)
	return(y)
}

#' @title FEF8F2 Function
#'
#' @param x
#' @return
#'
#' @export
FEF8F2 = function(x) {
	d = size(x)[2]
	f = 0
	for(i in 1:(d - 1)) {
		f = f + F8F2(x[, i:(i+1)] + 1)
	}
	return(f + F8F2(x[, d:1] + 1))
}

#' @title F8F2 Function
#'
#' @param x
#' @return
#'
#' @export
F8F2 = function(x) {
	f2 = 100 * (x[, 1]^2 - x[, 2])^2 + (1 - x[, 1])^2
	return(1 + f2^2/4000 - cos(f2))
}

#' @title Classical Gram Schmidt Function
#'
#' @param A
#' @return
#'
#' @export
local_gram_schmidt = function(A) {
	tmp = qr(A)
	q = qr.Q(tmp)
	r = qr.R(tmp)
	return(q)
}

#' @title Rotation Matrix
#' @description Generates a D-dimensional rotation matrix with predifined Condition Number (c)
#'
#' @param D
#' @param c
#' @return
#'
#' @export
rot_matrix_condition = function(D, c) {
	# A random normal matrix
	A = matrix(rnorm(D^2, 0, 1), D, D);

	# P Orthogonal matrix
	P = local_gram_schmidt(A)

	# A random normal matrix
	A = matrix(rnorm(D^2, 0, 1), D, D);

	# Q Orthogonal matrix
	Q = local_gram_schmidt(A)

	# Make a diagonal matrix D with prespecified condition number
	u = runif(D)
	D = c^((u - min(u))/(max(u) - min(u)))
	D = diag(D)

	# M rotation matrix with condition number c
	M = P %*% D %*% Q
	return(M)
}












