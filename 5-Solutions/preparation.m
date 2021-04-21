% This is part of the Tutorials for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% Reads the input Excel file (file_data) to prepare data:
%   - reservoir: the physical infrastructure
%   - flows: historical inflows, and demands

function [reservoir, flows] = preparation(file_data)

% Initialise structures
reservoir = struct(); 
flows = {};

% Inflow data: read
inflows_read = xlsread(file_data, 'Flow data'); 
flows.month_index = inflows_read(:,5); % 
T = size(inflows_read,1); % number of days

% Enter inflow data
flows.inflows = inflows_read(:, 3)* 0.3048^3 * 86400; % take total inflows convert into m3 / day

% Demand data (demands as time series)
demands = xlsread(file_data, 'Demands', 'B2:E13'); 
demands = demands * 0.3048^3 * 86400; % conversion cfs to m3 / day
flows.downstream_demand = zeros(T,1);
flows.local_demand = zeros(T,3);
% For each day, add demand depending on what month it is
for i = 1:12 % loop on months
    this_month_days = (flows.month_index == i); % 1 if day is in month "i", 0 otherwise
    flows.downstream_demand = flows.downstream_demand + ...
        demands(i,4) * this_month_days;
    for j = 1:3 % loop on local demands
        flows.local_demand(:,j) = flows.local_demand(:,j) + ...
            demands(i, j) * this_month_days;
    end
end

% Reservoir characteristics
reservoir.min_storage = xlsread(file_data, ...
    'Reservoir characteristics', 'B1') * 1E6; % hm3 to m3
reservoir.max_storage = xlsread(file_data, ...
    'Reservoir characteristics', 'B2') * 1E6; % hm3 to m3
reservoir.initial_storage = 0.9 * reservoir.max_storage; % Given results
reservoir.max_release = xlsread(file_data, ...
    'Reservoir characteristics', 'B5') * 86400; % m3/s to m3/day
% Getting head and lake area characteristics
% Read key data
key_data = xlsread('Conowingo data.xlsx', 'Reservoir characteristics', 'F4:H6');
% Full reservoir data 
reservoir.max_head = key_data(1, 1); % m
reservoir.max_surface = key_data(1, 2) * 1E4; % in m2
% Empty reservoir data
reservoir.empty_head = key_data(3, 1); % m
reservoir.demand_intake_level = [100.5 91.5 103.5]*0.3048; % conversion ft to m
% Hydropower plant
reservoir.installed_capacity = xlsread(file_data, ...
    'Reservoir characteristics', 'B4'); % in MW
% Hydropower: computing combined turbine and generator efficiency
reservoir.hydropower_efficiency = reservoir.installed_capacity*1E6 / ...
    (1000*9.81*reservoir.max_head*reservoir.max_release/86400); 

end