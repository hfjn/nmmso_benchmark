library(BatchJobs)

unlink("batch-files", recursive = TRUE)

reg = makeRegistry("batch")

f = function(x, y){
  benchmark(x, as.numeric(Sys.time()))
}

batchMap(reg, f, x = 1:10, y= 1:20)

submitJobs(reg, ids = getJobIds(reg), resources = list(ppn = 1, walltime = 20000, nodes = 1))
	