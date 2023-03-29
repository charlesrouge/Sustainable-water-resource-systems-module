% This is part of Tutorial 1 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2023
% 
% This routine is the main one in tutorial one. 
%
%% Uncomment one line at a time (ctrl + T), as you go through the questions

%% Prepare workspace
clear all
close all

%% Part 1: preparation

% reservoir_shape

% Define global variables
global reservoir;
global flows;

% Get inputs to water balance
addpath('../') % To find the inputs in parent folder
file_data = 'Conowingo data.xlsx';

% Reservoir characteristics
reservoir = struct(); % declare a structure
reservoir.min_storage = xlsread(file_data, 'Reservoir characteristics', 'B1') * 1E6; % REPLACE K1 with correct number to convert into m3
reservoir.max_storage = xlsread(file_data, 'Reservoir characteristics', 'B2') * 1E6; % REPLACE K2 with correct number to convert into m3
reservoir.initial_storage = 0.9 * reservoir.max_storage;
reservoir.max_release = xlsread(file_data, 'Reservoir characteristics', 'B5') * 86400; % REPLACE K3 with correct number to convert into m3/day
reservoir.installed_capacity = xlsread(file_data, 'Reservoir characteristics', 'B4'); % COMPLETE, in MW

% Inflow data
read_inflows = xlsread(file_data, 'Flow data'); % COMPLETE with correct xlsread call 
flows.inflows = read_inflows(:, 3);  % REPLACE X with correct column number 
flows.inflows = flows.inflows * 0.3048^3 * 86400; % REPLACE with correct value of K to convert into m3 / day
month_index = read_inflows(:, 5); % REPLACE Y with correct column number
T = size(read_inflows, 1); % number of time steps in simulation

% Demand data
demands = xlsread(file_data, 'Demands', 'B2:E13'); % COMPLETE with correct xlsread call 
demands = demands * 0.3048^3 * 86400; % REPLACE with correct value of K3 to convert into m3 / day
flows.downstream_demand = zeros(T,1);
flows.local_demand = zeros(T,3);
% For each day, add demand depending on what month it is
for i = 1:12 % loop on months
    this_month_days = (month_index == i); % 1 if day is in month "i", 0 otherwise
    flows.downstream_demand = flows.downstream_demand + ...
        demands(i,4) * this_month_days;
    for j = 1:3 % loop on local demands
        flows.local_demand(:,j) = flows.local_demand(:,j) + ...
            demands(i, j) * this_month_days;
    end
end

%% Part 2: perform basic water balance

% Call water balance routine
flows = water_balance_basic(reservoir, flows);

% Plot results

% % Insert figure of storage through time (whichever unit you prefer)
figure(1)
hold on
plot(0:T, reservoir.min_storage*ones(T+1,1) / 1E6, ':r')
plot(0:T, reservoir.max_storage*ones(T+1,1) / 1E6, '--r')
plot(0:T, flows.storage_basic / 1E6, 'b')
title('Storage')
xlabel('Time (days)')
ylabel('Storage (hm3)')
set(gca, 'Xlim', [0 T])

% Insert figure of total outflows (release + spillage) through time (whichever unit you prefer)
figure
plot((flows.release_basic+flows.spillage_basic) / 86400)
title('Outflows')
xlabel('Time (days)')
ylabel('Outflows (m3/s)')
set(gca, 'Xlim', [1 T])


%% Part 2+: water balance refinements 

% Getting head and lake area characteristics
% Read key data
key_data = xlsread('Conowingo data.xlsx', 'Reservoir characteristics', 'F4:H6');
% Full reservoir data 
reservoir.max_head = key_data(1, 1); % m
reservoir.max_surface = key_data(1, 2) * 1E4; % in m2
% Empty reservoir data
reservoir.empty_head = key_data(3, 1); % m

% Intakes with different heights for the different demands
reservoir.demand_intake_level = [100.5 91.5 103.5]*0.3048; % conversion ft to m

% Water balance must mirror this
flows = water_balance_final(reservoir, flows);


%% Part 3: exploiting results, hydropower and figures

% Hydropower: computing combined turbine and generator efficiency
reservoir.hydropower_efficiency = reservoir.installed_capacity*1E6 / ...
    (1000*9.81*reservoir.max_head*reservoir.max_release/86400); % COMPLETE using Part 1, Q2 answer

% Time series of average heads from time series of average storage
flows.head = reservoir.empty_head + flows.storage_final(1:end-1).^0.5 * ...
    sqrt(2*(reservoir.max_head-reservoir.empty_head)/reservoir.max_surface);  % TO COMPLETE

% Hydropower production as a time series (in MWh; conversion needed)
hp = 1000*9.81*reservoir.hydropower_efficiency*flows.head.*...
    (flows.release_final/86400).*24/1E6; % WRITE FORMULA

% Average annual production
hp_annual = sum(hp) / 70; % WRITE ANNUAL AVERAGE

% Completing previous storage figure
figure(1)
plot(0:T, flows.storage_final / 1E6, 'k')
legend('Min storage', 'Max storage', 'Basic', 'Final', 'Location', 'Southeast')

% Hydropower figure
figure 
cdfplot(hp)
title('Hydropower')
xlabel('Daily production (MWh)')
ylabel('Non-exceendence probability')

% Withdrawals figure
figure
hold on
cdfplot(flows.withdrawals_basic)
cdfplot(sum(flows.withdrawals_final,2))
legend('Basic', 'Final', 'Location', 'Northwest')
xlabel('Daily withdrawals (m3)')
ylabel('Non-exceendence probability')

% Storage figure (CDF)
figure
hold on
cdfplot(flows.storage_basic/1E6)
cdfplot(flows.storage_final/1E6)
legend('Basic', 'Final', 'Location', 'Northwest')
xlabel('Storage (hm3)')
ylabel('Non-exceendence probability')
set(gca, 'Ylim', [0 0.1])

% Withdrawals from final water balance
figure
plot(flows.withdrawals_final)
xlabel('Time (days)')
ylabel('Daily withdrawals (m3)')
legend('Chester', 'Baltimore', 'Peach Bottom', 'Location', 'Northwest')
set(gca, 'Xlim', [1 size(flows.withdrawals_final,1)])














