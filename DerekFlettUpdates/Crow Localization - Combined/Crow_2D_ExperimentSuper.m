clear all;
close all;
%%
[SoundFile1,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file'); 
[SoundFile2,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file');
[SoundFile3,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file');
[SoundFile4,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file');


%Run Detection 
[MasterArray] = Detection_Function(SoundFile1);

cont = 'T';
while cont == 'T'
%% Prompting User Input 


disp('Crow Caws detected at following start times:')
for i = 1:length(MasterArray)
    if MasterArray(i) ~= 0
        fprintf('Call %d  : %f seconds\n',i,MasterArray(i,2));   
    end
end

prompt = {'Enter Desired Caw #:','Continue Selecting Calls (T to continue, Anything else to stop):'};
dlg_title = 'Input';
num_lines = 1;
defaultans = {'1','T'};
answer = inputdlg(prompt,dlg_title,num_lines,defaultans);

cont = answer{2,1};

row = answer{1,1};

%%
%Converting from char to Int

row2 = row +1 - 49;

%%

%Calibration Time... Assuming its the first one
StartTime = MasterArray(1,1);
EndTime = MasterArray(1,2);


StartTime2 = MasterArray(row2,1);
EndTime2 = MasterArray(row2,2);

time_mat = Crow_2D_LocalizationPrelim(SoundFile1, SoundFile2, SoundFile3, SoundFile4, StartTime, EndTime,2, true);


[hypMat, intMat, realloc] = Crow_2D_Localization(SoundFile1, SoundFile2, SoundFile3, SoundFile4, StartTime2, EndTime2,2, true, time_mat);

MasterArray(row2,3) = realloc(1,1);
MasterArray(row2,4) = realloc(1,2);


end
