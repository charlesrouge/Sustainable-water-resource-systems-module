This folder contains files and two sub-folders. Files in this folder are:

=> Matlab file "main.m" is the main script. Type "main" in the Matlab console to run everything.
It builds on the last version of "main.m" from tutorial 1 (with intake heights for demands) and adds a part for multi-objective optimisation.

=> Matlab file "preparation.m" is identical to Tutorial 2 file. 

=> Matlab file "sim_conowingo.m" modifies "water_balance_final.m" to run the NSGA-II algorithm.

=> "evaluate_objective.m" is the auxiliary function that NSGA-II needs to use the simulator "sim_conowingo.m".

The two folders are as follows:

1) Folder "M3O-modified-files" contains the Matlab code that is written or modified in Part A. It contains two such files:

=> "main_script.m" modifies the file in the toolbox to adapt it to this tutorial

=> "plotter.m" enables us to plot the results and understand how to use them

2) Folder "Example_solutions" contains an example solution when we run NSGA-II on the Conowingo case. 
MAT files contain the final objective values (pareto_front.mat) and associated decision variables (decisions.mat).
