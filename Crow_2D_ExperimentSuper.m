clear all;
close all;
[SoundFile1,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file'); 
[SoundFile2,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file');
[SoundFile3,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file');
[SoundFile4,PathName] = uigetfile('C:\Users\virdi_000\Documents\MATLAB\Crows\Crow-Localization-master\*.wav','Select the first file');
StartTime = 272.4;
EndTime = 272.7;

Location1 = Crow_2D_ExperimentFunctions(SoundFile1, SoundFile2, SoundFile3, SoundFile4, StartTime, EndTime,2, true);
% Location2 = Crow_2D_ExperimentFunctions(SoundFile1, SoundFile2, SoundFile3, SoundFile4, StartTime, EndTime,2, true);
