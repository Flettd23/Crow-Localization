%% Calibation
%Derek Flett
%1/23/2018

%Given the location of an audiofile of interest, find the calibration tone,
%caluclate the microphones Time Difference of Arrivals, and return an array
%with the calibration. 

%% Import Audio 
[SoundFile,PathName] = uigetfile('D:\Kraken\Crow-Localization\*.wav','Select the first file'); 
[data11,Fs] = audioread(SoundFile); 

%Section of Audio of which I am interested in looking for the Calibration
%tone
max_Time = 300*Fs; %the number of samples in 600 seconds
t_s = 1; %Start at the begining of the audio file
if data11 < max_Time
    t_e = data11;
else
    t_e = max_Time
end

data1 = data11(t_s:t_e*Fs);
L = length(data11);
t=0:1/Fs:(length(data11)-1)/Fs; % and get sampling frequency
%% Energy Sum 
tic;

%%Sum of energy Graph
timeStep = 0.2; 
steps = timeStep/(1/Fs);
Total = L-steps;
Energy = zeros(L,1);


for i = 1:Total
    Energy(i) = sum(data11(i:i+steps,2).^2);
end
toc;

[val, idx] = max(Energy);

%Plotting Energy vs Time
figure('name','Energy of Filtered Wave','numbertitle','off')
plot(t(1:L),Energy);
          xlabel('Time');
          ylabel('Energy');
          title('Energy vs Time');
% Receiver Locations


receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = 3; x_r(3) = 0.0; x_r(4) = 3;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = 3; y_r(4) = 3;
z_r(1:receivernum) = 0;



%% Calculating TDOA's
% And specify start time and end time of the sound you wish to localize. 

t_s = idx; %Start time
t_e = idx + 1000; %End time

Fmin = 500; %Minimum Frequency
Fmax = 2500; %Maximum Frequency

[data11,Fs] = audioread(sfile1); data1 = data11(t_s*Fs:t_e*Fs,channel);
[data22,Fs] = audioread(sfile2);data2 = data22(t_s*Fs:t_e*Fs,channel);
[data33,Fs] = audioread(sfile3); data3 = data33(t_s3*Fs:t_e3*Fs,channel);
[data44,Fs] = audioread(sfile4); data4 = data44(t_s*Fs:t_e*Fs,channel);

n = 7;
beginFreq = Fmin/(Fs/2);
endFreq = Fmax/(Fs/2);
[b,a] = butter(n,[beginFreq, endFreq], 'bandpass');

%Filter Signals%
data1 = filter(b, a, data1);
data2 = filter(b, a, data2);
data3 = filter(b, a, data3);
data4 = filter(b, a, data4);


L = length(data1); % length of signal in time
c = 343; % speed of sound (m/s)
NFFT = 2^nextpow2(L); % Length of the FFT
t = (0:L-1)/Fs;    % Time vector (s)

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



          