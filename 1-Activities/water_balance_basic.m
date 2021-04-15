% This is part of Tutorial 1 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This routine is a basic step-by-step version of the water balance with a
% standard operating policy (SOP), assuming downstream demand have priority
% over direct withdrawals from the reservoir
% 
% Arguments are the two global variables:
% reservoir characteristics "reservoir";
% "flows" structure including inflows, monthly demands, and the month index
% for each time step
%
% Outputs are an updated "flows" structure with the time series of 
% storage, release, spill and onsite withdrawals. 
% All volumes in m3.

function flows = water_balance_basic(reservoir, flows)

% Local variables
T = size(flows.inflows, 1); % number of time steps in simulation
active_storage = reservoir.max_storage - reservoir.min_storage;

% Initialisation of outputs
s = zeros (T+1, 1); % storage
s(1) = reservoir.initial_storage;
r = zeros(T, 1); % release
l = zeros(T, 1); % spillage
w = zeros(T, 1); % withdrawals

% Main loop
for t =1:T
    
    % Water availability (beginning-of-period storage + inflows)
    wa = ; % TO COMPLETE
    
    % Release rule: only take what's available in the limit of downstream
    % demand
    r(t) = ; % TO COMPLETE
    wa = wa - r(t);  % water availability update
    
    % At-site withdrawals: meet the demand (if available) or take what's
    % left
    w(t) = ; % TO COMPLETE
    wa = ;  % UPDATE water availability
    
    % Determine storage
    if wa < reservoir.max_storage % reservoir can store all water available
        s(t+1) = ; % TO COMPLETE
    else  % reservoir cannot, it is full 
        s(t+1) = ; % TO COMPLETE
        % Now the amount (wa -reservoir.max_release) needs to be split up
        % between release and spillage (TO DO, several lines)
        ...
    end
    
end

% Populate flows structure
flows.storage_basic = s;
flows.release_basic = r;
flows.spillage_basic = l;
flows.withdrawals_basic = w;

end
