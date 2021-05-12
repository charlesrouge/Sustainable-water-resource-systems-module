% This is part of the Tutorials for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
%
% This Tutorial 4 routine plots regret. 
% 
% Arguments are:
%     - measure: an integer between 1 and 3 to tell which regret measure to
%   plot
%     - var: the Matlab array we are plotting from
%     - var_name: a string with the name of the variable given in array var
%     - objective_list: the list of objectives whose performance is being 
%   appraised

function plot_regret(measure, var, var_name, objective_list)

% Local variables
n = size(var,3);

switch measure
    case 1
    % Measure 1
    for i = 1:n
        figure
        varbis = zeros(7,4);
        for j = 1:4
            varbis(:,j) = (max(var(:,j,i)) - squeeze(var(:,j,i)))/abs(max(var(:,j,i)));
        end
        bar(0:3, varbis')
        xlabel('Levers', 'Fontsize', 14)
        ylabel(strcat('Regret measure 1: ', var_name), 'Fontsize', 14)
        title(objective_list(i), 'Fontsize', 14)
        legend('Baseline','Flow -5%','Flow -10%','Flow -15%',...
            'Flow -20%','Flow -25%','Flow -30%','Location','northwest'...
            , 'Fontsize', 14)
        ax = gca;
        ax.FontSize = 12;
    end

    case 2
    % Measure 2
    for i = 1:n
        figure
        varbis = zeros(7,4);
        for j = 1:7
            varbis(j,:) = (max(var(j,:,i)) - squeeze(var(j,:,i)))/abs(max(var(j,:,i)));
        end
        bar(0:5:30,varbis)
        xlabel('% streamflow reduction', 'Fontsize', 14)
        ylabel(strcat('Regret measure 2: ', var_name), 'Fontsize', 14)
        title(objective_list(i), 'Fontsize', 14)
        legend('No action','PB intake','Desal','Both','Location',...
            'northwest', 'Fontsize', 14)
        ax = gca;
        ax.FontSize = 12;
    end

    case 3
    % Measure 3
    for i = 1:n
        figure
        bar(0:5:30,(var(1,1,i)-squeeze(var(:,:,i)))/abs(var(1,1,i)))
        xlabel('% streamflow reduction', 'Fontsize', 14)
        ylabel(strcat('Regret measure 3: ', var_name), 'Fontsize', 14)
        title(objective_list(i), 'Fontsize', 14)
        legend('No action','PB intake','Desal','Both','Location',...
            'northwest', 'Fontsize', 14)
        ax = gca;
        ax.FontSize = 12;
    end
    
end

end