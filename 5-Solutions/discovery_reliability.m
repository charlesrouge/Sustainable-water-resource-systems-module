% This is part of the Tutorials for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2020
% 
% 2D factor mapping, defining success and failure according to a thrreshold
% Inputs
%     - x1: vector (length N) with values of first factor
%     - x2: vector (length N) with values of second factor
%     - rel: vector (length N) with output values
%     - threshold: success for output values above, failure below
%     - x1_names, x2_names: Strings with the names of the two factors
%

function discovery_reliability(x1,x2,rel,threshold,x1_names,x2_names)

N = length(x1);

% Separation of "good" and "bad" outcomes
nb_good = sum((rel>threshold));

good_coord = zeros(nb_good,2);
bad_coord = zeros(N-nb_good,2);

good_count = 0;
bad_count = 0;

for i = 1:N
    if rel(i) > threshold
        good_count = good_count + 1;
        good_coord(good_count,:) = [x1(i) x2(i)];
    else
        bad_count = bad_count + 1;
        bad_coord(bad_count,:) = [x1(i) x2(i)];
    end
end

scatter(good_coord(:,1), good_coord(:,2),'bo')
hold on
scatter(bad_coord(:,1), bad_coord(:,2),'rx')
xlabel(x1_names,'Fontsize',14)
ylabel(x2_names,'Fontsize',14)
legend('Success','Failure','Fontsize',14)
set(gca,'Xlim',[0.1*floor(min(x1)/0.1) 0.1*floor(max(x1)/0.1+1)],'Ylim',[0.1*floor(min(x2)/0.1) 0.1*floor(max(x2)/0.1+1)])

end

