#' @title get_ub
#'
#' @param fno
#' @return
#' 
#' @export
get_ub = function(fno) {
	if(fno == 1) {
		ub = 30
	} else if(fno == 2 || fno == 3) {
		ub = 1
	} else if(fno == 4) {
		ub = 6 * matrix(1, 1, 2)
	} else if(fno == 5) {
		ub = c(1.9, 1.1)
	} else if(fno == 6 || fno == 8) {
		ub = 10 * matrix(1, 1, 2)
	} else if(fno == 7 || fno == 9) {
		ub = 10 * matrix(1, 1, 2)
	} else if(fno == 10) {
		ub = matrix(1, 1, 2)
	} else if(fno == 11 || fno == 12 || fno == 13) {
		dim = 2
		ub = 5 * matrix(1, 1, dim)
	} else if(fno == 14 || fno == 15) {
		dim = 3
		ub = 5 * matrix(1, 1, dim)
	} else if(fno == 16 || fno == 17) {
		dim = 5
		ub = 5 * matrix(1, 1, dim)
	} else if(fno == 18 || fno == 19) {
		dim = 10
		ub = 5 * matrix(1, 1, dim)
	} else if(fno == 20) {
		dim = 20
		ub = 5 * matrix(1, 1, dim)
	} else {
		ub = NULL
	}
	return(ub)
}