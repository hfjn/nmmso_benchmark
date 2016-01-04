# nmmso_benchmark
This project contains a reimplementation of the [CEC Benchmarking Suite](http://goanna.cs.rmit.edu.au/~xiaodong/cec13-niching/competition/). This project was created to test and benchmark the [nmmso.R package](http://github.com/jhoffjann/nmmso.R) during a Seminar Project at the Westfälische Wilhelms-Universität Münster.

This project is in no way associated to the authors of the original implementation.

## Installation
Since this is a project containing many single scripts you should probably consider cloning it to your local machine. Also keep in mind to install the [nmmso.R package](http://github.com/jhoffjann/nmmso.R) to use this.

## Usage
If you wanna see example usages of the benchmarking framework works you should probably checkout the [benchmark.R](https://github.com/jhoffjann/nmmso_benchmark/blob/master/R/benchmark.R) which we used to run this with nmmso.R.

If you are willing to run this on a High Computing Cluster (which is advised if you wanna get serious), you should have a look at [run_parallel.R](https://github.com/jhoffjann/nmmso_benchmark/blob/master/R/run_parallel.R).

For usage with other algorithms you probably want to check the [demo_suite.R](https://github.com/jhoffjann/nmmso_benchmark/blob/master/R/demo_suite.R) which is an adaptation of example code used in the original benchmarking tool. Keep in mind to remove the comments though.

If you are interested in create some nice graphs and tables aswell as result files after your runs you could have a look at [graph_results.R](https://github.com/jhoffjann/nmmso_benchmark/blob/master/R/graph_results.R). It contains the code we used for our technical documentation.

## Technical Documentation
This Repository also contains the Technical Documentation of our seminar project. You can find it in the folder documentation. It was written with scrivener and compiled with knitr and pandoc. 


