clear all

[FileName1,PathName] = uigetfile('*.txt','Select the first file');
outFilePath = strcat(PathName,FileName1);
SoundData = dlmread(outFilePath);
[FileName1,PathName] = uigetfile('C:\Kraken\Crow-Localization\*.wav','Select the first file'); 
[data11,Fs] = audioread(FileName1);

t_s = round((SoundData(1,1)/Fs),2); %Start time
t_e = round((SoundData(1,2)/Fs),2); %End time
data1 = data11(t_s*Fs:t_e*Fs,2);

L = length(data1) ;
t=0:1/Fs:(length(data1)-1)/Fs;
soundData2 = zeros(length(data1),1);
soundData2(:,2) = data1(:,1).^2;
%%Sum of energy Graph
timeStep = 0.02; 
steps = timeStep/(1/Fs);
energyData = zeros(L,1);

for i = 1:L-steps
    energyData(i) = sum(soundData2(i:i+steps,2).^2);; %sum(soundData2(i:i+steps,2).^2);
end

plot(t(1:L-steps),energyData(1:L-steps));
xlabel('Time');
ylabel('Energy');
title('Energy vs Time');