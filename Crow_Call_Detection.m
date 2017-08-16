%Testing User Interface code Example

%% ***************** Crow Auto Detection ******************
                        %Derek Flett
close all
clear all


%Import File
[FileName1,PathName] = uigetfile('*.wav','Select the first file'); 
[wave,fs] = audioread(FileName1); 
L = length(wave) ;
NFFT = L;

%Uncomment to play unfiltered sound

% pOrig = audioplayer(wave,fs);
% pOrig.play;

t=0:1/fs:(length(wave)-1)/fs; % and get sampling frequency */
F = linspace(0,fs,NFFT);
soundData(:,2) = wave(:,2);
soundData(:,1) = t;
soundDatafft = fft(wave(:,2),NFFT);
%Plotting both channels pre-filtering
figure('name','Pre and Post Filterd Sound','numbertitle','off')
subplot(4,1,1)
          plot(t,wave(:,2))
          title('PreFiltered Channel One');
          ylabel('Amplitude');
          xlabel('Time (in seconds)');
          
subplot(4,1,2)
          plot(F(1:NFFT/2+1),abs(soundDatafft(1:NFFT/2+1,1)))
          title('PreFiltered FFT');
          ylabel('Spectrum');
          xlabel('Freq (in Hz)');
          
         
          
%Filtering out anything below 500 hz and above 2000 hz (subject to change)
%Design a bandpass filter that filters out between 500 to 2000 Hz
n = 7;
beginFreq = 500 / (fs/2);
endFreq = 2000 / (fs/2);
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

% Filter the signal
fOut = filter(b, a, wave);

%Uncomment to play the filtered sound clip

% p = audioplayer(fOut,fs);
% p.play;

%Storing Filtered sound file into new array 'wave2'
wave2 = fOut;
soundData2 = zeros(length(wave),2);
soundData2(:,2) = wave2(:,2);
soundData2fft = fft(wave2(:,2),NFFT);
subplot(4,1,3)
          plot(t,wave2(:,1))
          title('PostFiltered Channel One');
          ylabel('Filtered Amplitude');
          xlabel('Time (in seconds)');
subplot(4,1,4)
          plot(F(1:NFFT/2+1),abs(soundData2fft(1:NFFT/2+1,1)))
          title('PostFiltered FFT');
          ylabel('Filtered Spectrum');
          xlabel('Freq (in Hz)');

          
%% *****************  Caculating and Plotting Energy  *********************
tic;
soundData2(:,2) = wave2(:,2).^2;
%%Sum of energy Graph
timeStep = 0.2; 
steps = timeStep/(1/fs);

%Constants to find peaks in data 
%minEnergy is the minimum energy you want a possible crow call to be detected
numCalls = 10; %Number of calls you expect to hear 
callStart = zeros(numCalls,1); 
energyData = zeros(L,1);
for i = 1:L-steps
    energyData(i) = sum(wave2(i:i+steps,2).^2);
end
toc;

%Plotting Energy vs Time
figure('name','Energy of Filtered Wave','numbertitle','off')
plot(t(1:L),energyData);
          xlabel('Time');
          ylabel('Energy');
          title('Energy vs Time');
 hold on

          

%% ***************** Detecting and Saving Possible Calls*******************


%Detecting Peaks and the time they appear
minEnergy = 15;%minEnergy is the minimum energy you want a possible crow call to be detected
numCall = 50; %Number of calls you expect to encounter
CallStart = zeros(numCall,2);
ind = 1;
max = 0;
for i = 1:L
    if energyData(i) > minEnergy
        if energyData(i+1)> minEnergy %Causes problems if call is close to the min energy level 
            if energyData(i) > max 
                max = energyData(i);
                CallStart(ind,2) = energyData(i);
                CallStart(ind,1) = i*(1/fs);
            end
        else   
       ind = ind + 1;
        max = 0;
        end
    end
end

 for i = 1:length(CallStart)
     if ((CallStart(i,1) ~= 0) && (CallStart(i,2) ~= 0))
          plot(CallStart(i,1),CallStart(i,2),'r*')
     end
 end
 hold off
   