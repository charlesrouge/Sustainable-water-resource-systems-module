% This is part of Tutorial 1 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2020
% 
% This routine is the main one in tutorial one. 
%
%% Uncomment one line at a time (ctrl + T), as you go through the questions

%% Prepare workspace
clear all
close all

%% Part 0 

% reservoir_shape

%% Part 1: water balance
% 
% % Define global variables
% global reservoir;
% global flows;
% 
% % Get inputs to water balance
% file_data = 'Conowingo data.xlsx';
% 
% % Reservoir characteristics
% reservoir = struct(); % declare a structure
% reservoir.min_storage = xlsread(file_data, 'Reservoir characteristics', 'B1') * K1; % REPLACE K1 with correct number to convert into m3
% reservoir.max_storage = xlsread(file_data, 'Reservoir characteristics', 'B2') * K1; % REPLACE K1 with correct number to convert into m3
% reservoir.initial_storage = 0.9 * reservoir.max_storage;
% reservoir.max_release = xlsread(file_data, 'Reservoir characteristics', 'B5') * K2; % REPLACE K2 with correct number to convert into m3/day
% reservoir.installed_capacity = ; % COMPLETE, in MW
% 
% % Inflow data
% read_inflows = ; % COMPLETE with correct xlsread call 
% flows.inflows = read_inflows(:, X);  % REPLACE X with correct column number 
% flows.inflows = flows.inflows * K; % REPLACE with correct value of K to convert into m3 / day
% month_index = read_inflows(:, Y); % REPLACE Y with correct column number
% T = size(month_index, 1); % number of time steps in simulation
% 
% % Demand data
% demands = xlsread(file_data, ); % COMPLETE with correct xlsread call 
% demands = demands * K3; % REPLACE with correct value of K3 to convert into m3 / day
% flows.downstream_demand = zeros(T,1);
% flows.local_demand = zeros(T,3);
% % For each day, add demand depending on what month it is
% for i = 1:12 % loop on months
%     this_month_days = (month_index == i); % 1 if day is in month "i", 0 otherwise
%     flows.downstream_demand = flows.downstream_demand + ...
%         demands(i,4) * this_month_days;
%     for j = 1:3 % loop on local demands
%         flows.local_demand(:,j) = flows.local_demand(:,j) + ...
%             demands(i, j) * this_month_days;
%     end
% end
% 
% % Call water balance routine
% flows = water_balance_basic(reservoir, flows);
% 
% % Plot results
% 
% % % Insert figure of storage through time (whichever unit you prefer)
% figure
% hold on
% plot(0:T, reservoir.min_storage*ones(T+1,1) / 1E6, '--r')
% plot(0:T, reservoir.max_storage*ones(T+1,1) / 1E6, '--r')
% plot(0:T, flows.storage_basic / 1E6, 'b')
% title('Storage')
% xlabel('Time (days)')
% ylabel('Storage (hm3)')
% set(gca, 'Xlim', [0 T])
% 
% % Insert figure of total outflows (release + spillage) through time (whichever unit you prefer)
% figure
% plot((flows.release_basic+flows.spillage_basic) / 86400)
% title('Outflows')
% xlabel('Time (days)')
% ylabel('Outflows (m3/s)')
% set(gca, 'Xlim', [1 T])

% %% Part 2: refinements, Q1 
% 
% % Getting head and lake area characteristics
% % Read key data
% key_data = xlsread('Conowingo data.xlsx', 'Reservoir characteristics', 'F4:H6');
% % Full reservoir data 
% reservoir.max_head = key_data(1, 1); % m
% reservoir.max_surface = key_data(1, 2) * 1E4; % in m2
% % Empty reservoir data
% reservoir.empty_head = key_data(3, 1); % m
% % Intakes 
% reservoir.demand_intake_level = 100*0.3048; % conversion ft to m
% 
% % Water balance must mirror this
% flows = water_balance_inter(reservoir, flows);
% 
% %% Part 2: refinements, Q2
% 
% % Now we have different intake heights
% reservoir.demand_intake_level = ; % conversion ft to m
% 
% % Water balance must mirror this
% flows = water_balance_final(reservoir, flows);
% 
% %% Part 3: exploiting results, hydropower and figures
% 
% % Hydropower: computing combined turbine and generator efficiency
% reservoir.hydropower_efficiency = ; % COMPLETE using Part 1, Q2 answer
% 
% % Time series of average heads from time series of average storage
% flows.head = ;  % TO COMPLETE
% 
% % Hydropower production as a time series (in MWh; conversion needed)
% hp = ; % WRITE FORMULA
% 
% % Average annual production
% hp_annual = ; % WRITE ANNUAL AVERAGE
% 
% % Hydropower figure
% figure 
% cdfplot(hp)
% title('Hydropower')
% xlabel('Daily production (MWh)')
% ylabel('Non-exceendence probability')
% 
% % Storage figure (CDF)
% figure
% hold on
% cdfplot(flows.storage_basic/1E6)
% cdfplot(flows.storage_inter/1E6)
% cdfplot(flows.storage_final/1E6)
% legend('Basic', 'Inter', 'Final', 'Location', 'Northwest')
% xlabel('Storage (hm3)')
% ylabel('Non-exceendence probability')
% set(gca, 'Ylim', [0 0.1])
% 
% % Withdrawals figure
% figure
% hold on
% cdfplot(flows.withdrawals_basic)
% cdfplot(flows.withdrawals_inter)
% cdfplot(sum(flows.withdrawals_final,2))
% legend('Basic', 'Inter', 'Final', 'Location', 'Northwest')
% xlabel('Daily withdrawals (m3)')
% ylabel('Non-exceendence probability')
% 
% % Withdrawals from final water balance
% figure
% plot(flows.withdrawals_final)
% xlabel('Time (days)')
% ylabel('Daily withdrawals (m3)')
% legend('Chester', 'Baltimore', 'Peach Bottom', 'Location', 'Northwest')
% set(gca, 'Xlim', [1 size(flows.withdrawals_final,1)])








