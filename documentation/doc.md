# Introduction #

In the recent years, R has become the statistical programming language of choice for many scientists. The strength of R, being a domain specific language, has also become one of its weaknesses. Since new research findings in statistical computing are split up over several languages like R, Matlab or SciPy[^1], it often becomes difficult to compare new methods with established ones. Because it is also hard to interface those languages due to different architectures and data storage mechanisms there is often no other way than to reimplement new methods in a different programming language to create a common scope.

An example for a well perceived new finding in statistical computing is the NMMSO-Algorithm by Jonathan E. Fieldsend [@fieldsend_2014]. It won the niching competition in 2015 held by the CEC and is only written in Matlab. Since the chair 'Information Systems and Statistics' at the Westfälische Wilhelms-Universität Münster, Germany, is mainly concentrating its work on Statistical Computing in R, an implementation of this algorithm became interesting. 

As part of this Seminar Project in the context of the Seminar 'Statistical Computing in R', a reimplementation of the NMMSO algorithm in R (nmmso.R) will be presented. During this technical documentation, the general function of the algorithm and the used test cases by the CEC will be shown. Afterwards the structure and used techniques and libraries, as well as problems and pitfalls due to the different behaviors of R and Matlab, will be shown. The documentation will be closed by the benchmarking results and several test cases. 

It was the goal of this project to keep up high comparability with the original code, to ensure the correct functionality and easily implement changes to the original codebase in this program. To reach this, unit tests were used where possible and continuous comparison between interim results of the original implementation and nmmso.R where used to ensure functioning. Additionally a benchmarking suite, which builds on the CEC Benchmarking Suite for Niching Algorithm [@epitropakis_2013] was implemented to evaluate and test the functioning of nmmso.R with the same characteristics as in the original implementation.

[^1]: SciPy is a common library for the Python Programming language which brings Statistical Computing capabilities to the language.
\newpage

# General Function #

The starting point of the project was the paper provided by Dr. Jonathan E. Fieldsend [@fieldsend_2014] on the Niching Migratory Multi-Swarm Optimiser (NMMSO) algorithm. NMMSO is a multi-modal optimiser which relies heavily on multiple swarms that are generated on the landscape of a function in order to find the global optima. It is build around three main pillars: 
(1) dynamic in the numbers of dimensions, 
(2) self-adaptive without any special preparation and 
(3) exploitative local search to quickly find peak estimates [@fieldsend_2014, p. 1]. 

Multi-modal optimisation in general, does not differ very much from well known and widely discussed single-objective optimisation, but but unlike it, the goal of the algorithms in the multi-modal perspective is not to find just one single optimising point but all possible points [@fieldsend_2014, p. 1].  In order to do so, many early multi-modal optimisation algorithms needed defined parameters [@fieldsend_2014, p.1].

Newer algorithms fall in the field of self-tuning and try to use different mathematical paradigms like nearest-best clustering with covariance matrices [@preuss_2012] and strategies like storing the so far best found global optima estimators to provide them as parameters for new optimisation runs [@epitropakis_2013]. Contradictory to that NMMSO goes the way of many early algorithms and uses the swarm strategy in order to find which store their current [@fieldsend_2014]. 

In order to do so, NMMSO follow a strict structure, which can be seen in the following pseudo-code

	nmmso (max_evals, tol, n, max_inc, c_1, c_2, omega)
		S: initialise_swarm(1)
		evaluations := 1
		while evaluations < max_evals:
			while flagged_swarms(S) == true:
				{S, m} := attempt_merge(S, n, tol)
				evals := evals + m
			S := increment(S, n, max_inc, c_1, c_2, omega)
			evals := evals + min(|S|, max_inc)
			{S, k} := attempt_separation(S, tol)
			evals := evals + k
			S := add_new_swarm(S)
			evals := evals + 1
		{X*, Y*} := extract_gbest(S)
		return X*,Y*

This structure wasn't modified during the reimplementation of  NMMSO to keep comparability and the possibility to fix bugs at a high level. The only newly introduced setting was the possibility to modify c_1, c_2 and omega as parameters from the outside. In the original version those parameters are part of the program code. All other variables have been set to the variables seen in the following table. While variables like maximal amount of evaluations are dependent on the used test function and have been explicitly stated in the test function by the CEC (Section 3.1) other values have been chosen by Dr. Fieldsend and were used for the reimplementation [@fieldsend_2014, p. 2-3]. Those values can be found in the following table:

           		used value 	
-----------	 	--------------
evaluations		0			
max_inc			100			
tol				10^-6		
c_1				2.0         
c_2				2.0	        
omega			0.1       	
---------  		--------------   
Table: Values used for all program evaluations.   



----

# CEC Algorithms #

## CEC ##

The IEEE Congress of Evolutionary Computation (CEC) is one of the largest, most important and recognized conferences within Evolutionary Computation (EC). It is organised by the IEEE Computational Intelligence Society in cooperation with the Evolutionary Programming Society and covers most of the subtopics of the EC [^2].

In order to validate the potential of the NMMSO algorithm, it was submitted to the IEEE CEC 2015 held in Sendai, Japan. Here, Dr. Fieldsend was provided with some multimodal benchmark test functions with different dimension sizes and characteristics, for evaluating niching algorithms developed by Dr. Xiaodong Li, Dr. Andries Engelbrecht and Dr. Michael G. Epitropakis [@li_2013]. They state that even if several niching methods have been around for many years, further advances in this area have been hindered by several obstacles; most of the studies focus on very low dimensional multi-modal problems (2 or 3 dimensions) making this more complicated to assess theses methods’ scalability to high dimensions with better performance. The benchmark tool includes 20 test functions (in some cases the same function but with different dimension sizes), which includes 10 simple, well-known and widely used benchmark functions, based on recent studies, and more complex functions following the paradigm of composition functions. In the following section, they will be briefly explained:

	•	F1: Five-Uneven-Peak Trap (1D)
	•	F2: Equal Maxima (1D)
	•	F3: Uneven Decreasing Maxima (1D)
	•	F4: Himmelblau (2D)
	•	F5: Six-Hump Camel Back (2D)
	•	F6: Shubert (2D, 3D)
	•	F7: Vincent (2D, 3D)
	•	F8: Modified Rastrigin - All Global Optima (2D)
	•	F9: Composition Function 1 (2D)
	•	F10: Composition Function 2 (2D)
	•	F11: Composition Function 3 (2D, 3D, 5D, 10D)
	•	F12: Composition Function 4 (3D, 5D, 10D, 20D)

All of the test functions are formulated as maximisation problems. F1, F2 and F3 are simple 1D multimodal functions, while F4 and F5 are simple 2D functions and not scalable. F6 to F8 are scalable multimodal functions. The number of global optima for F6 and F7 are determined by the dimension. However, for F8, the number of global optima is independent of the dimension, therefore it can be controlled by the user. F9 to F12 are scalable multimodal functions constructed by several basic functions with different properties (Sphere function, Grienwank, Rastrigin, Weierstrass and the Expanded Griewank’s plus Rosenbrock’s function). F9 and F10 are separable, and non-symmetric while F11 and F12 are non-separable, non-symmetric complex multimodal functions. The number of global optima in all of the composition functions is independent of the number of dimensions, therefore, can be controlled by the user [@li_2013].

The properties of each function can be seen in the following table:

Function 					Variables Range 						#GO						#LO
--------					---------------							--------------------	-------------------
Five-Uneven-Peak Trap		$x \in [0, 30]$ 						2						3
Equal Maxima				$x \in [0, 1]$ 							5						0
Uneven Decreasing Maxima 	$x \in [0, 1]$ 							1						4
Himmelblau					$x,y \in [6,6]$ 						4						0
Six-Hump Camel Back			$x \in [1.9, 1.9]$ 						2						2
							$y \in [1.1, 1.1]$ 
Shubert						$x_i \in [10,10]^D,i=1,2,...,D$			$D * 3D$ 				many
Vincent						$x_i \in [0.25,10]^D, i = 1,2,...,D$ 	$6^D$ 					0
Modified Rastrigin			$x_i \in [0,1]D, i = 1,2,...,D$ 		$\Pi^Di=1^{ki}$			0
--------					---------------							--------------------	-------------------
Table: Properties of the test functions used. (#GO = Number of Global Optima, #LO = Number of Local Optima)

For simplifying purposes, the composition functions were not taken in consideration because of its complexity, for further and deeper understanding of all functions, please refer to the CEC’2013 Niching Benchmark Tech Report  [@li_2013].

Besides the 12 different functions, also, a $count\_goptima$ function was included in order to find the optimal value for each evaluated function in each iteration. Here, some optimal values are already given as well as the number of each value to find. Together with an accuracy rate, the evaluation starts in a cycle and stores the possible optimal values in order to be compared with the expected values using the accuracy rates of 0.1, 0.01, 0.001, 0.0001 and 0.00001 for each different iteration [@li_2013, p.7]. 

The structure of the $count\_goptima$ function can be seen as a pseudocode:

	input : 			
	Lsorted #a list of individuals (candidate solutions) 
			#sorted in decreasing fitness values;	    
	acc 	#accuracy level; 
	r 		#niche radius;		    
	ph 		#the fitness of global optima (or peak height) 
	output: 
	S  		#a list of best-fit individuals identified as solutions 
	
	begin 
		S = empty;		
		while not reaching the end of Lsorted do 
			Get best unprocessed p partOf Lsorted;
			found = FALSE;			
			if d(ph, f it(p)) <= acc) then 
				for all s partOf S do					
					if d(s, p)  r then 
						found = TRUE; 
						break; 
					end 
				end 
				if not found then 
					let S = S + {p}; 
				end 
			end 
		end 
	end 

Once the optimal values are found and after comparing them with the same results of the Matlab implementation, it can be concluded that the new implementation works as expected and is ready for submission.

[^2]: https://en.wikipedia.org/wiki/IEEE_Congress_on_Evolutionary_Computation

## Implementation and Pitfalls ##

During the development, an issue raised with the CEC benchmark tool. In order to compare the R implementation of the NMMSO algorithm with the original one, it was mandatory to use this tool to test each of its functions with the new algorithm and compare results. After several complications with the original test suite (these complications will be addressed in the pitfalls’ section), it was decided to recode each of the functions as an independent R package to avoid any further complication and having an easier and more trustworthy comparison of the NMMSO algorithm in R.

The original tool included several files in order to build the main file calling each one and be able to run as needed, including a graphing function for presentation purposes. While re-writing the tool in R, it followed the same structure but just focusing in the main files like the functions and count_goptima files because most of the other files were used in the graphing function and in this case, the original file was not used but still was created in a way to present the output in a graphic way for this paper. In comparison with the NMMSO algorithm, this tool was faster to work with but still generated several issues during the process.

Finally, the whole benchmark tool uses a demo_suite file in order to run it and display the optimal values found using each of the twenty functions with dummy data. This file is considered as one of the most important files within the tool because it helped to understand how the original version used to work. Most of the tests were run with this function and comparing both versions several times until the output given was exactly the same and also focusing in the execution time so it could have a better performance and could be used as a new option in future cases for the CEC. The output of each function can be seen in the following R output:

**Results in R**	
	
	f_ 1  : f(1...1) =  120 
	f_ 2  : f(1...1) =  5.270904e-92 
	f_ 3  : f(1...1) =  0.02501472 
	f_ 4  : f(1...1) =  94 
	f_ 5  : f(1...1) =  -3.233333 
	f_ 6  : f(1...1) =  -3.180351 
	f_ 7  : f(1...1) =  0 
	f_ 8  : f(1...1) =  5.671692 
	f_ 9  : f(1...1) =  0 
	f_ 10  : f(1...1) =  -38 
	f_ 11  : f(1...1) =  -268.6638 
	f_ 12  : f(1...1) =  -758.9333 
	f_ 13  : f(1...1) =  -613.5412 
	f_ 14  : f(1...1) =  -1838.556 
	f_ 15  : f(1...1) =  -1049.86 
	f_ 16  : f(1...1) =  -2149.558 
	f_ 17  : f(1...1) =  -1238.211 
	f_ 18  : f(1...1) =  -1683.184 
	f_ 19  : f(1...1) =  -1342.819 
	f_ 20  : f(1...1) =  -1337.852 


When the decision of re-writing the whole benchmark tool in the R programming language was made, some issues came up regarding the way Matlab handles the matrices and vectors. After analysing the Matlab implementation, it was easier to solve the issues because it was done after the NMMSO implementation and some of these issues were repeated between both implementations. Even if the matrix and vectors caused some problems during the implementation, it was not necessary to use the add_row and add_col functions because it always uses a matrix of one row so it was decided to change the structure so the R implementation would only use vectors to facilitate and simplify its usage. 

After some testing, some issues raised regarding the performance of the tool. As explained in the section before, the tool contains 12 different functions in order to evaluate the algorithm’s data and together with the count_goptima function, get the optimal values for the different parameters given to the NMMSO algorithm. The main problem here was with the last 4 functions (composition functions), some data of an output file was mandatory read and given as a parameter for a further evaluation, making necessary the use of an additional R library in order to read this Matlab’s data files and use them as expected. This solution worked perfectly regarding the output values but increased the processing time because each file had to be read in each iteration so it was decided to create different global variables that read only once each Matlab’s data file and only be called during the iteration process. This worked as expected and reduced the time and processor consumption of the tool, displaying the same results as the Matlab implementation created by the CEC.

----

# The Implementation #

## Structure of the project ##

In difference to the original implementation, it was chosen to split up all single functions of the nmmso algorithm into single files. These were bundled into the standard R package structure to give the possibility to make it available over CRAN[^3] in the future. To give the possibility to collaborate, the project was managed and versioned via Github. The package was tested with testthat[^4] and documented with roxygen2[^5]. To assure functioning the package was continuously tested with Travis CI.

After analysing the algorithm provided in Matlab by Dr. Fieldsend, it was decided to first translate each of the functions into the R programming language. At first instance, this task seemed to be simple because most of the functions were basically managing matrices and vectors, but later this became a problem that will be covered in the pitfalls’ section (4.2) of this paper.

Once all the NMMSO functions existed in R and having the input data, the testing phase started. It has been said, that one of the biggest problems when coding an already existing program into another programming language, is the different behaviours corresponding to each object (in case of an object-oriented language) or its main structure. The first runs came with several errors regarding the matrix generation and handling, slowing down the project in a near future. Using GitHub, it was easier to attack these problems in parallel, having one developer reviewing different functions and the other one, fixing other bugs and continue the testing phase. Also, this was achieved in an easier way, thanks to that each function was coded in an independent R file, making easier and faster the debugging and the fixing of each problem.

Having the algorithm running hand by hand with the CEC benchmark tool, also developed in R during the project, and in order to get the output needed to compare the new implementation with the old one written in Matlab, it was necessary to use the Palma Cluster. This gave a radical change to the project because it was never taken in consideration to use a bigger computational power. It was necessary to implement some batch jobs in order to run the algorithm within the cluster and then specify a way to print and store all the output data later to be analysed and compared. Even if this step was never considered part of the project, it came across in a helpful way because it helped to discover that the NMMSO.R implementation is working properly and in a way that it could be used for further research and investigations.

[^3]: Comprehensive R Archive Network. 
[^4]: https://cran.r-project.org/web/packages/testthat/index.html
[^5]: https://cran.r-project.org/web/packages/roxygen2/index.html


## Pitfalls and Problems ##

In the beginning of the project, after translating each function into the R programming language and in order to start testing each one of them, some data was missing. The algorithm runs with some parameters that had to be given by the CEC so it was necessary to contact the organisation and ask for the files including the benchmarking tool. Also, Dr. Fieldsend was contacted in order to have a better understanding of the general structure of his algorithm. Once the data was completed, the test phase started, trying to get the same results as the original one, but this was not possible at first instance because the output was not generalised and most of the data generated inside the algorithm were random values to be evaluated.

During the implementation of the NMMSO.R algorithm, some problems regarding the language structure came up immediately. After some first test cases, it was discovered how different Matlab and R work with matrices and vectors. In the case of Matlab, every time a value wanted to be added for an inexistent index, this was created automatically and added to the data structure, where no row was existing before, instead of throwing the common “index out of bounds” error. First, it was necessary to compare all these possible behaviors in Matlab so a general way to attack them could be implemented and after few tries, two function-files were created. “add_col.R”, as its name says, is in charge to add a new column into a structure, it is just necessary to specify the original structure where it will be added to, the index and the new object containing the information to add. This function considers the cases if the new object is a vector, a matrix or just a single value, so the original matrix could be modified and returned as desired. “add_row.R”, on the other hand, simply imitates the behavior of “add_col.R” but as a transpose matrix in order to add the rows.

Once the data was completed in order to run the algorithm and get at least a similar output as the original version, the CEC benchmarking tool was intended to be used for testing. Thanks to the CEC organisation, these tools were provided in C++, Java and Matlab to check which one could be the best implementation for this case. After some trials with the C++ version, some issues regarding its implementation and missing documentation lead the development team to re-write the complete benchmarking tool in the R programming language, in order to avoid mixing code and be sure to get the results expected since the beginning of this project. Also, it was thought in a way to supply the research community with a new implementation of this tool for future projects.

After solving the previous issues and starting to run the whole algorithm, a memory problem came up. Mainly because of the continuous problem between R and Matlab, this was caused, because one matrix, originally containing only integer values, was added a float value in a certain point within the process. R automatically cloned the integer matrix, creating it with a float type in order to continue without errors for every iteration. In the end having an unnecessary number of matrices allocated in memory, making impossible the computation of the algorithm with a size of 7.9 GB during the iteration 700 out of 50,000 (depending on the function to be evaluated in CEC benchmark suite, the total number of iterations would vary). Even if this issue was solved only by changing the original matrix to contain float values since the beginning, it caused several problems and time consumption during the testing phase.

Finally, after completing and fixing the R implementation, and  trying to test it with the real number of iterations for each of the twenty CEC benchmarking functions, a bigger computation power was needed. Having only students’ computers for development, it was necessary a bigger source of computation power and with the help of the R library “BatchJobs” together with the Palma Cluster, property of the Westfälische Wilhelms-Universität located in Münster, Germany, it was possible to run the algorithm in different batch jobs within the cluster and just printing output files in order to analyse the data in the end.

# Benchmark and Comparison #


To compare nmmso.R with the original NMMSO the CEC test cases were used to run the same benchmarks as in the original submission [@fieldsend_2014]. There 4 different Ratios were used to measure the performance of certain algorithms. Three of those measures (Peak Ratio, Success Ratio and Convergence Speed) have been introduced in [@li_2013, pp. 6-7] to create a common point of comparison. The fourth ratio is special for the nmmso algorithm since it tracks the number of swarms over the iterations of the algorithm. Nmmso.R uses the same measures to reach the highest comparability possible. All of the following measures were taken over several runs and contain all results which could be received until the deadline of this paper. The number of runs in total for each function is stated in the first three tables and matches in the graph.

The first measure used is the Success Ratio (SR). The Success Ratio is defined as the percentage of successful runs (runs that found all global optima) over all runs [@li_2013, p. 7]. As for the other ratios this measure was taken over several independent runs and collectively evaluated. The taken measures for the Success Ratio can be found in Table 3. 
$$\frac{successful\ runs}{NR} = SR $$ 
Here $NR$ denotes the Number of runs done to reach this measure.
\newline

--------------------------------------------------------
 &nbsp;     0.1   0.01   0.001   0.0001   0.00001   runs
--------- ----- ------ ------- -------- --------- ------
 **F1**       1      1       1        1         1     48

 **F2**       1      1       1        1         1     45

 **F3**       1      1       1        1         1     47

 **F4**       1      1       1        1         1     47

 **F5**       1      1       1        1         1     44

 **F6**       1      1       1        1         0     43

 **F7**       1      1       1        1         1     44

 **F8**       1      1       1     0.81      0.63     27

 **F9**    0.97   0.97    0.97     0.94      0.94     31

 **F10**      1      1       1        1         1     44

 **F11**      1      1       1        1         1     43

 **F12**      1      1       1        1         1     44

 **F13**      1      1       1        1         1     44

 **F14**      1      1       1        1         1     43

 **F15**   0.97   0.97    0.97     0.97      0.97     35

 **F16**      0      0       0        0         0     23

 **F17**   0.22   0.09    0.09     0.09      0.09     23

 **F18**   0.33   0.33     0.3     0.26      0.26     27

 **F19**      0      0       0        0         0     23

 **F20**      0      0       0        0         0     23
--------------------------------------------------------

Table: Success Ratio over given runs (Measure of share of runs which found all global optima)

The second measure introduced by the CEC committee and also used by Dr. Fieldsend is the Convergence Rate. The Convergence Rate (CR) measures the needed evaluations per Accuracy and Function to find all global optima [@li_2013, p.7]. This measure takes the mean of evaluations over all runs. The results of this measure can be found in Table 4.

$$\frac{\sum\nolimits_{n=1}^{NR} evals_{n}}{NR} = CR$$ 
In this measure, $evals$ denotes the number of evaluations done. 
\newline

---------------------------------------------------------
 &nbsp;      0.1   0.01   0.001   0.0001   0.00001   runs
--------- ------ ------ ------- -------- --------- ------
 **F1**      619    817    1009     1200      1433     48

 **F2**      180    265     389      551       661     45

 **F3**       33    173     272      385       505     47

 **F4**      508    728     951     1196      1454     47

 **F5**       78    189     322      517       751     44

 **F6**    19195  24080   30049    41876    200001     43

 **F7**     8393   8987   10359    11956     14181     44

 **F8**   199648 237118  282068   327787    358610     27

 **F9**   186608 193491  211905   226095    235502     31

 **F10**     879   1302    1718     2256      2758     44

 **F11**    3749   5599    7151     8258      9110     43

 **F12**   16961  25035   35955    43212     49331     44

 **F13**   10310  14708   17942    22116     26602     44

 **F14**   27111  35790   47728    57964     65885     43

 **F15**  108351 125661  142817   164637    182483     35

 **F16**  400001 400001  400001   400001    400001     23

 **F17**  351987 373890  377104   378189    378904     23

 **F18**  314198 317298  326086   330563    332025     27

 **F19**  400001 400001  400001   400001    400001     23

 **F20**  400001 400001  400001   400001    400001     23
---------------------------------------------------------

Table: Convergence Rates over given runs (Mean of evaluations needed to find all global optima, if all optima have never been found the maximum allowed evaluations for that function were taken.)

The third measure is the Peak Ratio (PR). It measures the share of found global optima over all runs [@li_2013, p.7]. The results of this evaluation can be found in Table 5.

$$\frac{\sum\nolimits_{n=1}^{NR} NOF_{n}}{NKO * NR} = PR$$
\newline
In this measure $NOF$ denotes the number of found optima per run and $NKO$ the number of known optima for the function. 
\newline

--------------------------------------------------------
 &nbsp;     0.1   0.01   0.001   0.0001   0.00001   runs
--------- ----- ------ ------- -------- --------- ------
 **F1**       1      1       1        1         1     48

 **F2**       1      1       1        1         1     45

 **F3**       1      1       1        1         1     47

 **F4**       1      1       1        1         1     47

 **F5**       1      1       1        1         1     44

 **F6**       1      1       1        1         0     43

 **F7**       1      1       1        1         1     44

 **F8**       1      1       1     0.99      0.98     27

 **F9**       1      1       1        1         1     31

 **F10**      1      1       1        1         1     44

 **F11**      1      1       1        1         1     43

 **F12**      1      1       1        1         1     44

 **F13**      1      1       1        1         1     44

 **F14**      1      1       1        1         1     43

 **F15**      1      1       1        1         1     35

 **F16**   0.01      0       0        0         0     23

 **F17**   0.79   0.76    0.73     0.72       0.7     23

 **F18**   0.83   0.83    0.82     0.79      0.78     27

 **F19**   0.38   0.36    0.35     0.33      0.32     23

 **F20**   0.16   0.14    0.13     0.12      0.11     23
--------------------------------------------------------

Table: Peak Ratio over given runs (Share of found global optima over all runs)

As a fourth measure, which wasn't introduced by the CEC committee, but used in the original nmmso implementation [@fieldsend_2014], the Number of Swarms was chosen. Since this is a continuous measure and, therefore no calculation is needed, this measure is pictured as graphs. The graphs can be found in Figure 1. They show the development of $number$ $of$ $swarms$ kept by nmmso.R over all iterations. Important to notice here is that $iterations$ is different from the $evaluations$ referenced in the other measures. Iterations are calls to start single runs of nmmso.R and, therefore, are different from the evaluations taken within the program.


![plot of chunk trend curve of kept swarms over all 20 functions. The red curves show the number of swarms kept for each single run. The black line shows the mean of kept swarms over these runs. These plots contain all runs pictured in the other tables which were done for the benchmarking of this paper.](figure/trend curve of kept swarms over all 20 functions. The red curves show the number of swarms kept for each single run. The black line shows the mean of kept swarms over these runs.-1.pdf) 




When comparing those measures with the ones given in the original paper [@fieldsend_2014], it can be seen that the reimplementation nmmso.R is an overall good resemblance of the original algorithm. The three CEC measures are close to the original taken measures and the trend curves for the number of kept swarms have similar trends. 

The biggest differences between the benchmarking results of the two implementations can be seen in the general results of function 14, 15, 16 and 18, as well as in the number of created swarms for the n-dimensional functions: 

(1) Function 14 and 15 have a $Success\ Ratio$ of $1$ aswell as $Peak$ $Ratio$ of one $1$ for all accuracy levels. Additionally nmmso.R sometimes found all global optima for Function 18.  In contradiction of all three function almost never result in the finding of global optima in the evaluation of the original implementation. Only at the lowest accuracy, the original implementation is able to find all global optima for Function 14 [@fieldsend_2014, p.16].  It is hard to say if this difference is equal to an error in the implementation of nmmso.R or if an error in the original implementation was fixed. Also, this could be a difference in the reimplementation of the CEC Benchmarking Tool. Nevertheless, this is an interesting point of discussion and worth evaluating.

(2) nmmso.R performs noticeable worse for Function 16 than for the original function. While nmmso.R has a $Peak$ $Ratio$ of $0.01$ for an accuracy of $0.1$ and $0$ for all others, the original implementation reaches a $Peak$ $Ratio$ of around $0.6$ for all accuracies. This might be an implementation error in the CEC Benchmarking Tool and not in nmmso.R since it is so significantly worse that it is unlikely that this difference would only occur in one test function.

(3) Almost all algorithm runs on high-dimensional functions (F12-F20) result in a high number of swarms while all other results regarding this functions are comparable to the original results. This difference becomes very clear in the case of Functions 17-20. In the paper addressing the original implementation the x-axis rank from 0-40,000 iterations while for the reimplementation limit of 4,000 for Function 17, of 20,000 for Function 18, 7,500 for Function 19 and of 30,000 for Function 20 is enough to show all data sets. This is connected to the creation of much more swarms, which leads to an earlier depletion of the maximum allowed number of evaluations.

Additionally, a fifth measure was introduced which denotes the runtime of nmmso.R for the single functions. These times were taken on the ZIVHPC, a scientific High Perfomance Computing Cluster by Westfälische Wilhelms-Universität Münster. Since the nmmso.R is a strictly sequential algorithm the runtimes for single runs will be comparable on common computers. The ZIVHPC was only used to parallelise the single runs. Even though this measure widely varies depending on the computer's architecture it can show the different complexity of all 20 functions. This measure was taken separately on 10 runs of each function.


-------------------------------------
 &nbsp;     Mean   Standard Deviation
--------- ------ --------------------
 **F1**       13                  3.3

 **F2**      7.2                  5.8

 **F3**      4.8                  2.3

 **F4**       25                  5.6

 **F5**       11                  3.9

 **F6**     7374                  783

 **F7**      661                  321

 **F8**    29808                 7881

 **F9**    21714                 7307

 **F10**     121                   35

 **F11**     586                  391

 **F12**    2147                  555

 **F13**    1614                 1142

 **F14**    4452                 1549

 **F15**   13181                 6137

 **F16**   40178                 2235

 **F17**   34906                 9699

 **F18**   56113                22004

 **F19**   57162                14803

 **F20**   89594                17536
-------------------------------------

Table: Taken time of nmmso.R for all 20 functions over 10 runs. All times are in seconds.

# Conclusion #

In this project. a reimplementation of the NMMSO algorithm in R was shown. As part of this project also, a reimplementation of the CEC Benchmarking Suite was created. It was shown that it is possible to translate a Matlab program into R while keeping the comparability at a high level. In the programming project approaches have been shown and tested to overcome common differences in the two programming language to implement an existing algorithm in both languages. 

Even though this implementation is not the most performant and certainly had its problems while being implemented a recreation of the NMMSO algorithm and the CEC benchmarking tool have been done which work reliably and provide similar results to the original implementations. 

A foundation to further use this both packages has been set, which enables further testing and invite to reuse the nmmso.R for different uses. 

# Acknowledgements #

We want to thank Dr. Jonathan Fieldsend for his continuous help via mail during this seminar. Also, the committee of the CEC was always available for questions and concerns during our work. Furthermore, a special thanks go to all employees of the chair for 'Information Systems and Statistics' including Dr. Mike Preuß, Jakob Bossek and Pascal Kerschke who were available for any questions regarding the implementation and this report at all times.
\newpage
