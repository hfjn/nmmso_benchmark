#' @title get_rho
#'
#' @param nfunc Number of the niching function to be used.
#' @return The rho value for the function needed.
#' 
#' @export
get_rho = function(nfunc) {
	rho = c(0.01 * matrix(1, 1, 4), 0.5, 0.2, 0.5, 0.2, 0.01 * matrix(1, 1, 11))
	rho = rho[nfunc]
	return(rho)
}