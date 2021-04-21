% This is part of Tutorial 2 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% This routine computes R-R-V indicators as laid out in Hashimoto et al.
% (1982)
% 
% Arguments are :
%   - a time-series "x"
%   - the threshold "th" that should not be passed (as a TIME SERIES)
%   - a binary variable "stay_above": value 0 indicates there is a
%     failure above the threshold, 1 indicates failure below the threshold
%
% Outputs are within structure indicators:
%   - "rel" (reliability), 
%   - "res" (resilience) 
%   - "vul" (vulnerability)
%   - "vul_p" same as above, but expressed as a percentage of threshold
%   - "event_count" the number of failure events

function indicators = rrv_indicators(x, th, stay_above)

% Local variable
T = length(x);
tolerance = 1E-6;  % dealing with rounding errors

% Work with violation only below threshold, if stay_above = 0 take
% opposites else take same values
a = (2 * stay_above - 1) * x;  % time series
b = (2 * stay_above - 1) * th; % threshold
b = b - tolerance;

% Reliability
rel = 1 - sum(a < b) / T; % TO COMPLETE

% Resilience and vulnerability: counting events
event_count = 0;
t = 1;
magnitude = []; % for each event, maximal failure magnitude
magnitude_f = []; % same as above, but as a fraction
while t <= T 
    
    % COMPLETE while loop to find nb of events and magnitude for 
    % each of them (several lines)
    if a(t) < b(t)  % new event!
        event_count = event_count + 1;
        magnitude(event_count) = b(t) - a(t);  % for vulnerability
        magnitude_f(event_count) = (b(t) - a(t)) / abs(b(t));
        while a(t) < b(t)  % While event lasts
            if t == T
                break
            end
            t = t + 1;
            magnitude(event_count) = max(magnitude(event_count), b(t) - a(t));
            magnitude_f(event_count) = max(magnitude_f(event_count), ...
                (b(t) - a(t)) / abs(b(t)));
        end
    end
    
    % Stopping condition (awlways crucial in while loops)
    t = t+1;
end
        
% Resilience
res = event_count / (T*(1-rel)); % TO COMPLETE

% Vulnerability
vul = mean(magnitude); % TO COMPLETE
vul_p =  mean(magnitude_f) * 100;

% Populate structure
indicators.reliability = rel;
indicators.resilience = res;
indicators.vulnerability = vul;
indicators.vul_percentage = vul_p;
indicators.failure_count = event_count;

end

