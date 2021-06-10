%% Authors: Alissa Phutirat, Henry Tan 

% This script plots CWTs (IN PROGRESS) 
% working off the working cwt command and old code to produce a script that creates scalograms from labchart channels per trial 

clear all
close all
clc
% % %% load data

% runs successfully (BOBOLA) 
filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Data\Bobola\5-5-21 Mouse1 RECUT only channels with data\'
fileName = 'Trial 1';
% works: Trials 1,2,3 does not work: 4 

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Data\Bobola\5-5-21 MATLAB data\'
% fileName ='trial3_250mV' ;
%Works: trial 1,4 Does not work: 2

% runs successfully (EGUCHI)
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Data\Eguchi\5-18-21 MATLAB data\'
% fileName ='trail2_250mV' ;
%Works: trial 1,4 Does not work: 2

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Data\Eguchi\5-20 RECUT\'
% fileName ='Trial 7' ;
%Works: 

% load([filePath,fileName]);
load([filePath,fileName]);
% % % load 03_med_V1_US_40Hz_100_35_AD.mat
%% set parameters
%set_channels=input('Enter channels for analysis [S1 A1 V1R V1L Stim Gel ]:');% Gel is 9th item, stim is 6 for us. others are 1-4
% set_channels=[1 2 3 4 5]; % works for recut 
set_channels=[1 2 3 4 5] ;
% plot_cwt=input('Plot CWTs? Y=1 N=2 : ');
plot_cwt=1;

% set channel identities
decision = input('Do you want to manually input channels?(1 = yes, 0 = no):') ;
if decision == 1
    RS = input('What channel is right somato?:') ;
    LS = input('What channel is left somato?:') ;
    RH = input('What channel is right hippo?:') ;
    LH = input('What channel is left hippo?:'); 
    RS=set_channels(RS);LS=set_channels(LS);RH=set_channels(RH);LH=set_channels(LH);stim=set_channels(5) ; 
end 
if decision == 0  
    RS=set_channels(1);LS=set_channels(2);RH=set_channels(3);LH=set_channels(4);stim=set_channels(5) ; 
end 
% stim should always be on index 5, no matter what channel 

% S1=set_channels(1);A1=set_channels(2);V1R=set_channels(3);V1L=set_channels(4);stim=set_channels(5);
% fs = input('What is the tickrate/sampling rate?:') ;
% fs=tickrate; % tickrate is what fs in Hz is called in the data file (aka you could hard code this as fs=10000  
 %acquisition rate (Hz)
 
%Bobola Protocol sampling rate = 10k
%Eguchi Protocal sampling rate = 20k
fs=10000 ;
% fs = 20000 ;

% timeax=1:dataend(1); %set time axis

timeax=1:dataend(1); %set time axis
time=timeax/fs/60;%frames to seconds to minutes (these are the time values for each data point)
timesec=timeax./fs;
tottime=length(timeax)./fs./60; % total experiment block length in minutes 
%% Organize data into structure array
alldata=[]; %initialize structure array (alldata is a struct)

alldata.RSdata=data(datastart(RS):dataend(RS)); % Call different fields as StructName.fieldName-> Struct is alldata and field is S1dataR
alldata.LSdata=data(datastart(LS):dataend(LS));
alldata.RHdata=data(datastart(RH):dataend(RH));
alldata.LHdata=data(datastart(LH):dataend(LH));
alldata.stimdata=data(datastart(stim):dataend(stim));


% % make bipolar channels
alldata.LHRSbipolardata=alldata.LHdata-alldata.RSdata;
alldata.LHRHbipolardata=alldata.LHdata-alldata.RHdata;

names={'RSdata','LSdata','RHdata','LHdata', 'stimdata', 'LHRSbipolardata', 'LHRHbipolardata'};
%% plot raw data
figure
for i=1:length(names)
    subplot(length(names),1,i)
    plot(time,alldata.(char(names(i)))) % this is plotting time in minutes, but if you want seconds, use timesec instead of time
    title(names(i));
end
xlabel('time (minutes)')

% %%  Check frequency components of raw data 
% signal=(alldata.V1bipolardata);
% fftV1=fft(signal);
% figure
% plot(linspace(0,fs,length(fftV1)),abs(fftV1));
% xlim([0 100]);
% ylim([0 6]);
%% Filter the raw data with a lowpass butterworth filter 
%Note: it's better to filter the raw data before STAs because this limits
%the end effects that are inevitably created by the filter (you'd get end
%effects at the ends of each STA, vs end effects only at the beginning and
%end of the time series data

lowEnd = 1; % Hz
highEnd = 50; % Hz
filterOrder = 3; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd highEnd]/(fs/2)); % Generate filter coefficients

for ii=1:length(names)
filteredData.(char(names(ii))) = filtfilt(b, a,alldata.(char(names(ii)))); % Apply filter to data using zero-phase filtering
end

%% detect stimuli
index_stim=[];%initialize reference array of stimulus onsets for STAs
index_allstim=[];%secondary array of stimuli for identifying first pulse of a train. 

X=alldata.stimdata;
X=X-min(X);
X=X/max(X);
Y=X>0.5;
%Y=X>0.04;used during debugging, works as well
Z=diff(Y);
% index_allstim=find(Z>0.5);
% index_allstim=index_allstim+1;
index_allstim=find(Z>0.04);
index_allstim=index_allstim+1;
% abs(Z>

%find first pulse of each train, if stimulation contains trains
index_trains=diff(index_allstim)>20000;
index_allstim(1)=[];
index_stim=index_allstim(index_trains);


%% Create STAs
for i=1:length(names) %initiate data array to hold STAs
stas.(char(names(i)))=[];
end

tb=1; %time before stim to start STA
ta=9; %time after stim to end STA

for i=1:length(names)
    for j=2:(length(index_stim)-1) %cycle through stimuli
        stas.(char(names(i)))=[stas.(char(names(i))); filteredData.(char(names(i)))((index_stim(j)-fs*tb):(index_stim(j)+fs*ta))];
    end
end

%% plot filtered STAS
figure
x2=1:length(stas.(char(names(1)))); % make an x axis
x2=x2/fs-1; % convert x axis from samples to time 
for i=1:(length(names)-1)
    subplot(length(names)-1,1,i)
    a=median(stas.(char(names(i))));
    a=a-median(stas.(char(names(i)))(1:fs));
    a=a/100*1000;
    asmooth=smoothdata(a); % smooth the data 
    plot(x2,asmooth,'linewidth',1.5)
    ylim([-0.01 0.01])
    ylabel(names(i))
end
subplot(4,1,4)
xlabel('time after stimulus onset (s)')

%% plot filtered CWTs of STAs
ticks=[0:.005:.1];
clear yticks
clear yticklabels
if plot_cwt==1 

%     for i=1%:length(names)    
    for i=1:length(names)  
        figure
        caxis_track=[];
        %ylabels={'V1bipolar (Hz)';'S1A (Hz)';'S1V1(Hz)'; '40hzStim (Hz)'};
        xlabel('time after stimulus onset (s)');
        mediansig=median(stas.(char(names(i))));
        [minfreq,maxfreq] = cwtfreqbounds(length(mediansig),fs); %determine the bandpass bounds for the signal
        cwt(mediansig,[],fs);
        %ylabel(ylabels(i))
        colormap(jet)
        title(names(i))
        ylim([.001, .1])
        yticks(ticks)
        yticklabels({  0    5.0000   10.0000   15.0000   20.0000   25.0000   30.0000   35.0000   40.0000   45.0000   50.0000  55.0000  60})
        set(gca,'FontSize',20)
        caxis([.00008, .0002]);
        
%         pngFileName = sprintf('plot_%d.fig', i);
	%fullFileName = fullfile(folder, pngFileName);
		
	% Then save it
	%export_fig(fullFileName);
% 	   saveas(gcf, pngFileName)
	

    end
end
