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
hp_annual = zeros(7,4);
reliability = zeros(7,4,6);
resilience = zeros(7,4,6);
vulnerability = zeros(7,4,6);
failure_rate = zeros(7,4,6); % annual failure rate not total count
volumetric_reliability = zeros(7,4,4);


% Loop on flows
for i = 1:7
    
    % Re-initialise "flows" and get right value of inflows
    flows = flows_init;
    flows.inflows = (1-0.05*(i-1)) * flows.inflows;
    
    % Loop on levers
    for j = 1:4
        
        % Re-initialise "reservoir"
        reservoir = res_init;
        
        % Scenarios where Peach Bottom intake is lowered to the level of
        % Baltimore's
        if j == 2 || j == 4
            reservoir.demand_intake_level(3) = ...
                reservoir.demand_intake_level(2);
        end
        
        % Scenarios where suppply to Baltimore is cut when reservoir is not
        % full. This is equivalent to having the intake at full reservoir
        % level
        if j == 3 || j == 4
            reservoir.demand_intake_level(2) = reservoir.max_head;
        end
        
        % Call water balance routine for simulation 
        flows = water_balance_sop(reservoir, flows);
        
        % Evaluating performance
        results = performance(flows, reservoir);
        
        % Storing results
        hp_annual(i,j) = sum(results.hydropower) / nb_years;
        reliability(i,j,:) = results.reliability;
        resilience(i,j,:) = results.resilience;
        vulnerability(i,j,:) = results.vulnerability;
        failure_rate(i,j,:) = results.failure_count / nb_years; % we want an annual rate and not the total failure count
        volumetric_reliability(i,j,:) = results.volumetric_reliability;
        
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
% plot_regret(1, hp_annual, 'Annual production', {'Hydropower'})
% plot_regret(2, hp_annual, 'Annual production', {'Hydropower'})
% plot_regret(3, hp_annual, 'Annual production', {'Hydropower'})

% Multi-actor analysis (except for flooding)

% Pick indicator of choice (higher values must be better, put a minus if needed, as in "- vulnerability")
var_name = 'resilience'; %'reliability';
var = - failure_rate;
obj_list = [{'Ecological'}, {'Chester'}, {'Baltimore'}, {'Peach Bottom'}, ...
    {'Flooding'}, {'Recreation'}];

% Comment and uncomment as you see fit!

% plot_regret(1, var, var_name, obj_list)
% plot_regret(2, var, var_name, obj_list)
% plot_regret(3, var, var_name, obj_list)




