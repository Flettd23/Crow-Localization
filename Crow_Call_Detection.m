% %% ***************** Crow Auto Detection ******************
                        %Derek Flett
close all
clear all

%%%
%Import File
[FileName1,PathName] = uigetfile('C:\Kraken\Crow-Localization\*.wav','Select the first file');
[wave,fs] = audioread(FileName1); 

L = length(wave) ;
NFFT = L;

 
t=0:1/fs:(length(wave)-1)/fs; % and get sampling frequency */
F = linspace(0,fs,NFFT);
soundData(:,2) = wave(:,2);
soundData(:,1) = t;
soundDatafft = fft(wave(:,2),NFFT);

%Plotting both channels pre-filtering
figure (1)
          plot(t,wave(:,2))
          title('PreFiltered Channel One');
          ylabel('Amplitude');
          xlabel('Time (in seconds)');

               
%Filtering out anything below 500 hz and above 2000 hz (subject to change)
%Design a bandpass filter that filters out between 500 to 2000 Hz
n = 7;
beginFreq = 500 / (fs/2);
endFreq = 2500/ (fs/2);
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

% Filter the signal
fOut = filter(b, a, wave);

%Storing Filtered sound file into new array 'wave2'
wave2 = fOut;          
soundData2 = zeros(length(wave),2);
soundData2(:,2) = wave2(:,2);
soundData2(:,1) = 1:1:L;
soundData2fft = fft(wave2(:,2),NFFT);
% subplot(4,1,3)
figure (2)
          plot(t,wave2(:,1))
          title('PostFiltered Channel One');
          ylabel('Filtered Amplitude');
          xlabel('Time (in seconds)');
% 
% Nfft = 256;    win_size = 125;    ovlap = 0.90;
% [~,FFM_1,TTM_1,PM_1] = spectrogram(wave2,hanning(win_size),round(ovlap*win_size),Nfft,fs);
% imagesc(TTM_1,FFM_1(1:Nfft/2+1)/1000,10*log10(PM_1(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)          
%% *****************  Caculating and Plotting Energy  *********************

%%Sum of energy Graph
timeStep = 0.1; 
steps = timeStep/(1/fs);

%Constants to find peaks in data 
%minEnergy is the minimum energy you want a possible crow call to be detected
numCalls = 10; %Number of calls you expect to hear 
SoundDetect = zeros(numCalls,4); 
energyData = zeros(L,1);
Total = L-steps;

% progressbar % Create figure and set starting time 
for i = 1:Total
    energyData(i) = sum(wave2(i:i+steps,2).^2);
%     progressbar(i/Total)
end
%% ***************** Detecting and Saving Possible Calls*******************
%Detecting Peaks and the time they appear
minEnergy = 15;%minEnergy is the minimum energy you want a possible crow call to be detected
numCall = 70; %Number of calls you expect to encounter
SoundDetect = zeros(numCall,2);
spaceSize = 3.00; %m
maxTime = (sqrt(spaceSize.^2+spaceSize.^2))/340;  %units seconds
maxIndex = floor(maxTime*fs);
Start_Stop = zeros(numCall,2);
% TH is the discussed "Thershold", or number of sames that the energy in
% increasing,
TH = fs*0.1;


conseq = 0;
index = 1;
for i = 1:L
    if energyData(i) > minEnergy
        conseq = conseq +1;
            if conseq == 1 %Start of a possible call, having just passed the noise threshhold
                 Start_Stop(index,1) = i; %sample at which the sound occured
            end   
    else 
        if conseq > TH 
             Start_Stop(index,2) = i;
             [maxx,indx] = max(energyData(Start_Stop(index,1):Start_Stop(index,2)));
            SoundDetect(index,2) = maxx; %Energy of the sound
            SoundDetect(index,1) = indx+i-conseq-2;
            index = index + 1;
            conseq = 0;
        else 
            conseq = 0;%False detection
        end         
    end
end


%Plotting Energy vs Time
figure('name','Energy of Filtered Wave','numbertitle','off')
plot(1:L,energyData,'k');
          xlabel('Time');
          ylabel('Energy');
          title('Energy vs Time');
 hold on

 
x_axis_time = SoundDetect(:,1)*(1/fs); 
x_start_stop = Start_Stop(:,1)*(1/fs);
 for i = 1:length(SoundDetect)
     if ((SoundDetect(i,1) ~= 0) && (SoundDetect(i,2) ~= 0))
          plot(SoundDetect(i,1),SoundDetect(i,2),'b*','LineWidth',1)
          plot(Start_Stop(i,1):SoundDetect(i,1),energyData(Start_Stop(i,1):SoundDetect(i,1)),'b','LineWidth',1)
     end
 end

line([1 L],[minEnergy minEnergy],'LineWidth',1)

 hold off
 

%%
stp = Start_Stop(52,2)+2000;
y = wave2(Start_Stop(52,1):stp,1);
t=linspace(0,length(y)/fs,length(y));
Nfft = 512;
f = linspace(0,fs,Nfft);
G = abs(fft(y,Nfft));
figure(5)
subplot(3,1,1)
plot(f(1:Nfft/2),G(1:Nfft/2))
xlabel('Frequency(Hz)')
ylabel('|FFT|')
title('Element 1')
xlim([160 8000])
ylim([0 5])


Nfft = 1024;    win_size = 512;    ovlap = 0.95;
[~,FFM_1,TTM_1,PM_1] = spectrogram(y,hanning(win_size),round(ovlap*win_size),Nfft,fs);


subplot(3,1,2)
imagesc(TTM_1,FFM_1(1:Nfft/2+1),10*log10(PM_1(1:Nfft/2+1,:)));axis xy;colormap(jet)
xlabel('Time(s)')
ylabel('Frequency(Hz)')
title('Element 1')
ylim([0 8000])
colorbar;

subplot(3,1,3)
plot(y)

%%
% fileID = fopen(csv_file,'w');
% fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL,RMS\n'); %column names
% for i = 1:r %Append rows
% s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',','X',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(i)),',',string(RMS(i)),'\n');
% fprintf(fileID,s);
% end
% fclose(fileID);



 