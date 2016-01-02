test_that("Number of optima is the correct one", {
	for(i in 1:20){
		expect_true(nopt[i] == get_no_goptima(i))
	}
})