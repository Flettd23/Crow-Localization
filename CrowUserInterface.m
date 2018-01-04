%% **************************** Crow Call UI ****************************
%  Author: Derek DeLizo


function varargout = CrowUserInterface(varargin)
% CROWUSERINTERFACE MATLAB code for CrowUserInterface.fig
%      CROWUSERINTERFACE, by itself, creates a new CROWUSERINTERFACE or raises the existing
%      singleton*.
%
%      H = CROWUSERINTERFACE returns the handle to a new CROWUSERINTERFACE or the handle to
%      the existing singleton*.
%
%      CROWUSERINTERFACE('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CROWUSERINTERFACE.M with the given input arguments.
%
%      CROWUSERINTERFACE('Property','Value',...) creates a new CROWUSERINTERFACE or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before CrowUserInterface_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to CrowUserInterface_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help CrowUserInterface

% Last Modified by GUIDE v2.5 19-Dec-2017 20:12:00

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @CrowUserInterface_OpeningFcn, ...
    'gui_OutputFcn',  @CrowUserInterface_OutputFcn, ...
    'gui_LayoutFcn',  [] , ...
    'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT

% --- Executes just before CrowUserInterface is made visible.
function CrowUserInterface_OpeningFcn(hObject, ~, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to CrowUserInterface (see VARARGIN)

% Choose default command line output for CrowUserInterface
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes CrowUserInterface wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = CrowUserInterface_OutputFcn(~, ~, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

%% ****************************************** Localization ******************************************
%The functions below work with the Crow Call Detection

% --- Executes on button press in AudioSelect1.
function AudioSelect1_Callback(hObject, eventdata, handles)
% hObject    handle to AudioSelect1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    inFilePath = FileName1;
else
    inFilePath = strcat(PathName,FileName1);
end
set(handles.Audio1,'String',inFilePath);

% --- Executes on button press in AudioSelect2.
function AudioSelect2_Callback(hObject, eventdata, handles)
% hObject    handle to AudioSelect2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    inFilePath = FileName1;
else
    inFilePath = strcat(PathName,FileName1);
end
set(handles.Audio2,'String',inFilePath);

% --- Executes on button press in AudioSelect3.
function AudioSelect3_Callback(hObject, eventdata, handles)
% hObject    handle to AudioSelect3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    inFilePath = FileName1;
else
    inFilePath = strcat(PathName,FileName1);
end
set(handles.Audio3,'String',inFilePath);

% --- Executes on button press in AudioSelect4.
function AudioSelect4_Callback(hObject, eventdata, handles)
% hObject    handle to AudioSelect4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    inFilePath = FileName1;
else
    inFilePath = strcat(PathName,FileName1);
end
set(handles.Audio4,'String',inFilePath);


% --- Executes on button press in Localize
% hObject    handle to Localize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function Localize_Callback(hObject, eventdata, handles)
AudioFile1 = get(handles.Audio1,'String');
AudioFile2 = get(handles.Audio2,'String');
AudioFile3 = get(handles.Audio3,'String');
AudioFile4 = get(handles.Audio4,'String');
ssIndexes = getappdata(0,'StartStopIndex');
fs = getappdata(0,'fs');
start = ssIndexes(2,1) / fs;
stop = ssIndexes(2,2) / fs;
[realloc,prelimloc] = Crow_2D_ExperimentFunctions(AudioFile1,AudioFile2,AudioFile3,AudioFile4,start,stop,1,false);


%% ****************************************** Detection ******************************************
%The functions below work with the Crow Call Detection

% --- Executes on button press in PlotCall.
function PlotCall_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = getappdata(0,'Index');
if (idx + 1) <= 4
    idx = idx + 1;
end
setappdata(0,'Index',idx);

% --- Executes on button press in plotprevious.
function plotprevious_Callback(hObject, eventdata, handles)
% hObject    handle to plotprevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
idx = getappdata(0,'Index');
if (idx - 1) > 0
    idx = idx - 1;
end
setappdata(0,'Index',idx);


% Plays the crow sound at the current index
function playsound_Callback(hObject, eventdata, handles)
% hObject    handle to playsound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

fs = getappdata(0,'fs');
channel1 = getappdata(0,'Channel1');
idx = getappdata(0,'Index');
ssTime = getappdata(0,'StartStopIndex');
startTime = ssTime(idx,1);
stopTime = ssTime(idx,2);

playFile = channel1(startTime:stopTime);
sound(playFile,fs);


% --- Executes on button press in InputSelect.
function InputSelect_Callback(hObject, eventdata, handles)
% hObject    handle to InputSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    inFilePath = FileName1;
else
    inFilePath = strcat(PathName,FileName1);
end
set(handles.SoundFile,'String',inFilePath);


% --- Executes on button press in LoadAudioFile.
function LoadAudioFile_Callback(hObject, eventdata, handles)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    inFilePath = FileName1;
else
    inFilePath = strcat(PathName,FileName1);
end
set(handles.AudioLoad,'String',inFilePath);

% --- Executes on button press in LoadDataText.
function LoadDataText_Callback(hObject, eventdata, handles)
[FileName1,PathName] = uigetfile('*.txt','Select the first file');
if(strcmp(PathName,'C:\Users\Derek DeLizo\Documents\Crow-Localization\') == 1)
    outFilePath = FileName1;
else
    outFilePath = strcat(PathName,FileName1);
end

set(handles.OutputFile,'String',outFilePath);

% --- Executes on button press in RunDetect.
function RunDetect_Callback(hObject, eventdata, handles)
audioPath = get(handles.SoundFile,'String');
fileName = get(handles.OutputName,'String');
setSoundTable(audioPath);
Crow_Call_Detection_Function(audioPath,fileName);


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
audioPath = get(handles.AudioLoad,'String');
fileName = get(handles.OutputFile,'String');
LoadIndicesStars = dlmread(fileName);
startStopIndicies = [LoadIndicesStars(:,1) LoadIndicesStars(:,2)];
stars = [LoadIndicesStars(:,3) LoadIndicesStars(:,4)];
setappdata(0,'OutputFile',fileName);
setappdata(0,'StartStopIndex',startStopIndicies);
setappdata(0,'StarIndex',stars);
setappdata(0,'Index',1);
setSoundTable(audioPath);
graphEnabled = get(handles.GraphMenu,'Enable');
if strcmp(graphEnabled,'off')
    set(handles.GraphMenu,'Enable','on');
end

%Loads the Audio file
%Then stores the information in the table
function setSoundTable(soundPath)
[wave,fs] = audioread(soundPath);
setappdata(0,'Length',length(wave));
setappdata(0,'Channel1',wave);
setappdata(0,'fs',fs);


% Manages all the plots for axes 3 using a switch statement
function GraphMenu_Callback(~, ~, handles)
array = getappdata(0,'Channel1');
fs = getappdata(0,'fs');
ss = getappdata(0,'StartStopIndex'); %%Start stop indexes matrik intialized
index = getappdata(0,'Index');
%Defining nesseary audio file details
Fmin = 500; %Minimum Frequency
Fmax = 2000; %Maximum Frequency
n = 7;
Nfft = 256;
win_size = 256;
ovlap = 0.90;
beginFreq = Fmin/(fs/2);
endFreq = Fmax/(fs/2);
[b,a] = butter(n,[beginFreq, endFreq], 'bandpass');
wave2 = filter(b,a,array);
axes(handles.axes3);

% Each switch case has an if statement to turn the 'Display on or off'
% Each case uses some of the values defined above to output the various
% plots
switch get(handles.GraphMenu,'Value')
    case 2
        %% ****************************************** Post-Filtered Amplitude ********************************************
        button = get(handles.GroupChoice,'Visible');
        if strcmp(button,'on') == 1
            set(handles.GroupChoice,'Visible','off');
        end
        t=0:1./fs:(length(array)-1)./fs;
        plot(t,array(:,2))
        title('PostFiltered Channel Two');
        ylabel('Filtered Amplitude');
        xlabel('Time (in seconds)');
    case 3
        %% ****************************************** Post-Filtered Spectrum ********************************************
        button = get(handles.GroupChoice,'Visible');
        if strcmp(button,'on') == 1
            set(handles.GroupChoice,'Visible','off');
        end
        soundData2fft = fft(array(:,2),Nfft);
        F = linspace(0,fs,Nfft);
        plot(F(1:Nfft/2+1),abs(soundData2fft(1:Nfft/2+1,1)))
        title('PostFiltered FFT');
        ylabel('Filtered Spectrum');
        xlabel('Freq (in Hz)');
    case 4
        %% ****************************************** Energy Graph ******************************************************
        button = get(handles.GroupChoice,'Visible');
        if strcmp(button,'on') == 1
            set(handles.GroupChoice,'Visible','off');
        end
        
        filePath = getappdata(0,'OutputFile');
        SoundDetect = getappdata(0,'StarIndex');
        delimeter = find(filePath == '.');
        outFilePath = strcat([filePath(1:delimeter-1) 'Energy' filePath(delimeter:end)]);
        array1 = dlmread(outFilePath);
        L = length(array1);
        t=0:1./fs:(length(array1)-1)./fs;
        plot(t(1:L),array1);
        xlabel('Time');
        ylabel('Energy');
        title('Energy vs Time');
        
        hold on
        for i = 1:length(SoundDetect)
            if ((SoundDetect(i,1) ~= 0) && (SoundDetect(i,2) ~= 0))
                if i == index
                    plot(SoundDetect(i,1),SoundDetect(i,2),'g*')
                else    
                    plot(SoundDetect(i,1),SoundDetect(i,2),'r*')
                end
            end
        end
        
        hold off
    case 5
        %% ****************************************** Spectogram Graph **************************************************
        pnlVisible = get(handles.GroupChoice,'Visible');
        if strcmp(pnlVisible,'off') == 1
            set(handles.GroupChoice,'Visible','on');
        end
        
        fullWave = get(handles.RadioFull,'Value');
        if fullWave == 0
            startIdx = ss(index,1);
            stopIdx = ss(index,2);
            spectoWave = filter(b, a, array(startIdx:stopIdx));
            [~,FFM_1,TTM_1,PM_1] = spectrogram(spectoWave,hanning(win_size),round(ovlap*win_size),Nfft,fs);
        else
            [~,FFM_1,TTM_1,PM_1] = spectrogram(wave2(:,2),hanning(win_size),round(ovlap*win_size),Nfft,fs);
        end
        
        imagesc(TTM_1,FFM_1(1:Nfft/2+1)/1000,10*log10(PM_1(1:Nfft/2+1,:))/10e-6);axis xy;
        colormap(jet);
        ylabel('Frequency (KHz)');
        xlabel('Time (s)');
        caxis([-3e+7 -0.5e+7])
        cBar = colorbar('Direction','reverse');
        cBar.Label.String = 'dB';
end

% --- Executes during object creation, after setting all properties.
function GraphMenu_CreateFcn(hObject, eventdata, handles)
% hObject    handle to GraphMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in checkbox1.
function checkbox1_Callback(hObject, eventdata, handles)
% hObject    handle to checkbox1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of checkbox1


% --- Executes on button press in DisplayMic.
function DisplayMic_Callback(hObject, eventdata, handles)
% hObject    handle to DisplayMic (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of DisplayMic


% --- Executes on button press in DisplayHyperbola.
% hObject    handle to DisplayHyperbola (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function DisplayHyperbola_Callback(hObject, eventdata, handles)


% --- Executes on button press in DisplayIntersect.
% hObject    handle to DisplayIntersect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function DisplayIntersect_Callback(hObject, eventdata, handles)


% --- Executes on button press in DisplayReal.
% hObject    handle to DisplayReal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function DisplayReal_Callback(hObject, eventdata, handles)


% --- Executes on button press in DisplayPrelim.
% hObject    handle to DisplayPrelim (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function DisplayPrelim_Callback(hObject, eventdata, handles)

% --- Executes on button press in AudioLoad.
% hObject    handle to AudioLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function AudioLoad_Callback(hObject, eventdata, handles)


% --- Executes during object creation, after setting all properties.
function AudioLoad_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AudioLoad (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Audio1_Callback(hObject, eventdata, handles)
% hObject    handle to Audio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Audio1 as text
%        str2double(get(hObject,'String')) returns contents of Audio1 as a double


% --- Executes during object creation, after setting all properties.
function Audio1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Audio1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

function LocalSSTimes_Callback(hObject, eventdata, handles)
% hObject    handle to LocalSSTimes (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LocalSSTimes as text
%        str2double(get(hObject,'String')) returns contents of LocalSSTimes as a double

% --- Executes on button press in LoadTimeLocal.
function LoadTimeLocal_Callback(hObject, eventdata, handles)
% hObject    handle to LoadTimeLocal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

function GroupChoice_ButtonDownFcn(hObject, eventdata, handles)
    GraphMenu_Callback(hObject, eventdata, handles);



function Audio2_Callback(hObject, eventdata, handles)
% hObject    handle to Audio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Audio2 as text
%        str2double(get(hObject,'String')) returns contents of Audio2 as a double


% --- Executes during object creation, after setting all properties.
function Audio2_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Audio2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Audio3_Callback(hObject, eventdata, handles)
% hObject    handle to Audio3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Audio3 as text
%        str2double(get(hObject,'String')) returns contents of Audio3 as a double


% --- Executes during object creation, after setting all properties.
function Audio3_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Audio3 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function Audio4_Callback(hObject, eventdata, handles)
% hObject    handle to Audio4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of Audio4 as text
%        str2double(get(hObject,'String')) returns contents of Audio4 as a double


% --- Executes during object creation, after setting all properties.
function Audio4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Audio4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over RadioFull.
% hObject    handle to RadioFull (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function RadioFull_ButtonDownFcn(hObject, eventdata, handles)
    


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over RadioSelect.
% hObject    handle to RadioSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
function RadioSelect_ButtonDownFcn(hObject, eventdata, handles)
    GraphMenu_Callback(hObject, eventdata, handles);


% --- Executes when selected object is changed in GroupChoice.
function GroupChoice_SelectionChangedFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in GroupChoice 
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4



% --- Executes on button press in NextCall.
function NextCall_Callback(hObject, eventdata, handles)
% hObject    handle to NextCall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)



function SoundFile_Callback(hObject, eventdata, handles)
% hObject    handle to SoundFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of SoundFile as text
%        str2double(get(hObject,'String')) returns contents of SoundFile as a double


% --- Executes during object creation, after setting all properties.
function SoundFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SoundFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function OutputFile_Callback(hObject, eventdata, handles)
% hObject    handle to OutputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputFile as text
%        str2double(get(hObject,'String')) returns contents of OutputFile as a double


% --- Executes during object creation, after setting all properties.
function OutputFile_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputFile (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end