% This is part of the Tutorials for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% Evaluate joint performance of:
%   - reservoir: the physical infrastructure
%   - flows: water flows and stocks
%
% Fields within structure indicators are:
%   - reliability, 
%   - resilience, 
%   - vulnerability,
%   - "vul_percentage" same as above, but expressed as a percentage of threshold
%   - "failure_count" the number of failure events
%   - volumetric_reliability for demands
% In order, uses investigates are (PLEASE FILL IN)
% 1) environmental flows (ecological uses)
% 2) Chester residential demand
% 3) Baltimore residential
% 4) Peach Bottom nuclear plant
% 5) Flooding
% 6) Recreation
% 7) Hydropower

function indicators = performance(flows, reservoir)

% Local variables
T = size(flows.release, 1); % number of time steps in simulation
n = size(flows.release, 2); % number of time series

% Storing results
indicators = struct();

%% RRV indicators 

% Demands
% Ecological demand
ecological = rrv_indicators(flows.release,flows.downstream_demand,1);
% Chester residential demand
chester = rrv_indicators(flows.withdrawals(:,1),flows.local_demand(:,1),1);
% Baltimore residential demand
baltimore = rrv_indicators(flows.withdrawals(:,2),...
    flows.local_demand(:,2),1);
% Peach Bottom industrial demand
peach_bottom = rrv_indicators(flows.withdrawals(:,3),...
    flows.local_demand(:,3),1);

% Flooding
flooding = rrv_indicators((flows.release+flows.spillage)/86400, ...
    15000*ones(T,1), 0);

% Recreation
summer_levels = zeros(70*(30+31+31), n); % only keep the head levels for every summer
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
recreation = rrv_indicators(summer_levels, ...
    106.5*0.3048*ones(size(summer_levels,1),1), 1);

% Outputs for the RRV performance indicators
indicators.reliability = [ecological.reliability, chester.reliability, ...
    baltimore.reliability, peach_bottom.reliability, ...
    flooding.reliability, recreation.reliability];
indicators.resilience = [ecological.resilience, chester.resilience, ... 
    baltimore.resilience, peach_bottom.resilience, flooding.resilience,...
    recreation.resilience];
indicators.vulnerability = [ecological.vulnerability, ...
    chester.vulnerability, baltimore.vulnerability, ...
    peach_bottom.vulnerability, flooding.vulnerability, ...
    recreation.vulnerability];
indicators.vul_percentage = [ecological.vul_percentage, ...
    chester.vul_percentage, baltimore.vul_percentage, ...
    peach_bottom.vul_percentage, flooding.vul_percentage, ...
    recreation.vul_percentage];
indicators.failure_count = [ecological.failure_count, ...
    chester.failure_count, baltimore.failure_count, ...
    peach_bottom.failure_count, flooding.failure_count, ...
    recreation.failure_count];

%% Volumetric reliability for demands

indicators.volumetric_reliability = zeros(4,1);
indicators.volumetric_reliability(1) = sum(min(flows.release, ...
    flows.downstream_demand)) / sum(flows.downstream_demand);
indicators.volumetric_reliability(2) = ...
    sum(flows.withdrawals(:,1)) / sum(flows.local_demand(:,1));
indicators.volumetric_reliability(3) = ...
    sum(flows.withdrawals(:,2)) / sum(flows.local_demand(:,2));
indicators.volumetric_reliability(4) = ...
    sum(flows.withdrawals(:,3)) / sum(flows.local_demand(:,3));


%% Hydropower
% Hydropower production as a time series (in MWh; conversion needed)
indicators.hydropower = 1000*9.81*reservoir.hydropower_efficiency*...
    flows.hydraulic_head.*(flows.release/86400).*24/1E6; 

end