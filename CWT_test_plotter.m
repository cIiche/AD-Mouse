%% Authors: Alissa, Henry 

% This script plots CWTs 

clc 
clear all

% [wt, f] = cwt(x (input signal), 'wname'(name of wavelet used), fs(sampling frequency))
% OR 
% [wt, period] = cwt(x, 'wname', ts(sampling period)] 

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
cwt(x,'morse',seconds(1/fs)); %'morse'(default), 'amor', bump'
colormap(parula) 
title('Scalogram with COI by Method 1') ;

% Converting scalogram as RGB color image 
% scgimg = ind2rgb(im2uint8(rescale (flip(cfs))), jet(320)) ;
% imwrite(imresize(scgimg,[512,512]), 'scalogram.jpg') 
%   