%% Authors: Alissa, Henry (goats) 

% This script plots CWTs (IN PROGRESS) 
% working off the working cwt command and old code to produce a script that creates scalograms from labchart channels per trial
%When cutting Voltage Data from Labchart, please cut channels 1-4, 9 or whatever
%used, as well as upsample/double check the sampling rate so that the Voltage Data
%is the same length and run correctly by MATLAB

clear all
close all
clc
% % %% load Voltage Data

%% runs successfully (BOBOLA) 
 
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Voltage Data\Bobola\4-20-21 RECUT\' 
% fileName = 'Trial 5';

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Voltage Data\Bobola\5-5-21 Mouse1 RECUT only channels with Voltage Data\'
% fileName = 'Trial 2';
% 
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Voltage Data\Bobola\5-10-21 RECUT\'
% fileName ='Trial 1' ;

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Voltage Data\Bobola\5-11-21 RECUT\'
% fileName ='Trial 4' ;


%% runs successfully (EGUCHI)

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Voltage Data\Eguchi\05-18-21 RECUT 2.0 sampling rate all 20k\' ;
% fileName ='Trial 6' ;
% 
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Voltage Data\Eguchi\5-20 RECUT\'
% fileName ='Trial 13' ;
%Works:1,2,3,4trash,5,6trash,7,8trash,9trash,10vtrash,11,12trash,13trash

%% % Load Chronic Data

% BOBOLA

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Bobola Chronic Study Day 3\Bobola m1 6_5_20\'
% fileName = 'Trial 6'
%   T1:  caxis([.00008, .0013]);, T2:  caxis([.00008, .0015]); T3,T4,T5,T6:
%   caxis([.00008, .002]); 
% 
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Bobola Chronic Study Day 3\Bobola m2 6_6_20\'
% fileName = 'Trial 2'
    % T1: caxis([.00008, .00025]); T2,T3,T4,T5,T6 caxis([.00008, .0002]);
  
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Bobola Chronic Study Day 3\Bobola m3 6_6_20\'
% fileName = 'Trial 6'
%   T1-all : caxis([.00008, .0012]); 

% EGUCHI
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Eguchi Chronic Study Day 3\Mouse 2 (was m4) 5-21-20\'
% fileName = 'Trial 3'
%   T1:  caxis([.00008, .00025]); T2:  caxis([.00008, .0003]); T3-6: caxis([.00008, .00035]);

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Eguchi Chronic Study Day 3\Mouse 3 5-21-20\'
% fileName = 'Trial 1'
%   T1-6:  caxis([.00008, .0004]);
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Eguchi Chronic Study Day 3\Eguchi actual m4 6_12_20\'
% fileName = 'Trial 2'
%   T1-all:  caxis([.00008, .00025]); 

%CHIKODI
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Chikodi Chronic Study day 3\chikodi m2 5_28_20\'
% fileName = 'Trial 5'
%   T1  caxis([.00008, .0012]); T2: caxis([.00008, .0015]); T3:
%   caxis([.00008, .002]); T4-6   caxis([.00008, .008]);

% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Chikodi Chronic Study day 3\chikodi m3 5_28_20\';
% fileName = 'Trial 6';
%   T1-6:  caxis([.00008, .0004]);
%% Verasonics Voltage Studies 
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Verasonics Voltage Trials\Bobola\10_29_21\Pento study data\';
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Verasonics Voltage Trials\Bobola\11_02_21\Pento Study Data\';
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Verasonics Voltage Trials\Bobola\11_03_21\Pento Study Data\';
% fileName = 'Pento Trial 1';
%% Verasonics Chronic Studies 
% filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Verasonics Voltage Trials\Chronic Data\Chikodi m1\'; 
% fileName = 'Trial 8'; 

filePath = 'C:\Users\Administrator\MATLAB\Projects\AD Mouse Git\Chronic Data\Eguchi Chronic Study Day 3\1_12_22 eguchi 11.9V M1 chronic day 3\';
fileName = 'Trial 1';

load([filePath,fileName]);
%% set parameters

set_channels=[1 2 3 4 5] ;

% set channel identities, stim should always be on index 5, no matter what channel 
decision = input('Do you want to manually input channels?(1 = yes, 0 = no):') ;
if decision == 1
    RS = input('What channel is right somato?:') ;
    LS = input('What channel is left somato?:') ;
    RH = input('What channel is right hippo?:') ;
    LH = input('What channel is left hippo?:'); 
    RS=set_channels(RS);LS=set_channels(LS);RH=set_channels(RH);LH=set_channels(LH);stim=set_channels(5) ; 
end 
if decision == 0  

button = input("Running data with ultrasound on?('1'= yes, '0'=no): ") ;

%% voltage data 
    % 5/5
%    RS=set_channels(4);LS=set_channels(1);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
    % 5/20
%    RS=set_channels(2);LS=set_channels(4);RH=set_channels(1);LH=set_channels(3);stim=set_channels(5) ; 
    % 5/18
%     RS=set_channels(1);LS=set_channels(3);RH=set_channels(2);LH=set_channels(4);stim=set_channels(5) ;
%% Chronic Data
%% BOBOLA 
    % 6/5/20 m1
%    RS=set_channels(1);LS=set_channels(4);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
    % 6/6/20 m2
%    RS=set_channels(2);LS=set_channels(4);RH=set_channels(1);LH=set_channels(3);stim=set_channels(5) ; 
    % 6/6/20 m3 
%    RS=set_channels(1);LS=set_channels(4);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
%% EGUCHI 
    % 5/21/20 m2, m3
%     RS=set_channels(2);LS=set_channels(3);RH=set_channels(1);LH=set_channels(4);stim=set_channels(5) ;
%    6/12/20 egu m4
%     RS=set_channels(4);LS=set_channels(1);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
%% CHIKODI 
    % 5/28/20 m2,m3
%    RS=set_channels(4);LS=set_channels(1);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
%% Verasonics Voltage Studies 
% bobola 
% 11/3/21 
%    RS=set_channels(1);LS=set_channels(4);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
% 11/2/21
%      RS=set_channels(4);LS=set_channels(3);RH=set_channels(2);LH=set_channels(1);stim=set_channels(5) ;
% 10/29/21 
%   RS=set_channels(4);LS=set_channels(1);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
%% Verasonics Chronic Studies
% Chikodi m1
%     RS=set_channels(1);LS=set_channels(3);RH=set_channels(2);LH=set_channels(4);stim=set_channels(5) ;
%eguchi 11.9V 
% 1/12/22 m1 
    RS=set_channels(4);LS=set_channels(1);RH=set_channels(2);LH=set_channels(3);stim=set_channels(5) ;
% m2 
% 1/35/22 
end 
somato_or_motor = input("Are eCoG's implanted in somatosenories or motor cortices? ('1'=somato, '2'= motor cortices): "); 

%% Set sampling rate
% fs = input('What is the tickrate/sampling rate?:') ;
%Bobola Protocol sampling rate = 10k
fs=10000 ;
%Eguchi Protocal sampling rate = 20k
%  fs = 20000 ;

%%
timeax=1:dataend(1); %set time axis
time=timeax/fs/60;%frames to seconds to minutes (these are the time values for each data point)
timesec=timeax./fs;
tottime=length(timeax)./fs./60; % total experiment block length in minutes 

%% Organize data into structure array

alldata=[]; %initialize structure array (alldata is a struct)
% Call different fields as StructName.fieldName-> Struct is alldata and field is S1dataR
if somato_or_motor == 1 
    
    alldata.RSdata=data(datastart(RS):dataend(RS)); 
    alldata.LSdata=data(datastart(LS):dataend(LS));
    alldata.RHdata=data(datastart(RH):dataend(RH));
    alldata.LHdata=data(datastart(LH):dataend(LH));
    alldata.stimdata=data(datastart(stim):dataend(stim));
    % % make bipolar channels
    alldata.LHRSbipolardata=alldata.LHdata-alldata.RSdata;
    alldata.LHRHbipolardata=alldata.LHdata-alldata.RHdata;
    names={'RSdata','LSdata','RHdata','LHdata', 'stimdata', 'LHRSbipolardata', 'LHRHbipolardata'};
elseif somato_or_motor == 2 
    alldata.RMdata=data(datastart(RS):dataend(RS)); 
    alldata.LMdata=data(datastart(LS):dataend(LS));
    alldata.RHdata=data(datastart(RH):dataend(RH));
    alldata.LHdata=data(datastart(LH):dataend(LH));
    % % make bipolar channels
    alldata.LHRMbipolardata=alldata.LHdata-alldata.RMdata;
    alldata.LHRHbipolardata=alldata.LHdata-alldata.RHdata;
    alldata.stimdata=data(datastart(stim):dataend(stim));
    names={'RMdata','LMdata','RHdata','LHdata', 'stimdata', 'LHRMbipolardata', 'LHRHbipolardata'};
end 

% names={'RSdata','LSdata','RHdata','LHdata', 'stimdata', 'LHRSbipolardata', 'LHRHbipolardata'};

%% plot raw data
figure
for i=1:length(names)
    subplot(length(names),1,i)
    % only for 5/18 eguchi data lightstim data is too long
%     if i == 5
%         alldata.stimdata(3280001:6560000) = [] ;
%     end 
    plot(time,alldata.(char(names(i)))) % this is plotting time in minutes, but if you want seconds, use timesec instead of time
    title(names(i));
end
xlabel('time (minutes)')

% %%  Check frequency components of raw data 
% signal=(alldata.LHRSbipolardata);
% fftV1=fft(signal);
% figure
% plot(linspace(0,fs,length(fftV1)),abs(fftV1));
% xlim([0 100]);
% ylim([0 6]);
%% Filter the raw data with a lowpass butterworth filter 
%Note: it's better to filter the raw data before STAs because this limits
% %the end effects that are inevitably created by the filter (you'd get end
%effects at the ends of each STA, vs end effects only at the beginning and
%end of the time series data

% lowEnd = 1; % Hz
% highEnd = 50; % Hz
lowEnd = 2; % Hz
highEnd = 100; % Hz
filterOrder = 3; % Filter order (e.g., 2 for a second-order Butterworth filter). Try other values too
[b, a] = butter(filterOrder, [lowEnd highEnd]/(fs/2)); % Generate filter coefficients
% [b, a] = butter(filterOrder, [lowEnd highEnd]/(fs/4)); % Generate filter coefficients

for ii=1:length(names)
filteredData.(char(names(ii))) = filtfilt(b, a,alldata.(char(names(ii)))); % Apply filter to data using zero-phase filtering
end

%% detect stimuli
if button == 1 
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
elseif button == 0
    % 10/29/21 
%     index_stim = [129405,229405,329405,429405,529405,629405,729405,829405,929405,1029405,1129405,1229405,1329405,1429405,1529405,1629405,1729405,1829405,1929405,2029405,2129405,2229405,2329405,2429405,2529405,2629405,2729405,2829405,2929405,3029405,3129405,3229405,3329405,3429405,3529405,3629405,3729405,3829405,3929405,4029405,4129405,4229405,4329405,4429405,4529405,4629405];
%     index_stim = [129405,229405,329405,429405,529405,629405,729405,829405,929405,1029405,1129405];

index_stim = [];%initialize reference array of stimulus onsets for STAs
index_allstim = [];%secondary array of stimuli for identifying first pulse of a train. 
train_length = int(length(alldata.(char(names(1))))/(3423.2));
    train_length = length(alldata.(char(names(1))))/(2000);
artificial_train = zeros(1,train_length);
for k = 1:length(alldata.(char(names(1)))/100)
    artificial_train(60*k)=1;
end
index_allstim(1)=[];
index_stim=index_allstim(artificial_train);

end
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
% maybe works for axis 5,10,15...
% ticks=[0:.005:.1];
% maybe works for 1,2,3.... Hz 
ticks=[0:.001:.1];
% works for axis 10, 20, 40-80
% ticks=[0:0.01:.1];
clear yticks
clear yticklabels


% filterbank initialization
% fb = cwtfilterbank('WaveletParameters',[2,5]);

    for i=1:length(names)    
%     for i=1:length(names)  
        figure
        caxis_track=[];
        %ylabels={'V1bipolar (Hz)';'S1A (Hz)';'S1V1(Hz)'; '40hzStim (Hz)'};
        xlabel('time after stimulus onset (s)');
        mediansig=median(stas.(char(names(i))));
        [minfreq,maxfreq] = cwtfreqbounds(length(mediansig),fs); %determine the bandpass bounds for the signal
        cwt(mediansig,[],fs);
%         cwt(mediansig,fb,fs)
        ylabel('Frequency (Hz)')
        colormap(jet)
        title(names(i))
%         ylim([.001, .1])
        ylim([.001, .06])
        yticks(ticks)
        % works with ticks=[0:.005:.1];
%         yticklabels({  0    5.0000   10.0000   15.0000   20.0000   25.0000   30.0000   35.0000   40.0000   45.0000   50.0000  55.0000  60})
        % works with [0:.01:.1];
%         yticklabels({  0 10.0000 20.0000 30.0000 40.0000 50.0000 60})
%         yticklabels({  0 10.0000 20.0000 30.0000 40.0000 50.0000 60.0000 70.0000 80})
        % works with [0:.0005:.1]
%         axisnumbers = [0:1.0000:60.0000];
%         axisstring = string(axisnumbers) ; 
        yticklabels({  0 1.0000 2.0000 3.0000 4.0000 5.0000 6.0000 7.0000 8.0000 9.0000 10.0000 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 20.0000 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 30 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 40 ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' ' 50})
%         yticklabels(axisstring) 
        
%         set(gca,'XTick',[0,1,2,3,4,5,6,7,8,9,10], 'YTick', [0,1,2,3,4,5,6,7,8,9,10, 20, 30, 40, 50, 60, 70, 80])

%         set(gca,'ytick', [0,1,2,3,4,5,6,7,8,9,10,20,30,40,50,60], 'yticklabel', {'0','1','2','3','4','5','6','7','8','9','10','20','30','40','50','60'})
%         set(gca,'FontSize',15)

%         caxis([.00008, .00040]);
% caxis([.00008, .00035])
% caxis([.0000, .0001]); 
% caxis([.0000, .0006]); 
caxis([.0000, .0005])


%         pngFileName = sprintf('plot_%d.fig', i);
	%fullFileName = fullfile(folder, pngFileName);
		
	% Then save it
	%export_fig(fullFileName);
% 	   saveas(gcf, pngFileName)
	

    end

    % this is for creating RMS values for this given filename (IN PROGRESS)
    
% all_points(1).name=names(1);
% d=stas.(char(names(1)));
% 
%    for k=1:10
%        concat=['RMSvals_' num2str(k)];
% %        all_points(1).(concat)=rms(alldata.(char(names))(:,fs*(tb+k-1):fs*(tb+k))');
%        all_points(1).(concat)=rms(d(:,fs*(tb+k-1):fs*(tb+k))');
%    end 