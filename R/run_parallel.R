library(parallelMap)
parallelStartSocket(cpus = detectCores())
parallelSource("R/benchmark.R")
f = function(i){
  benchmark(i, as.numeric(Sys.time()))
}

parallelMap(f, 1:20L)
print(f)
parallelStop()
#for(index in 20){
  # run each 50 times.
  #for(run in 1:50){