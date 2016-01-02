# library(BatchJobs)

# unlink("batch-files", src.files=c("../R/benchmark.R"), recursive = TRUE)

# reg = makeRegistry("batch")

# f = function(x, y){
#   	benchmark(x, as.numeric(Sys.time()))
# }

# for(i in 1:5){
# 	batchMap(reg, f, x = 1:10)
# }


# submitJobs(reg, ids = getJobIds(reg), resources = list(ppn = 1, walltime = 20000, nodes = 1))
# 	