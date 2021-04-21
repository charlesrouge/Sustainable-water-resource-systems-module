% This is part of Tutorial 3 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2021
% 
% Running this assumes you have run the NSGA2 algorithm from main_script.m
% and that you have not cleaned the work space ( not used the "clear" 
% command). 
%
% IMPORTANT Put this in the main directory of the M3O toolbox
%

%% Exploit results

% Best policy for flood control across the Pareto front (minimises average flood levels)
[m, I] = min(JJ_emodps(:,1));
policy.theta = Popt(I,:);
[Jflo, Jirr, h1, u, r1, g_flo, g_irr] = simLake(sys_param.simulation.q, 0.6, policy );

% Best policy for water supply across the Pareto front (minimises average supply deficit)
[m, I] = min(JJ_emodps(:,2));
policy.theta = Popt(I,:);
[Jflo, Jirr, h2, u, r2, g_flo, g_irr] = simLake(sys_param.simulation.q, 0.6, policy );

% Closest (least-square sense) solution to the mean
ls = (JJ_emodps(:,1)- mean(JJ_emodps(:,1))).^2 + (JJ_emodps(:,2)- mean(JJ_emodps(:,2))).^2;
[m, I] = min(ls);
policy.theta = Popt(I,:);
[Jflo, Jirr, h3, u, r3, g_flo, g_irr] = simLake(sys_param.simulation.q, 0.6, policy );

figure
hold on
plot(sys_param.simulation.q,':k')%, 'Linewidth', 2)
plot(r1,'r')
plot(r2,'b')
plot(r3,'y')
legend('Inflows','Flood protection','Water supply','Compromise')
xlabel('Time (days)')
ylabel('Release (m3/s)')
set(gca,'Xlim',[1 731])

figure
hold on
plot(h1,'r')
plot(h2,'b')
plot(h3,'y')
legend('Flood protection','Water supply','Compromise')
xlabel('Time (days)')
ylabel('Water level (m)')
set(gca,'Xlim',[1 731])

figure
hold on
scatter(h1, r1,'r')
scatter(h2, r2,'b')
scatter(h3, r3,'y')
legend('Flood protection','Water supply','Compromise')
xlabel('Water level (m)')
ylabel('Release (m3/s)')


