#' @title get_rho
#'
#' @param nfunc
#' @return
#' 
#' @export
get_rho = function(nfunc) {
	rho = c(0.01 * matrix(1, 1, 4), 0.5, 0.2, 0.5, 0.2, 0.01 * matrix(1, 1, 11))
	rho = rho[nfunc]
	return(rho)
}