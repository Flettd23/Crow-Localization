[FileName1,PathName] = uigetfile('*.wav','Select the first file');
[wave,fs] = audioread(fullfile(PathName,FileName1)); %Must use fullfile if file is not in MatLab directory
L = length(wave) ;
NFFT = L;