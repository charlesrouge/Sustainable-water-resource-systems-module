% This is part of Tutorial 2 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, last modified 2023
% 
% This routine is the main one in tutorial 2. 
%

%% Prepare workspace
clear all
close all

%% Part 1: Organise data, perform water balance

% Define global variables
global reservoir;
global flows;

% Get inputs to water balance
addpath('./../')
file_data = '../Conowingo data.xlsx';

% Call the data preparation routine
[reservoir, flows] = preparation(file_data);

% Variable
T = size(flows.month_index, 1); % number of time steps in simulation

% Call water balance routine
flows = water_balance_sop(reservoir, flows);


%% Part 2: indicators 

% New structure
indicators = struct();

% Hydropower: average annual production (MWh)
hp = 1000*9.81*reservoir.hydropower_efficiency*flows.hydraulic_head.*...
    (flows.release/86400).*24/1E6;
indicators.annual_hydropower = sum(hp) / 70;

% RRV indicators for demands
indicators.chester = ...
    rrv_indicators(flows.withdrawals(:,1),flows.local_demand(:,1),1);
indicators.baltimore = ...
    rrv_indicators(flows.withdrawals(:,2),flows.local_demand(:,2),1);
indicators.peach_bottom = ...
    rrv_indicators(flows.withdrawals(:,3),flows.local_demand(:,3),1);
indicators.ecological = ...
    rrv_indicators(flows.release,flows.downstream_demand,1);

% Add volumetric reliability for demands
indicators.chester.volumetric_reliability = ...
    sum(flows.withdrawals(:,1)) / sum(flows.local_demand(:,1)); % COMPLETE ON THIS LINE
indicators.baltimore.volumetric_reliability = ...
    sum(flows.withdrawals(:,2)) / sum(flows.local_demand(:,2)); % COMPLETE ON THIS LINE
indicators.peach_bottom.volumetric_reliability = ...
    sum(flows.withdrawals(:,3)) / sum(flows.local_demand(:,3)); % COMPLETE ON THIS LINE
indicators.ecological.volumetric_reliability = sum(min(flows.release, ...
    flows.downstream_demand)) / sum(flows.downstream_demand); % COMPLETE ON THIS LINE

% RRV indicators for flooding
indicators.flooding = rrv_indicators(...
    (flows.release+flows.spillage)/86400, 15000*ones(T,1), 0); 

% RRV indicators for recreation
summer_levels = zeros(70*(30+31+31), 1); % only keep the head levels for every summer
% While loop to get the summer levels of every summer
t = 1;
y = 0;
while t <= T 
    if flows.month_index(t) == 6 % we get to June 1st
       summer_levels(y*92+1:(y+1)*92) = flows.hydraulic_head(t:t+91); % get the three next months of hydraulic head
       y = y+1; % on to next year
       t = t + 365; % on to next year
    else
        t = t + 1;
    end
end
% Get the indicators
indicators.recreation = rrv_indicators(summer_levels, ...
    106.5*0.3048*ones(size(summer_levels,1),1), 1); 

%% Save all indicators to Excel file
xlswrite('Indicators.xlsx', [{'Metric'}, 'Chester demand', ...
    'Baltimore demand', 'Nuclear plant (Peach Bottom)', ...
    'Ecological releases', 'Flooding', 'Recreation'], 'Results')
xlswrite('Indicators.xlsx', [{'Failure count'}; {'Reliability'}; ...
    'Resilience'; 'Vulnerability'; 'Percentage vulnerability'; ...
    'Volumetric reliability'], 'Results', 'A2:A7')

metric_array = [aggregate_demand(indicators.chester), ...
    aggregate_demand(indicators.baltimore), ...
    aggregate_demand(indicators.peach_bottom), ...
    aggregate_demand(indicators.ecological), ...
    aggregate_other(indicators.flooding), ...
    aggregate_other(indicators.recreation)]; 

xlswrite('Indicators.xlsx', metric_array, 'Results', 'B2:G7')

function array =  aggregate_demand(metrics)
array = [metrics.failure_count; metrics.reliability; ...
    metrics.resilience; metrics.vulnerability; metrics.vul_percentage; ...
    metrics.volumetric_reliability];
end

function array = aggregate_other(metrics)
array = [metrics.failure_count; metrics.reliability; ...
    metrics.resilience; metrics.vulnerability; metrics.vul_percentage; ...
    NaN];
end
