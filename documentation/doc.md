# Introduction #

In the recent years R has become the statistical programming language of choice for many scientist. The strength of R of being a domain specific language has also become one of its weaknesses. Since new research findings in statistical computing are split up over several languages like R, Matlab or SciPy[^1] it often becomes difficult to compare new methods with established ones. Since it is also hard to interface those languages due to different architectures, data storage mechanisms there is often no other way than to reimplement new methods in a different programming language to create a common scope.

An example for a well perceived new finding in statistical computing is the NMMSO-Algorithm by Jonathan E. Fieldsend [@fieldsend_2014]. It won the niching competition in 2015 held by the CEC and is only written in Matlab. Since the chair 'Information Systems and Statistics' at the Westfälische Wilhelms-Universität Münster, Germany is mainly concentrating its work on Statistical Computing in R an implementation of this algorithm became interesting. 

As part of this Seminar Project in the context of the Seminar 'Statistical Computing in R' a reimplementation of the NMMSO algorithm in R (nmmso.R) will be presented. During this technical documentation, the general function of the algorithm and the used test cases by the CEC will be shown. Afterwards the structure and used techniques and libraries, as well as problems and pitfalls due to the different behaviours of R and Matlab, will be shown. The documentation will be closed by the benchmarking results and different test cases. 

It was the goal of this project to keep up high comparability with the original code, to ensure the correct functionality and easily implement changes to the original codebase in this program. To reach this, unit tests were used where possible and continouous comparison between part results of the original implementation and nmmso.R where used to ensure functioning. Additionally a benchmarking suite, which builds on the CEC Benchmarking Suite for Niching Algorithm was implemented to evaluate and test the functioning of nmmso.R with the same characteristics as in the original implementation.

[^1]: SciPy is a common library for the Python Programming language which brings Statistical Computing capabilities to the language.
\newpage

# General Function #

The starting point of the project was the paper provided by Dr. Jonathen E. Fieldsend [@fieldsend_2014] on the Niching Migratory Multi-Swarm Optimiser (NMMSO) algorithm. NMMSO is a multi-modal optimiser which relies heavily on multiple swarms which are generated on the landscape of an function in order to find the global optimum. It is build around three main pillars: (1) dynamic in the numbers of dimensions, (2) self-adaptive without any special preparation and (3) exploitative local search to quickly find peak estimates [@fieldsend_2014, p. 1]. 

Multi-modal optimisation in general is not that different from well known and widely discussed single-objective optimisation, but in difference to it the goal of the algorithms in the multi-modal is not to find just one single optimising point but all possible points [@fieldsend_2014, p. 1]. In order to do so, many early multi-modal optimisation algorithms needed defined parameters [TODO: quote needed]. 

**maybe it would be interesting to write a few more lines about the history of evolutionary algorithms here?**

Newer algorithms fall in the field of self-tuning and try to use different mathematical paradigms like nearest-best clustering with covariance matrices [@preuss_2012] and strategies like storing the so far best found global optima estimators to provide them as parameters for new optimisation runs [@epitropakis_2013]. Contradictory to that NMMSO goes another way and uses the the swarm strategy in order to find which store their current [@fieldsend_2014]

In order to do so NMMSO follow a strict structure which can be seen in the following pseudo-code

	nmmso(max_evals, tol, n, max_inc, c_1, c_2, chi, w)
		S: initialise_swarm(1)
		evaluations := 1
		while evaluations < max_evals:
			while flagged_swarms(S) == true:
				{S, m} := attempt_merge(S, n, tol)
				evals := evals + m
			S := increment(S, n, max_inc, c_1, c_2, chi, w)
			evals := evals + min(|S|, max_inc)
			{S, k} := attempt_separation(S, tol)
			evals := evals + k
			S := add_new_swarm(S)
			evals := evals + 1
		{X*, Y*} := extract_gbest(S)
		return X*,Y*

This structure wasn't modified during the reimplementation of  NMMSO to keep comparability and the possibility to fix bugs at a high level. The only newly introduced setting was the possibility to modify the c_1, c_2, chi, w as parameters from the outside. In the original version those parameters are part of the program code.

           standard value 	used value     
--------   --------------	----------
evaluations	0				0
max_evol	100				100
tol_val		10^-6			10^-6
c_1			2.0             2.0
c_2			2.0	            2.0
omega		0.1       		0.1
---------  --------------   ----------

**What else about the algorithm need to be explained that isn't explicitly part of the implementation?**

----

# CEC Algorithms #

## CEC ##

The IEEE Congress of Evolutionary Computation (CEC) is one of the largest, most important and recognised conferences within Evolutionary Computation (EC). It is organised by the IEEE Computational Intelligence Society in cooperation with the Evolutionary Programming Society, and covers most of the subtopics of the EC.

In order to validate the potential of the NMMSO algorithm, it was submitted to the IEEE CEC 2013 held in Cancun, Mexico. Here, Dr. Fieldsend was provided with some multimodal benchmark test functions with different dimension sizes and characteristics, for evaluating niching algorithms developed by Dr. Xiaodong Li, Dr. Andries Engelbrecht and Dr. Michael G. Epitropakis [@epitropakis_2013]. They state that even if several niching methods have been around for many years, further advances in this area have been hindered by several obstacles; most of the studies focus on very low dimensional multimodal problems (2 or 3 dimensions) making this more complicated to asses theses methods’ scalability to high dimensions with better performance. The benchmark tool includes 20 test functions (in some cases the same function but with different dimension sizes), which includes 10 simple, well-known and widely used benchmark functions, based on recent studies, and more complex functions following the paradigm of composition functions. In the following section, they will be briefly explained:

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

All of the test functions are formulated as maximisation problems. F1, F2 and F3 are simple 1D multimodal functions, while F4 and F5 are simple 2D functions and not scalable. F6 to F8 are scalable multimodal functions. The number of global optima for F6 and F7 are determined by the dimension. However, for F8, the number of global optima is independent from the dimension, therefore it can be controlled by the user. F9 to F12 are scalable multimodal functions constructed by several basic functions with different properties (Sphere function, Grienwank, Rastrigin, Weierstrass and the Expanded Griewank’s plus Rosenbrock’s function). F9 and F10 are separable, and non-symmetric, while F11 and F12 are non-separable, non-symmetric complex multimodal functions. The number of global optima in all of the composition functions is independent from the number of dimensions, therefore can be controlled by the user [@epitropakis_2013].

**Maybe write each math equation or the R code**


https://en.wikipedia.org/wiki/IEEE_Congress_on_Evolutionary_Computation

## Implementation and Pitfalls ##

**write also about the count_goptima and so on**

----

# The Implementation #

## Structure of the project ##

After analysing the algorithm provided in Matlab by Dr. Fieldsend, it was decided to first translate each of the functions into the R programming language. At first instance, this task seemed to be simple because most of the functions were basically managing matrices and vectors, but later this became a problem that will be addressed in the pitfalls’ section of this paper.

Once all the NMMSO functions existed in R and having the input data, the testing phase started. It has be said, that one of the biggest problems when you code an already existing program into another programming language, is the different behaviours corresponding to each object (in case of an object-oriented language) or its main structure. The first runs came with several errors regarding the matrix generation and handling, slowing down the project in a near future. Using GitHub, it was easier to attack these problems in parallel, having one developer reviewing different functions and the other one, fixing other bugs and continue the testing phase. Also, this was achieved in an easier way, thanks that each function was coded in an independent R file, making easier and faster the debugging and the fixing of each problem.

During the developing time, an issue raised with the CEC benchmark tool. In order to compare the R implementation of the NMMSO algorithm with the original one, it was mandatory to use this tool to test each of its functions with the new algorithm and compare results. After several complications with the original test suite (these complications will be addressed in the pitfalls’ section), it was decided to recode each of the functions as an independent R package to avoid any further complication and having an easier and more trustworthy comparison of the NMMSO algorithm in R.

## Pitfalls and Problems ##

test

# Benchmark and Comparison #


To compare nmmso.R with the original NMMSO the CEC test cases were used to run the same benchmarks as in the original submission [@fieldsend_2014]. There 4 different Ratios were used to measure the performance of certain algorithms. Three of those measures (Peak Ratio, Success Ratio and Convergence Speed) have been introduced in [@epitropakis_2013, pp. 6-7] to create a common point of comparison. The fourth ratio is special for the nmmso algorithm since it tracks the number of swarms over the iterations of the algorithm. Nmmso.R uses the same measures to reach the highest comparability possible.

The first measure used is the Success Ratio (SR). The Success Ratio is defined as the percentage of Successful runs (runs that found all global optima) over all runs [@li_2013, p. 7]. As for the other ratios this measure was taken over several independent runs and collectively evaluated. The taken measures for the Success Ratio can be found in Table 2. 
$$\frac{successful\ runs}{NR} = SR $$ 
Here $NR$ denotes the Number of runs done to reach this measure.

The second measure introduced by the CEC committee and also used by Dr. Fieldsend is the Convergence Rate. The Convergence Rate (CR) measures the needed evaluations per Accuracy and Function to find all global optima [@li_2013, p.7]. This measure takes the mean of evaluations over all runs. The results of this measure can be found in Table 3.
$$\frac{\sum\nolimits_{n=1}^{NR} evals_{n}}{NR} = CR$$ 
In this measure $evals$ denotes the number of evaluations done. 

The third measure is the Peak Ratio (PR). It measures the share of found global optima over all runs [@li_2013, p.7]. The results of this evaluation can be found in Table 4.

$$\frac{\sum\nolimits_{n=1}^{NR} NOF_{n}}{NKO * NR} = PR$$
In this measure $NOF$ denotes the number of found optima per run and $NKO$ the number of known optima for the function. 

As a fourth measure, which wasn't introduced by the CEC committee, but used in the original nmmso implementation [@fieldsend_2014] the Number of Swarms was chosen. Since this is a continuous measure and therefore no calculation is needed this measure is pictured as graphs. The graphs can be found in Figure 1. The show the development of $number of swarms$ kept by nmmso.R over all iterations. Important to notice here is that $iterations$ is different from the $evaluations$ referenced in the other measures. Iterations are calls to start single runs of nmmso.R and is therefore different from the evaluations taken within the program.

Additionally a fifth measure was introduced which denotes the runtime of nmmso.R for the single functions. These times were taken on the ZIVHPC a scientific High Perfomance Computing Cluster by Westfälische Wilhelms-Universität Münster. Since the nmmso.R is a strictly sequential algorithm the runtimes for single runs will comparable on common computers. The ZIVHPC was only used to parallelize the single runs.


--------------------------------------------------------
 &nbsp;     0.1   0.01   0.001   0.0001   0.00001   runs
--------- ----- ------ ------- -------- --------- ------
 **F1**       1      1       1        1         1     32

 **F2**       1      1       1        1         1     30

 **F3**       1      1       1        1         1     32

 **F4**       1      1       1        1         1     32

 **F5**       1      1       1        1         1     29

 **F6**       1      1       1        1         0     29

 **F7**       1      1       1        1         1     29

 **F8**       1      1       1     0.91      0.73     11

 **F9**       1      1       1        1         1     15

 **F10**      1      1       1        1         1     29

 **F11**      1      1       1        1         1     29

 **F12**      1      1       1        1         1     28

 **F13**      1      1       1        1         1     28

 **F14**      1      1       1        1         1     27

 **F15**      1      1       1        1         1     20

 **F16**      0      0       0        0         0      8

 **F17**   0.14      0       0        0         0      7

 **F18**    0.4    0.4     0.4      0.4       0.4     10

 **F19**      0      0       0        0         0      7

 **F20**      0      0       0        0         0      6
--------------------------------------------------------

Table: Success Ratio over given runs



---------------------------------------------------------
 &nbsp;      0.1   0.01   0.001   0.0001   0.00001   runs
--------- ------ ------ ------- -------- --------- ------
 **F1**      641    839    1050     1228      1449     32

 **F2**      179    256     394      534       636     30

 **F3**       38    182     277      386       511     32

 **F4**      501    736     969     1173      1434     32

 **F5**       84    200     322      503       786     29

 **F6**    19548  24640   30646    42534    200001     29

 **F7**     8368   9059   10272    12212     13613     29

 **F8**   176727 215977  253443   307968    341918     11

 **F9**   175729 179787  192204   203835    213030     15

 **F10**     899   1347    1727     2255      2773     29

 **F11**    3517   5516    7099     8069      8741     29

 **F12**   17330  25136   37468    44542     50752     28

 **F13**   11555  16033   20058    23771     27500     28

 **F14**   29504  35431   50219    58919     68803     27

 **F15**   97539 120679  145910   175327    185881     20

 **F16**  400001 400001  400001   400001    400001      8

 **F17**  362540 400001  400001   400001    400001      7

 **F18**  288605 288631  288822   288905    289382     10

 **F19**  400001 400001  400001   400001    400001      7

 **F20**  400001 400001  400001   400001    400001      6
---------------------------------------------------------

Table: Convergence Rates over given runs


--------------------------------------------------------
 &nbsp;     0.1   0.01   0.001   0.0001   0.00001   runs
--------- ----- ------ ------- -------- --------- ------
 **F1**       1      1       1        1         1     32

 **F2**       1      1       1        1         1     30

 **F3**       1      1       1        1         1     32

 **F4**       1      1       1        1         1     32

 **F5**       1      1       1        1         1     29

 **F6**       1      1       1        1         0     29

 **F7**       1      1       1        1         1     29

 **F8**       1      1       1        1      0.98     11

 **F9**       1      1       1        1         1     15

 **F10**      1      1       1        1         1     29

 **F11**      1      1       1        1         1     29

 **F12**      1      1       1        1         1     28

 **F13**      1      1       1        1         1     28

 **F14**      1      1       1        1         1     27

 **F15**      1      1       1        1         1     20

 **F16**   0.02      0       0        0         0      8

 **F17**    0.8   0.79    0.79     0.79      0.71      7

 **F18**   0.82   0.82    0.82      0.8       0.8     10

 **F19**   0.36   0.36    0.33     0.33      0.31      7

 **F20**   0.21   0.19    0.19     0.19      0.17      6
--------------------------------------------------------

Table: Mean Peak Ratio over given runs


![plot of chunk trend curve of kept swarms over all 20 functions.](figure/trend curve of kept swarms over all 20 functions.-1.pdf) 





# Discussion #

test

# Conclusion #

test


# Acknowledgements #

Thanks to everybody!
\newpage
