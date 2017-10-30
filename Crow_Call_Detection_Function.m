function Time_Array = Crow_Call_Detection(Path,OutputFileName) 
%% ***************** Crow Auto Detection ******************
                        %Derek Flett
%close all


%Import File
[wave,fs] = audioread(Path); 
L = length(wave) ;
NFFT = L;
 
%Creating Text file to store vital information for later analysis 
 fileName1=[OutputFileName,'.txt']; % Choose different extension if you like.
 % open a file for writing
 fid = fopen(fileName1, 'wt'); 
 if fid == -1
   error('Cannot open file: %s', fileName1); 
 end
 
   
%Filtering out anything below 500 hz and above 2000 hz (subject to change)
%Design a bandpass filter that filters out between 500 to 2000 Hz
n = 7;
beginFreq = 500 / (fs/2);
endFreq = 2000 / (fs/2);
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');

% Filter the signal
fOut = filter(b, a, wave);

%Storing Filtered sound file into new array 'wave2'
wave2 = fOut;


          
%% *****************  Caculating and Plotting Energy  *********************


%%Sum of energy Graph
timeStep = 0.2; 
steps = timeStep/(1/fs);

%Constants to find peaks in data 
%minEnergy is the minimum energy you want a possible crow call to be detected
energyData = zeros(L,1);
Total = L-steps;
for i = 1:Total
    energyData(i) = sum(wave2(i:i+steps,2).^2);
    progressbar(i/Total)
end



%% ***************** Detecting and Saving Possible Calls*******************


%Detecting Peaks and the time they appear
minEnergy = 3;%minEnergy is the minimum energy you want a possible crow call to be detected
numCall = 50; %Number of calls you expect to encounter
 
SoundDetect = zeros(numCall,2);
ind = 1;
max = 0;

spaceSize = 4; %m
maxTime = (sqrt(spaceSize.^2+spaceSize.^2))/340;  %units seconds
maxIndex = floor(maxTime*fs);
Start_Stop = zeros(numCall,2);
for i = 1:L
    if energyData(i) > minEnergy
        if energyData(i+1)> minEnergy %Causes problems if call is close to the min energy level 
            if energyData(i) > max 
                max = energyData(i);
                SoundDetect(ind,2) = energyData(i); %Energy of the sound
                SoundDetect(ind,1) = i*(1/fs); %sample at which the sound occured
                
                 %Assuming we detect a call of interest, to avoid the possiblilty of
                 %cutting out the call from other other mics as we import the audio files
                 %into Crow_2D_Localization, we can use the max distance from the mics
                 %devided by the speed of sound to calculate the maximum time difference
                 %between the sounds arrival to each mic


                 Start_Stop(ind,1) = (i-maxIndex);
                 Start_Stop(ind,2) = (i+0.3*fs+maxIndex);
                
            end
        else   
       ind = ind + 1;
        max = 0;
        end
    end
end

 for i = 1:length(SoundDetect)
     if ((SoundDetect(i,1) ~= 0) && (SoundDetect(i,2) ~= 0))
          plot(SoundDetect(i,1),SoundDetect(i,2),'r*')
     end
 end

 
 %Printing Relevant Segments of the entire sound file to a new text file to
 %be later used by the User Interface in selecting which parts are to be
 %anaylized by Crow Localization
 for i = 1:length(Start_Stop)
     if ((Start_Stop(i,1) ~= 0) && (Start_Stop(i,2) ~= 0)) 
              fprintf(fid,'%g\t',Start_Stop(i,:));
              fprintf(fid,'\n'); 
     end
 end
     fprintf(fid,'\n');
 fclose(fid);
 
 Time_Array = Start_Stop;
end


 