% %% ***************** Crow Auto Detection ******************
                        %Derek Flett

                        
                      
function [MasterArray] = Detection_Function(sfile1)                       
%Import File
import java.util.ArrayList;

dynArray = ArrayList();
starIdx = ArrayList();
[wave,fs] = audioread(sfile1); 

L = length(wave) ;
NFFT = L;

 
t=0:1/fs:(length(wave)-1)/fs; % and get sampling frequency */
F = linspace(0,fs,NFFT);
soundData(:,2) = wave(:,1);
soundData(:,1) = t;
soundDatafft = fft(wave(:,1),NFFT);

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
endFreq = 4000/ (fs/2);
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

% % Filter the signal
fOut = filter(b, a, wave);

% %Storing Filtered sound file into new array 'wave2'
wave2 = fOut; 



soundData2 = zeros(length(wave2),2);
soundData2(:,2) = wave2(:,2);
soundData2(:,1) = 1:1:L;
soundData2fft = fft(wave2(:,2),NFFT);
     
%% *****************  Caculating and Plotting Energy  *********************

%%Sum of energy Graph
timeStep = 0.1; 
steps = timeStep/(1/fs);

%Constants to find peaks in data 
%minEnergy is the minimum energy you want a possible crow call to be detected
energyData = zeros(L,1);
Total = L-steps;

% progressbar % Create figure and set starting time 
for i = 1:Total
    energyData(i) = sum(wave2(i:i+steps,2).^2);
%     progressbar(i/Total)
end
%% ***************** Detecting and Saving Possible Calls*******************
%Detecting Peaks and the time they appear
minEnergy = 7.5;%minEnergy is the minimum energy you want a possible crow call to be detected
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

 
 for i = 1:length(SoundDetect)
     if ((SoundDetect(i,1) ~= 0) && (SoundDetect(i,2) ~= 0))
          plot(SoundDetect(i,1),SoundDetect(i,2),'b*','LineWidth',1)
          plot(Start_Stop(i,1):SoundDetect(i,1),energyData(Start_Stop(i,1):SoundDetect(i,1)),'b','LineWidth',1)
          starIdx.add([SoundDetect(i,1) SoundDetect(i,2)]);
     end
 end
 
 %Changing from samples to seconds
    Start_Stop = Start_Stop/fs;


line([1 L],[minEnergy minEnergy],'LineWidth',1)
ylim([0 500])
 hold off
 

%% Creating array and table for CSV storage 
% MasterArray is in the order of: 
%Start,Stop,xLoc,yLoc,fundFreq,peakFreq,gaps,pauses,bandwidth
for i = 1:length(Start_Stop(:,1))
    if((Start_Stop(i,1) ~= 0)&&(Start_Stop(i,2) ~= 0))
        dynArray.add([Start_Stop(i,1) Start_Stop(i,2)]);
    end
end
MasterArray = zeros(dynArray.size()-1,11);
for i = 1:(dynArray.size()-1)
    times = dynArray.get(i);
    MasterArray(i,1) = times(1);
    MasterArray(i,2) = times(2);
    stars = starIdx.get(i);
    MasterArray(i,10) = stars(1);
    MasterArray(i,11) = stars(2);
end
 
 
%%
% fileID = fopen(csv_file,'w');
% fprintf(fileID,'Date,Time,Depth of Airgun(m),Depth of Reciever(m),X Airgun,Y Airgun,Z Airgun,X_R1,Y_R1,Z_R1,SEL,RMS\n'); %column names
% for i = 1:r %Append rows
% s = strcat(string(JulianDay),',',string(Time),',',string(Depth),',','X',string(X_Airgun),',',string(Y_Airgun),',',string(Z_Airgun),',',string(X_R1(i)),',',string(Y_R1(i)),',',string(Z_R1(i)),',',string(SEL(i)),',',string(RMS(i)),'\n');
% fprintf(fileID,s);
% end
% fclose(fileID);



 