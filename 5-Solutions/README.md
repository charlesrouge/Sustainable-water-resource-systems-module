At the start of the tutorial, you are given essentially the same water resource model you had at the end of tutorial 2, with all values in global variables 
"reservoir" and "flows". Files are as follows:

=> Matlab file "main.m" is the main script. Type "main" in the Matlab console to run everything.

=> "preparation.m" is identical to the Tutorial 2 file.

=> "sim_conowingo.m" is identical to the file at the end of Tutorial 3. It is the version of the water balance that is compatible with the MOEA (NSGA-II).

=> "evaluate_objective.m" is the auxiliary function that NSGA-II needs to use the simulator "sim_conowingo.m"

=> "rrv_indicators.m" computes the indicators R (reliability), R (resilience) and V (vulnerability). 

=> "performance.m" uses "rrv_indicators.m" to compute all the indicators from Tutorial 2.

=> "discovery_reliability.m" plots the results of the sensitivity analysis.

