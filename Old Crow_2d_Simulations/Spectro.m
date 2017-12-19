[FileName1,PathName] = uigetfile('*.wav','Select the first file'); [data11,Fs] = audioread(FileName1); data1 = data11(:,1);




n = 7;
beginFreq = 500 / (fs/2);
endFreq = 2500/ (fs/2);
[b,a] = butter(n, [beginFreq, endFreq], 'bandpass');
fOut = filter(b, a, data1);

Nfft = 256;    win_size = 125;    ovlap = 0.90;
[~,FFM_1,TTM_1,PM_1] = spectrogram(fOut,hanning(win_size),round(ovlap*win_size),Nfft,Fs);
imagesc(TTM_1,FFM_1(1:Nfft/2+1)/1000,10*log10(PM_1(1:Nfft/2+1,:))/10e-6);axis xy;colormap(jet)
xlabel('Time(s)')
ylabel('Frequency(kHz)')
title('Element 1')
