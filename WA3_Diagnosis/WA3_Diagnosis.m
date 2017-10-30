clear all;

receivernum = 4; % Number of Recorders
x_r(1) = 0; x_r(2) = 3; x_r(3) = 0.0; x_r(4) = 3;
y_r(1) = 0; y_r(2) = 0.0; y_r(3) = 3; y_r(4) = 3;
z_r(1:receivernum) = 0;

%% Read File %%
% Read the file
% And specify start time and end time of the sound you wish to localize. 
%% DIfferent Calls 

%3m

% % WA3 GPS2
% t_s = 26.85; %Start time
% t_e = 27.2; %End time

% % WA3 GPS3
% t_s = 32.8; %Start time
% t_e = 33.2; %End time

%2m

% % WA3 GPS2
% t_s = 87.45; %Start time
% t_e = 87.75; %End time
% 
% % WA3 GPS3
% t_s = 109.8; %Start time
% t_e = 110.15; %End time

%1m
% 
% % WA3 GPS2
% t_s = 140.85; %Start time
% t_e = 141.2; %End time

%WA3 GPS3
t_s = 172.4; %Start time
t_e = 172.7; %End time


[FileName1,PathName] = uigetfile('C:\Kraken\Crow-Localization\*.wav','Select the first file'); 
[data33,Fs] = audioread(FileName1);
data3 = data33(floor(t_s*Fs):floor(t_e*Fs),1);
[FileName2,PathName] = uigetfile('C:\Kraken\Crow-Localization\*.wav','Select the first file'); 
[data44,Fs] = audioread(FileName2);
data4 = data44(floor(t_s*Fs):floor(t_e*Fs),2);

n = 7;
beginFreq = 500/(Fs/2);
endFreq = 2500/(Fs/2);
[b,a] = butter(n,[beginFreq, endFreq], 'bandpass');

%Filter Signals%
data3 = filter(b, a, data3);
data4 = filter(b, a, data4);


L = length(data3); % length of signal in time
c = 343; % speed of sound (m/s)
NFFT = 2^nextpow2(L); % Length of the FFT
t = (0:L-1)/Fs;    % Time vector (s)
F = ((0:NFFT-1)/(NFFT))*Fs;   % Frequency vector (Hz)
k = 2*pi*F/c;                 % Wave number

%%
Fmin = 500;                                                               % Minimum Frequency (Hz)
Fmax = 2500;                                                               % Maximum Frequency (Hz)
[~,Imin] = min(abs(F-Fmin));                                               % Minimum Frequency Index
[~,Imax] = min(abs(F-Fmax));                                               % Maximum Frequency Index


%% ********************* Localization ***********************
% ************************* CROSS CORRELATION *****************************
x_grid = (-1:0.001:2);
y_grid = (-1:0.001:2);

cor_34 = xcorr(data3,data4,'coef');

[~, max_ind_34] = max(cor_34);

if max_ind_34 >= L  
    t_max_34 = t(max_ind_34-L+1);
else
    t_max_34 = -t(L-max_ind_34+1);
end
disp(t_max_34)
plot(cor_34)

% 
% point_num = 1000;
% 
% a_34 = abs(t_max_34)*c/2;
% c_34 =  sqrt((x_r(3)-x_r(4))^2+(y_r(3)-y_r(4))^2+(z_r(3)-z_r(4))^2); 
% b_34 = sqrt(c_34^2-a_34^2);
% x_mid_34 = (x_r(3)+x_r(4))/2;
% y_mid_34 = (y_r(3)+y_r(4))/2;
% [h_34(1,:), h_34(2,:)] = hyperbola_points(a_34, b_34, x_mid_34, y_mid_34, x_r(1)-5, x_r(4)+5, y_r(1)-5, y_r(4)+5, point_num, 1);
