function [TimeMat] = Crow_2D_LocalizationPrelim(sfile1, sfile2, sfile3, sfile4, ts, te, channel, hypplot, elementspacing)
% clear all;
% close all;
hyp_plot = hypplot;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%-----------------------Crow_2D_LocalizationPrelim---------------------------------
% This function attempts to locate a crow within an array of 4 microphones. 
% INPUTS: - sfile1, sfile2, sfile3, sfile4, t_s, t_e, channel, hypplot
%           The four sound files and the start and end time of the call
%           attempting to be localized, as well as the channel on the
%           reciever and whether or not to make plots. 
%
%         - hyp_plot: a switch to plot the hyperbolas calculated or not. true
%                     plots the hyperbolas, false does not plot. If the funciton is
%                     called without these values specified, the default is
%                     set to true
%                     and can be changed below.
%
% OUTPUTS: -TimeMat: A matrix containing time corrections for each
% hyperbola to account for the fact that the GPS devices in the microphone
% receivers are not exactly synchronized. This is used by the primary
% localization function, Crow_2D_Localization. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Receiver Locations


receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = elementspacing; x_r(3) = 0.0; x_r(4) = elementspacing;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = elementspacing; y_r(4) = elementspacing;
z_r(1:receivernum) = 0;



%% Read File %%
% Read the file
% And specify start time and end time of the sound you wish to localize. 

t_s = ts; %Start time
t_e = te; %End time
Fmin = 500; %Minimum Frequency
Fmax = 2500; %Maximum Frequency

[data11,Fs] = audioread(sfile1); data11_av = (data11(:,1)+data11(:,2))/2;
[data22,Fs] = audioread(sfile2); data22_av = (data22(:,1)+data22(:,2))/2;
[data33,Fs] = audioread(sfile3); data33_av = (data33(:,1)+data33(:,2))/2;
[data44,Fs] = audioread(sfile4); data44_av = (data44(:,1)+data44(:,2))/2;

% n = 7;
% beginFreq = Fmin/(Fs/2);
% endFreq = Fmax/(Fs/2);
% [b,a] = butter(n,[beginFreq, endFreq], 'bandpass');

% %Filter Signals%
% data11_fil = filter(b, a, data11_av);
% data22_fil = filter(b, a, data22_av);
% data33_fil = filter(b, a, data33_av);
% data44_fil = filter(b, a, data44_av);

data1 = data11_av(t_s*Fs:t_e*Fs);
data2 = data22_av(t_s*Fs:t_e*Fs);
data3 = data33_av(t_s*Fs:t_e*Fs);
data4 = data44_av(t_s*Fs:t_e*Fs);


L = length(data1); % length of signal in time
c = 343; % speed of sound (m/s)
NFFT = 2^nextpow2(L); % Length of the FFT
t = (0:L-1)/Fs;    % Time vector (s)
F = ((0:NFFT-1)/(NFFT))*Fs;   % Frequency vector (Hz)
k = 2*pi*F/c;                 % Wave number

% %% Plot Spectrogram
% if hyp_plot ==true
% Nfft = 256;    win_size = 125;    ovlap = 0.90;
% [~,FFM_1,TTM_1,PM_1] = spectrogram(data1,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% [~,FFM_2,TTM_2,PM_2] = spectrogram(data2,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% [~,FFM_3,TTM_3,PM_3] = spectrogram(data3,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% [~,FFM_4,TTM_4,PM_4] = spectrogram(data4,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
% 
% figure(6)
% subplot(4,1,1)
% imagesc(TTM_1,FFM_1(1:Nfft/2+1)/1000,10*log10(PM_1(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% subplot(4,1,2)
% imagesc(TTM_2,FFM_2(1:Nfft/2+1)/1000,10*log10(PM_2(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% subplot(4,1,3)
% imagesc(TTM_3,FFM_3(1:Nfft/2+1)/1000,10*log10(PM_3(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% subplot(4,1,4)
% imagesc(TTM_4,FFM_4(1:Nfft/2+1)/1000,10*log10(PM_4(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
% xlabel('Time(s)')
% ylabel('Frequency(kHz)')
% title('Element 1')
% else
% end
%%
[~,Imin] = min(abs(F-Fmin));                                               % Minimum Frequency Index
[~,Imax] = min(abs(F-Fmax));                                               % Maximum Frequency Index

%If the funciton was called without a value for 'hyp_plot', the default
%is set to true (yes plots)
% if ~exist('hyp_plot', 'var')
%     hyp_plot = true;
% end

%*********************** Signal to Noise Ratio ********************
% 
% for i = Imin:Imax
% 
%     p_av(i) = sum((abs(p(i,1:receivernum))).^2);
% 
%     n_av(i) = sum((abs(Noise(i,1:receivernum))).^2);
% 
% end
% 
% p_sum = sum(p_av); 
% 
% n_sum = sum(abs(n_av) );
% 
% SNR = 10*log10(p_sum/n_sum);


%% ********************* Localization ***********************
% ************************* CROSS CORRELATION *****************************
x_grid = (-1:0.001:2);
y_grid = (-1:0.001:2);

cor_12 = xcorr(data1,data2,'coef');
cor_13 = xcorr(data1,data3,'coef');
cor_14 = xcorr(data1,data4,'coef');
cor_34 = xcorr(data3,data4,'coef');
cor_24 = xcorr(data2,data4, 'coeff');
cor_23 = xcorr(data2,data3, 'coeff');

[~, max_ind_12] = max(cor_12);
[~, max_ind_13] = max(cor_13);
[~, max_ind_14] = max(cor_14);
[~, max_ind_34] = max(cor_34);
[~, max_ind_24] = max(cor_24);
[~, max_ind_23] = max(cor_23);

t_max_12 = 0;
t_max_13 = 0;
t_max_14 = 0;
t_max_34 = 0;
t_max_24 = 0;
t_max_23 = 0;
% time delay between element 1 and 2
if max_ind_12 >= L  
    t_max_12 = t(max_ind_12-L+1); 
else
    t_max_12 = -t(L-max_ind_12+1);
end

% time delay between element 1 and 3
if max_ind_13 >= L
       t_max_13 = t(max_ind_13-L+1); 
else
    t_max_13 = -t(L-max_ind_13+1);
end   

% time delay between element 1 and 4
if max_ind_14 >= L    
    t_max_14 = t(max_ind_14-L+1); 
else
    t_max_14 = -t(L-max_ind_14+1);
end   

% time delay between element 3 and 2

if max_ind_34 >= L    
    t_max_34 = t(max_ind_34-L+1); 
else
    t_max_34 = -t(L-max_ind_34+1);
end   

% time delay between element 2 and 4
if max_ind_24 >= L    
    t_max_24 = t(max_ind_24-L+1);
else
    t_max_24 = -t(L-max_ind_24+1);
end

% time delay between element 2 and 3
if max_ind_23 >= L    
    t_max_23 = t(max_ind_23-L+1); 
else
    t_max_23 = -t(L-max_ind_23+1);
end   

TimeMat = [t_max_12, t_max_13, t_max_14, t_max_34, t_max_24, t_max_23];


