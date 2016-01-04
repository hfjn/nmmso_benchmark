#' @title get_fgoptima
#'
#' @param nfunc Number of the niching function to be used.
#' @return The global optimal value for the function needed.
#'
#' @export
get_fgoptima = function(nfunc) {
	fgoptima = c(200.0, 1.0, 1.0, 200.0, 1.03163, 186.731, 1.0, 2709.0935, 1.0, -2.0, matrix(0, 1, 10))
	return(fgoptima[nfunc])
}
