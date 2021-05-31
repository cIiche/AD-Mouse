%% Authors: Alissa and Henry 

% fb = cwtfilterbank
% for n=1:4 
% fb = cwtfilterbank(Name(n),Value)

% %%
%set parameters

%%
set_channels=[1 2 3 4 6];

ch1 = input('What is channel 1? (ex. LH, RS)','s') ; 
ch2 = input('What is channel 2? (ex. LH, RS)','s') ; 
ch3 = input('What is channel 3? (ex. LH, RS)','s') ; 
ch4 = input('What is channel 4? (ex. LH, RS)','s') ; 

ch_names={ch1, ch2, ch3, ch4, 'stim'};
% on_stim=3;
% thresh=0.3;
%%
%create data arrays
for i=1:length(ch_names)-1
    peaks.(char(strcat(ch_names(i),'_med')))=[];
    peaks.(char(strcat(ch_names(i),'_iso')))=[];
    indx.(char(strcat(ch_names(i),'_med')))=[];
    indx.(char(strcat(ch_names(i),'_iso')))=[];
end

% measure each file 
for k=1:length(file_list)    
baseFileName = file_list(k).name;
  fullFileName = fullfile(folder, baseFileName);
  fprintf('Now reading %s\n', fullFileName);
    load(fullFileName)
%     Alz_EEG_FilterCWT   
end
disp('done') ;
