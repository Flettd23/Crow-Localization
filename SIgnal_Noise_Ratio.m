clear all;

%% Read File %%
% Read the file
% And specify start time and end time of the sound you wish to localize. 
Signal_Noise = zeros(9,1);
% TSE = zeros(9,2);
% TSE(1,:) = [355.2,355.5];
% TSE(2,:) = [400.1,400.4];
% TSE(3,:) = [445.2,445.5];
% TSE(4,:) = [491.05,491.35];
% TSE(5,:) = [272.4,272.7];
% TSE(6,:) = [536.0,536.3];
% TSE(7,:) = [581.7,582.0];
% TSE(8,:) = [627.3,627.6];
% TSE(9,:) = [672.1,672.4];
% 
% TSE_N(:,:) = TSE + [1.0,1.0];

 TSE = zeros(3,2);
TSE(1,:) = [26.85,27.2];
TSE(2,:) = [87.45,87.75];
TSE(3,:) = [140.85,141.2];


TSE_N(:,:) = TSE + [1.0,1.0];
% TSE(1,:) = [355,356];
% TSE(2,:) = [400,401];
% TSE(3,:) = [445,446];
% TSE(4,:) = [491,492];
% TSE(5,:) = [272,273];
% TSE(6,:) = [536,537];
% TSE(7,:) = [581,582];
% TSE(8,:) = [627,628];
% TSE(9,:) = [672,673];
% 
% TSE_N(:,:) = TSE + [1,1];

% t_s = 355.2; %Start time
% t_e = t_s + 0.3; %End time
% t_s_Noise = t_s + 0.3;
% t_e_Noise = t_e + 0.3; 

[FileName1,PathName] = uigetfile('D:\Kraken\Crow-Localization\*.wav','Select the first file');
[data11,Fs] = audioread(FileName1);
for i=1:3
NoisySignal = data11(floor(TSE(i,1)*Fs):floor(TSE_N(i,2)*Fs),1);
[data12,Fs] = audioread(FileName1); 
Noise = data11(floor(TSE_N(i,1)*Fs):floor(TSE_N(i,2)*Fs),1);

n = 7;
beginFreq = 500/(Fs/2);
endFreq = 2500/(Fs/2);
[b,a] = butter(n,[beginFreq, endFreq], 'bandpass');
[d,c] = butter(n,[beginFreq, endFreq], 'bandpass');

%Filter Signals%
ReducedNoiseSignal = filter(b, a, NoisySignal);

ReducedNoiseNoise = filter(b, a, Noise);

SNR_PostFilter = sum( ReducedNoiseSignal .^ 2 ) / sum(  ReducedNoiseNoise .^ 2 ); 

SNR_PostFilter_dB = 10 * log10( SNR_PostFilter ); % in dB

Signal_Noise(i,1) = SNR_PostFilter_dB;

end

disp(Signal_Noise)