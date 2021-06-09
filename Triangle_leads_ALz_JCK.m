clear all
close all
clc
% % %% load data

filePath = 'C:\Users\aliss\Documents\MATLAB\AD project\AD data\5.5.21\'
fileName = 'trial1_200mV.mat';

load([filePath,fileName]);

% % % load 03_med_V1_US_40Hz_100_35_AD.mat
%% set parameters
%set_channels=input('Enter channels for analysis [S1 A1 V1R V1L Stim Gel ]:');% Gel is 9th item, stim is 6 for us. others are 1-4
set_channels=[1 2 3 4 6];
%plot_cwt=input('Plot CWTs? Y=1 N=2 :');
plot_cwt=1;
S1=set_channels(1);A1=set_channels(2);V1R=set_channels(3);V1L=set_channels(4);stim=set_channels(5);% set channel identities
fs=tickrate; % tickrate is what fs in Hz is called in the data file (aka you could hard code this as fs=10000  
 %acquisition rate (Hz)
timeax=1:dataend(1); %set time axis
time=timeax/fs/60;%frames to seconds to minutes (these are the time values for each data point)
timesec=timeax./fs;
tottime=length(timeax)./fs./60; % total experiment block length in minutes 
%% Organize data into structure array
alldata=[]; %initialize structure array (alldata is a struct)
alldata.S1data=data(datastart(S1):dataend(S1)); % Call different fields as StructName.fieldName-> Struct is alldata and field is S1dataR
alldata.A1data=data(datastart(A1):dataend(A1));
alldata.V1Rdata=data(datastart(V1R):dataend(V1R));
alldata.V1Ldata=data(datastart(V1L):dataend(V1L));
%alldata.geldata=data(datastart(gel):dataend(gel));
alldata.stimdata=data(datastart(stim):dataend(stim));

% make bipolar channels
alldata.V1bipolardata=alldata.V1Rdata-alldata.V1Ldata; % make V1 bipolar by subtracting right from left to get rid of common noise
alldata.S1V1Lbipolardata=alldata.S1data-alldata.V1Ldata; % make a bipolar channel between S1 and A1 
alldata.A1V1Lbipolardata=alldata.A1data-alldata.V1Ldata; % Make a bipolar channel between S1 and V1
alldata.S1V1Rbipolardata=alldata.S1data-alldata.V1Rdata;
alldata.S1A1bipolardata=alldata.S1data-alldata.A1data;
alldata.A1V1Rbipolardata=alldata.A1data-alldata.V1Rdata;
names={'V1bipolardata','A1V1Lbipolardata','A1V1Rbipolardata','stimdata'};
%names={'V1bipolardata','S1V1Lbipolardata','S1V1Rbipolardata','S1A1bipolardata','A1V1Lbipolardata','A1V1Rbipolardata','stimdata'}; %stimdata is just the 40hz input signal.  It is a positive control for what pure 40hz looks like, and negative control for brain activity

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
%Y=X>0.5;
Y=X>0.04;
Z=diff(Y);
%index_allstim=find(Z>0.5);index_allstim=index_allstim+1;
index_allstim=find(Z>0.04);index_allstim=index_allstim+1;


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

    for i=1%:length(names)       
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
        
        pngFileName = sprintf('plot_%d.fig', i);
	%fullFileName = fullfile(folder, pngFileName);
		
	% Then save it
	%export_fig(fullFileName);
	   saveas(gcf, pngFileName)
	

    end
end