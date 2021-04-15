% This is part of Tutorial 1 for CIV 4782-6782 at the U. of Sheffield
% by Charles Rougé, Spring 2020
% 
% This routine is to visualise the relationship between hydraulic head,
% lake area and reservoir storage according to our assumptions for
% Conowingo dam

%% Prepare workspace
clear all
clc

%% Data retrieval

% Read key data
key_data = xlsread('Conowingo data.xlsx', 'Reservoir characteristics', ... 
    'F4:H6');

% Full reservoir data 
full_head = key_data(1, 1); 
full_surface = key_data(1, 2);
full_volume = key_data(1, 3);

% Empty reservoir data
empty_head = key_data(3, 1); 
empty_surface = key_data(3, 2);
empty_volume = key_data(3, 3);

%% Construct area and volume vectors 
% (corresponding to 100 uniformly distributed data points for hydraulic
% head)

% hydraulic head
h = (empty_head : (full_head-empty_head)/99 : full_head); % unit: m

% Initialise area and volume
a = zeros(100,1); % unit: ha
v = zeros(100,1); % unit: hm3

% Fill in area vector using assumption line 8 (or formula in G5)
a = (full_surface - empty_surface) / (full_head - empty_head) * (h - empty_head);  % TO COMPLETE

% Fill in volume vector using assumption line 9 (or formula in H5)
v = (a - empty_surface).* ((h - empty_head) / 2) / 100; % TO COMPLETE (beware the units)
% A hm3 is 1E6 m3 and 1 ha = 1E4 m2, which explains the conversion factor of 100

%% Plot results

figure
plot(h, a)
title('Head-area relationship')
xlabel('Head (m)')
ylabel('Lake area (ha)')

figure
plot(h,v)
title('Head-volume relationship')
xlabel('Head (m)')
ylabel('Volume (hm3)')

figure
plot(a,v)
title('Area-volume relationship')
xlabel('Area (ha)')
ylabel('Volume (hm3)')







