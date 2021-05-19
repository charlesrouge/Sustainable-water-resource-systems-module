% This is part of Tutorial 5 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This routine is the main one in tutorial 5. 
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

% New intake at Peach Bottom
reservoir.demand_intake_level(3) = reservoir.demand_intake_level(2);

% Save the global variables before manipulating them 
save('reservoir.mat','reservoir')
save('flows.mat','flows')

%% Multi-objective optimisation
%
% If you want to run the algorithm once, save results by uncommenting last
% two lines

% Run for 20% less flow
flows.inflows = 0.8*flows.inflows; % FILL LINE

% Settings
addpath('./NSGA-II') % Assume we copied and pasted the folder in same folder as this file.
nb_gen = 100;
size_pop = 40;
M=3;
V=2;
min_range = [ 0 reservoir.demand_intake_level(2) ];
max_range = [ 1 reservoir.max_head ];

% Main call
% The algorithm returns the initial (ch0) and the final population (chF)
[ch0, chF, f_inter] = nsga_2(size_pop,nb_gen,M,V,min_range,max_range);

% Save results
decisions = chF(:, 1:V);
pareto_front = chF(:, V+1:V+M);
save('decisions.mat','decisions')
save('pareto_front.mat','pareto_front')

%% Representing solutions

% If working from saved solutions
load decisions.mat
load pareto_front.mat

% Rescaling results
% Objective 1 to 3 are objectives to MAXIMISE (FILL IN LINE BELOW)
pareto_front(:,1:2:3) = - pareto_front(:,1:2:3);

% Select cheapest solution such that Baltimore volumetric reliability is
% greater than 99%
% i.e. the solution with smaller volumetric reliability for Baltimore in
% that set
[min4, I] = min(pareto_front(:,2).*(pareto_front(:,1)>0.99) + (pareto_front(:,1)<0.99)); % TO COMPLETE we have conditions on objective 2 to remove them from consideration
% Corresponding decisions, TO COMPLETE
desal_selected = decisions(I,1);
level_selected = decisions(I,2);

% Categorise variables
res_categories = cell(size(pareto_front,1),1); % Acceptable solutions
res_categories(:) = {'All solutions'};
res_categories(I) = {'Selected solution'}; % the "best solution"

figure
p = parallelplot([pareto_front, decisions], 'GroupData', res_categories); % 'CoordinateVariables', coord_labels);
p.CoordinateTickLabels = {'Balt. vol. rel.','Balt. desal. fraction','Ches. rel.','Plant size','Trigger res. level (m)'};

%% Visualise flows month by month
monthly_flows = zeros(12,1);
days_in_month = [ 31 28.25 31 30 31 30 31 31 30 31 30 31 ];
T = length(flows.month_index);
nb_years = floor(T/365+1E-6);
for i = 1:12  
    monthly_flows(i,1) = sum((flows.month_index == i).*flows.inflows); % Get grand total in m3
end
monthly_flows = monthly_flows./ (nb_years*days_in_month'); % Daily average in m3/day
figure
plot(monthly_flows /86400) %in m3/s
xlabel('Time (months)')
ylabel('Flow (m3/s)')
title('Conowingo average inflows')
set(gca,'Xlim',[1 12],'XTick',1:12,'XTickLabel',...
    {'J' 'F' 'M' 'A' 'M' 'J' 'J' 'A' 'S' 'O' 'N' 'D'})

%% Sensitvity analysis: scenario discovery

% Ranges (as a fraction; TO COMPLETE)
range_min = [-0.4 -0.4 0 0];
range_max = [0 0 0.4 0.4];

% Sampling: LHS
N = 1000; % COMPLETE, sample size
nb_dim = length(range_min); % number of dimensions (number of variables)
x_exp = lhsdesign(N,nb_dim); % TO COMPLETE: find function in Matlab (with the help) to get N points in a 4-dimensional unit hyerpcube

% Use ranges and sampling to get multiplier for all four inputs for each
% scenario (i.e. factor by which to multiply each input in each scenario)
multiplier = 1 + range_min + repmat((range_max - range_min),N,1).*x_exp; % TO COMPLETE

% Collecting results (similar setup to tutorial 4, but with different)
reliability = zeros(N,6);
hp_annual = zeros(N, 1);

% Main loop
for i = 1:N
    
    % Generate inputs for each variables from the multipliers, generating a
    % new "flows" structure
    clear flows
    load flows
    
    % Flows: first two inputs (COMPLETE)
    flows.inflows = flows.inflows.*...
        (multiplier(i,1)*((flows.month_index<6)+(flows.month_index==12)) + ...
        multiplier(i,2)*((flows.month_index>5).*(flows.month_index<12))); % TO COMPLETE (use conditions similar to line 38 in this code)
    
    % Domestic demands (COMPLETE, do not forget that the desalination plant capacity is the same across scenarios and needs to be adjusted)
    flows.local_demand(:,1:2) = flows.local_demand(:,1:2)*multiplier(i,3);
    reduction = desal_selected / multiplier(i,3);
    
    % Ecological demands (COMPLETE)
    flows.downstream_demand = flows.downstream_demand*multiplier(i,4);
    
    % Simulation
    [objs_sen, flows] = sim_conowingo(reservoir, flows, reduction, level_selected);
    
    % Actual water supply to Baltimore
    flows.withdrawals(:,2) = flows.withdrawals(:,2) + ...
        flows.local_demand(:,2) * reduction;
    
    % Evaluating performance
    indicators = performance(flows, reservoir);

    % Storing results
	hp_annual(i) = mean(indicators.hydropower);
	reliability(i,:) = indicators.reliability;
    
end

%% Plot results (reliability)

% Choose variable (e.g. Baltimore or Peach Bottom)
z = reliability(:,2); % 2 for Chester

% Define success vs. failure
threshold = 0.95;

input_names = {'Inflows (Dec-May)','Inflows (Jun-Nov)','Domestic demand','Ecological flows'};

% Plotting 
figure
k = 0;
for i =1:4
    
    x1 = multiplier(:,i);
    
    for j=i+1:4
        k = k+1;
        x2 = multiplier(:,j);
        % A plot for each pair of inputs
        subplot(2,3,k)
        discovery_reliability(x1,x2,z,threshold,input_names{i},input_names{j})
    end
    
end
