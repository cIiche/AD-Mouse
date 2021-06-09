%% Authors: Alissa, Henry 

% This script plots CWTs (IN PROGRESS) 
% working off the working cwt command and old code to produce a script that creates scalograms from labchart channels per trial 

clc 
clear all

% folder= 'C:\Users\Charl\MATLAB\Mourad Lab\Mouse_EEG\Data\06-30-2020 Mouse Experiment 1\'; 
folder= 'C:\Users\Charl\MATLAB\Mourad Lab\Mouse_EEG\Data\12-23 Mouse Experiment\'; 

%Change what is in the string depending on which file/files you want to run
file_list=dir([folder 'TRIAL*.mat']);
baseline=dir([folder 'Baseline.mat']); % or baseline 1 or baseline 2 depending on trials 

% this doesnt work  
% if folder = 'C:\Users\Charl\MATLAB\Mourad Lab\Mouse_EEG\Data\12-16 Mouse Experiment\'; 
%     set_channels=[1 2 3 4 9]; % for 12/16 data?
% else: 
%     set_channels=[1 2 3 4 7]; % updated so you do not have to change last number 
% end 

set_channels=[1 2 3 4 9]; % updated so you do not have to change last number (we added code for searching for light). Change ddepending on channel in surgery notes (9?)
ch_names={'V1L','S1L','S1R', 'V1R', 'Ultrasound'}; %setting up the names that will be assigned in the matrix and the order
% trial_names={' FIRST LIGHT ONLY' 'LIGHT + US' ' SECOND LIGHT ONLY'};

%this names the channels based on where they were placed, make sure they match lab chart
V1L=set_channels(3);
S1L=set_channels(4);
S1R=set_channels(2);
V1R=set_channels(1);
lightstim=set_channels(5);
%this is important since its how the other code will find the channels.
%Everythin is coded by name so it is not hard coded in 
%';' prevents the line outcome from appearing in the terminal everytime, it just looks bad and is useless 
%create data arrays

% [wt, f] = cwt(x (input signal), 'wname'(name of wavelet used), fs(sampling frequency))
% OR 
% [wt, period] = cwt(x, 'wname', ts(sampling period)] 

% wt = cwt(x)
% wt = cwt(x,wname)
% [wt,f] = cwt(___,fs)
% [wt,period] = cwt(___,ts)
% [wt,f,coi] = cwt(___,fs)
% [wt,period,coi] = cwt(___,ts)
% [___] = cwt(___,Name,Value)
% [___,coi,fb] = cwt(___)
% [___,fb,scalingcfs] = cwt(___)
% cwt(___)

%%

% fs = input('What is the sampling rate?') ; % samples per second
fs = 44100.0 ; 
tclip = 10e-3 ; % 10mS duration of signal 
nos = fs*tclip ; % No. of smaples in 10mS 
tpoints = linspace(0,10e-3,nos) ; 
x = cos(2*pi*500*tpoints); %cos(2*pi*f*t) signal 
x(87:89) = 0; 
x(307:309) = 0; 
plot(tpoints,x) ; 
title('Signal') ;  
% plot figure 1 (signal) 
figure(1)
plot(tpoints,x) 

% getting scalogram (method 1: with COI) - COI: cone of influence: shows
% areas in scalogram that are potentially affected by edge-effect artifact 
figure(2) 
cwt(x, 'amor', seconds(1/fs)); %'morse'(default), 'amor', bump'
colormap(pink) 
title('Scalogram with COI by Method 1') ;

% getting scalogram (Method2: without COI) 
[cfs, perd] = cwt(x, 'amor', seconds(1/fs)) ;  %'morse'(default), 'amor', bump'; cfs = coefficient matrix as image
cfs = abs(cfs) ; 
figure(3) 
per = seconds(perd) ; 
pcolor(tpoints, per, cfs) % pseudocolor image 
set(gca, 'yscale','log');
shading interp 
title('Scalogram by method2') ;

% scalogram with COI and pseudocolor image 
figure(4) 
cwt(x, 'amor', seconds(1/fs)); %'morse'(default), 'amor', bump'
colormap(parula) 
title('Scalogram with COI by Method 1') ;

% Converting scalogram as RGB color image 
% scgimg = ind2rgb(im2uint8(rescale (flip(cfs))), jet(320)) ;
% imwrite(imresize(scgimg,[512,512]), 'scalogram.jpg') 
%   
%%
