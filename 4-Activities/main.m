% This is part of Tutorial 4 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This routine is the main one in Tutorial 4.
% Other routines are supposed to be run from here. 
%

%% Prepare workspace
clear
close all

%% Prepare data to be used

% Define global variables
global reservoir;
global flows;

% Get inputs to water balance
file_data = 'Conowingo data.xlsx';

% Call the data preparation routine
[reservoir, flows] = preparation(file_data);

% Key variables
nb_years = 70; % length of simulation in years

%% Exploring futures and options

% Store reservoir and flows structures
res_init = reservoir;
flows_init = flows;

% Initialise outputs
hp_annual = zeros(5,4);
reliability = zeros(5,4,6);
resilience = zeros(5,4,6);
vulnerability = zeros(5,4,6);
failure_rate = zeros(5,4,6); % annual failure rate not total count

% Loop on flows
for i = 1:7
    
    % Re-initialise "flows" and get right value of synthetic inflows
    
    % Loop on levers
    for j = 1:4
        
        % Re-initialise "reservoir"
        
        % Scenarios where Peach Bottom intake is lowered to the level of
        % Baltimore's
        
        % Scenarios where suppply to Baltimore is cut when reservoir is not
        % full. This is equivalent to having the intake at full reservoir
        % level
        
        % Call water balance routine for synthetic flows 
        
        % Evaluating performance
        
        % Storing results
        hp_annual(i,j) = ;
        reliability(i,j,:) = ;
        resilience(i,j,:) = ;
        vulnerability(i,j,:) = ;
        failure_rate(i,j,:) = ; % we want an annual rate and not the total failure count
        
    end
    
end

% % Saving results
% save('hp_annual.mat','hp_annual')
% save('reliability.mat','reliability')
% save('resilience.mat','resilience')
% save('vulnerability.mat','vulnerability')
% save('failure_rate.mat','failure_rate')

%% Plotting regret (comment / uncomment)

% load hp_annual
% load reliability
% load resilience
% load vulnerability
% load failure_rate

% Hydropower
% INSERT FUNCTION CALLS HERE, with plot_regret

% Multi-actor analysis (except for flooding)

% Pick indicator of choice (higher values must be better, put a minus if needed, as in "- vulnerability")
var_name = 'resilience'; %'reliability';
var = - failure_rate;
obj_list = [{'Ecological'}, {'Chester'}, {'Baltimore'}, {'Peach Bottom'}, ...
    {'Flooding'}, {'Recreation'}];

% Include plots as you want