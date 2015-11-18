#' @title get_lb
#'
#' @param fno
#' @return
#' 
#' @export
get_lb = function(fno) {
	if(fno == 1 || fno == 2 || fno == 3) {
		lb = 0
	} else if(fno == 4) {
		lb = -6 * matrix(1, 1, 2)
	} else if(fno == 5) {
		lb = c(-1.9, -1.1)
	} else if(fno == 6 || fno == 8) {
		lb = -10 * matrix(1, 1, 2)
	} else if(fno == 7 || fno == 9) {
		lb = 0.25 * matrix(1, 1, 2)
	} else if(fno == 10) {
		lb = matrix(0, 1, 2)
	} else if(fno == 11 || fno == 12 || fno == 13) {
		dim = 2
		lb = -5 * matrix(1, 1, dim)
	} else if(fno == 14 || fno == 15) {
		dim = 3
		lb = -5 * matrix(1, 1, dim)
	} else if(fno == 16 || fno == 17) {
		dim = 5
		lb = -5 * matrix(1, 1, dim)
	} else if(fno == 18 || fno == 19) {
		dim = 10
		lb = -5 * matrix(1, 1, dim)
	} else if(fno == 20) {
		dim = 20
		lb = -5 * matrix(1, 1, dim)
	} else {
		lb = NULL
	}
	return(lb)
}