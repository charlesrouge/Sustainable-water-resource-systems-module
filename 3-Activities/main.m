% This is part of Tutorial 3 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This routine is the main one in tutorial 3 (Part B). 
%

%% Prepare workspace
clear all
close all

%% Part 1: Organise data, perform water balance

% Define global variables
global reservoir;
global flows;

% Get inputs to water balance
file_data = 'Conowingo data.xlsx';

% Call the data preparation routine
[reservoir, flows] = preparation(file_data);

% Testing the simulator (feel free to play with the last two arguments)
[objs, flows] = sim_conowingo(reservoir, flows, 0.1, 105*0.3048);
% objs % uncomment to see results

%% Multi-objective optimisation
%
% If you want to run the algorithm once, save results by uncommenting last
% two lines

% Settings (COMPLETE)

% Main call
% The algorithm returns the initial (ch0) and the final population (chF)
[ch0, chF, f_inter] = nsga_2(...); % COMPLETE

% Save results
decisions = ; % COMPLETE
pareto_front = ; % COMPLETE
% save('decisions.mat','decisions')
% save('pareto_front.mat','pareto_front')

%% Representing solutions

% % If working from saved solutions
% % load decisions.mat
% % load pareto_front.mat
% 
% % Plotting
% figure
% % Objectives are to MAXIMISE
% parallelplot([- pareto_front, decisions])
% title('raw ojectives, historical flows')
% raw_baseline = pareto_front;

