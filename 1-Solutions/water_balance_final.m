% This is part of Tutorial 1 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This routine is a basic step-by-step version of the water balance with a
% standard operating policy (SOP), assuming downstream demand have priority
% over direct withdrawals from the reservoir
%
% Contrary to the "basic" water balance, a (unique) intake position is
% defined for direct withdrawals
% 
% Arguments are the two global variables:
% reservoir characteristics "reservoir";
% "flows" structure including inflows, monthly demands, and the month index
% for each time step
%
% Outputs are an updated "flows" structure with the time series of 
% storage, release, spill and onsite withdrawals. 
% All volumes in m3.

function flows = water_balance_final(reservoir, flows)

% Local variables
T = size(flows.inflows, 1); % number of time steps in simulation
active_storage = reservoir.max_storage - reservoir.min_storage;

% Initialisation of outputs
s = zeros (T+1, 1); % storage
s(1) = reservoir.initial_storage;
r = zeros(T, 1); % release
l = zeros(T, 1); % spillage
w = zeros(T, size(flows.local_demand,2)); % withdrawals

% Main loop
for t =1:T
    
    % Water availability (beginning-of-period storage + inflows)
    wa = s(t) - reservoir.min_storage + flows.inflows(t); 
    
    % Release rule: only take what's available in the limit of downstream
    % demand
    r(t) = min(wa, flows.downstream_demand(t));
    wa = wa - r(t);  % water availability update
    
    % Head for available water
    head = reservoir.empty_head + (wa+reservoir.min_storage).^0.5 * sqrt(2*(reservoir.max_head-reservoir.empty_head)/reservoir.max_surface);
    
    % Several intake levels
    for i = 1:length(reservoir.demand_intake_level)
        if head > reservoir.demand_intake_level(i) 
            % At-site withdrawals: meet the demand (if available) or take 
            % what's left
            w(t,i) = min(wa, flows.local_demand(t,i)); 
            wa = wa - w(t,i);  % UPDATE water availability
        end % if below intake, we already have w(t) = 0
    end
    
    % Determine storage
    if wa < active_storage % reservoir can store all water available
        s(t+1) = wa + reservoir.min_storage; 
    else  % reservoir cannot, it is full 
        s(t+1) = reservoir.max_storage;
        % Now the amount (wa -reservoir.max_release) needs to be split up
        % between release and spillage (TO DO, several lines)
        r(t) = r(t) + wa - active_storage; 
        if r(t) > reservoir.max_release % need bound on release and update spillage
            l(t) = r(t) - reservoir.max_release;
            r(t) = reservoir.max_release;
        end
    end
    
end

% Populate flows structure
flows.storage_final = s;
flows.release_final = r;
flows.spillage_final = l;
flows.withdrawals_final = w;

end
