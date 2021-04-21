% This is part of Tutorial 3 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This is the evaluate_objective function that NSGA2 uses
%

function f = evaluate_objective(x, M, V)

global reservoir; % Global variable used for evaluation of objectives
global flows; % Global variable used for evaluation of objectives

% Use minus because the algorithms tries to minimise objective values by
% default
f =  - sim_conowingo(reservoir, flows, x(1), x(2));

end