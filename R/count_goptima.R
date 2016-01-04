#' @title count_goptima
#' @description Evaluates the data given with a niching function and iterates it comparing the data with the rho parameter, determining if an optima has been found or not.
#'
#' @param pop Data given to be evaluated.
#' @param nfunc Number of the niching function to be used.
#' @param accuracy Accuracy value for the optima selection criteria.
#' @return A list containing the number of optimas found and the value of it. (count, finalseeds)
#'
#' @export
count_goptima = function(pop, nfunc, accuracy) {
	np = size(pop)[1]

	# parameters for the competition
	rho = c(0.01 * matrix(1, 1, 4), 0.5, 0.5, 0.2, 0.5, 0.2, 0.01 * matrix(1, 1, 11))
	fgoptima = c(200.0, 1.0, 1.0, 200.0, 1.03163, 186.731, 1.0, 2709.0935, 1.0, -2.0, matrix(0, 1, 10))
	nopt = c(2, 5, 1, 4, 2, 18, 36, 81, 216, 12, 6, 8, 6, 6, 8, 6, 8, 6, 6, 8)

	# evaluate pop
	fpop = c()
	for(i in 1:np) {
		fpop[i] = niching_func(pop[i, ], nfunc)
	}

	fpoptmp = fpop

	# descent sorting
	index = sort(fpoptmp, decreasing = TRUE, index.return = TRUE)$ix

	# sort population based on its fitness values
	# do not change the current population. Work on cpop/cpopfits
	cpop = as.matrix(pop[index, ])
	cpopfits = fpop[index]

	# get seeds
	seeds = c()
	seedsidx = c()

	for(i in 1:np) {
		found = 0
		snp = size(seeds)[2]
		if(!is.na(snp)) {
			for(j in 1:snp) {
				# calculate distance from seeds
				dist = sqrt(sum((seeds[j] - cpop[i, ])^2))
				# if the Euclidean distance is less than the radius
				if(dist <= rho[nfunc]) {
					found = 1
					break
				}
			}
		}
		# if it is not similar to any other seed, then it is a new seed
		if(found == 0) {
			seeds = c(seeds, cpop[i, ])
			seedsidx = c(seedsidx, i)
		}
	}

	# based on the accuracy: check which seeds are global optimizers
	seedsfit = cpopfits[seedsidx]
	idx = which(abs(seedsfit - fgoptima[nfunc]) <= accuracy, arr.ind = TRUE)
	if(length(idx) > nopt[nfunc]) {
		idx = idx[1:nopt[nfunc]]
	}

	count = length(idx)
	finalseeds = seeds[idx]
	
	return(list("count" = count, "finalseeds" = finalseeds))
}
