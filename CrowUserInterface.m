

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

% Last Modified by GUIDE v2.5 23-Oct-2017 11:53:19

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
function CrowUserInterface_OpeningFcn(hObject, eventdata, handles, varargin)
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
function varargout = CrowUserInterface_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Localize.
function Localize_Callback(hObject, eventdata, handles)
% hObject    handle to Localize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in LoadData.
function LoadData_Callback(hObject, eventdata, handles)
% hObject    handle to LoadData (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
File_Name = get(handles.OutputFile, 'string');
SoundData = dlmread(File_Name);
setappdata(0,'LoadData',SoundData);

% --- Executes on button press in PlotCall.
function PlotCall_Callback(hObject, eventdata, handles)
% hObject    handle to PlotCall (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%Pulling array from its initial Load function
array = getappdata(0,'LoadData');

%Defining nesseary audio file details
fs = 24000;
L = length(array) ;
t=0:1/fs:(length(array)-1)/fs;
soundData2 = zeros(length(array),2);
soundData2(:,2) = array(:,2).^2;
%%Sum of energy Graph
timeStep = 0.02; 
steps = timeStep/(1/fs);
energyData = zeros(L,1);
    for i = 1:L-steps
    energyData(i) = sum(soundData2(i:i+steps,2).^2);
    end
    
    

%Defining variables nesseary for graphs
NFFT = L
soundData2fft = fft(array(:,2),NFFT)
F = linspace(0,fs,NFFT);


%Using a switch statement to plot all three graphs with one push button
    for n = 1:3
        switch n
            case 1
              axes(handles.axes3); 
              plot(t(1:L),energyData);
              xlabel('Time');
              ylabel('Energy');
              title('Energy vs Time');
            case 2 
              axes(handles.axes4); 
              plot(t,array(:,2))
              title('PostFiltered Channel Two');
              ylabel('Filtered Amplitude');
              xlabel('Time (in seconds)');
            case 3
              axes(handles.axes5); 
              plot(F(1:NFFT/2+1),abs(soundData2fft(1:NFFT/2+1,1)))
              title('PostFiltered FFT');
              ylabel('Filtered Spectrum');
              xlabel('Freq (in Hz)');
        end
    end

% --- Executes during object creation, after setting all properties.
function axes4_CreateFcn(hObject, eventdata, handles)
% hObject    handle to axes4 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate axes4


% --- Executes on button press in playsound.
function playsound_Callback(hObject, eventdata, handles)
% hObject    handle to playsound (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
fs = getappdata(0,'fs');
soundData = getappdata(0,'Channel1');
startTime = str2num(get(handles.StartTime,'String'));
stopTime = str2num(get(handles.StopTime,'String'));
startIdx = floor(fs * (startTime * 0.001))
stopIdx = floor(fs * (stopTime * 0.001))
playFile = soundData(startIdx:stopIdx);
sound(playFile,fs);



% --- Executes on button press in plotprevious.
function plotprevious_Callback(hObject, eventdata, handles)
% hObject    handle to plotprevious (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


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


% --- Executes on button press in SelectOutput.
function SelectOutput_Callback(hObject, eventdata, handles)
% hObject    handle to SelectOutput (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.txt','Select the first file');
outFilePath = strcat(PathName,FileName1);
set(handles.OutputFile,'String',outFilePath);


% --- Executes on button press in InputSelect.
function InputSelect_Callback(hObject, eventdata, handles)
% hObject    handle to InputSelect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
[FileName1,PathName] = uigetfile('*.wav','Select the first file');
inFilePath = strcat(PathName,FileName1);
set(handles.SoundFile,'String',inFilePath);



function StartTime_Callback(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StartTime as text
%        str2double(get(hObject,'String')) returns contents of StartTime as a double


% --- Executes during object creation, after setting all properties.
function StartTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StartTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function StopTime_Callback(hObject, eventdata, handles)
% hObject    handle to StopTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of StopTime as text
%        str2double(get(hObject,'String')) returns contents of StopTime as a double


% --- Executes during object creation, after setting all properties.
function StopTime_CreateFcn(hObject, eventdata, handles)
% hObject    handle to StopTime (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function OutputName_Callback(hObject, eventdata, handles)
% hObject    handle to OutputName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of OutputName as text
%        str2double(get(hObject,'String')) returns contents of OutputName as a double


% --- Executes during object creation, after setting all properties.
function OutputName_CreateFcn(hObject, eventdata, handles)
% hObject    handle to OutputName (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in RunDetect.
function RunDetect_Callback(hObject, eventdata, handles)
% hObject    handle to RunDetect (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
audioPath = get(handles.SoundFile,'String');
fileName = get(handles.OutputName,'String');
[wave,fs] = audioread(audioPath);
Time_Array = Crow_Call_Detection_Function(audioPath,fileName);
channel1 = wave(:,1);
setappdata(0,'Channel1',channel1);
setappdata(0,'fs',fs);


% --- Executes on selection change in GraphMenu.
function GraphMenu_Callback(hObject, eventdata, handles)
% hObject    handle to GraphMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns GraphMenu contents as cell array
%        contents{get(hObject,'Value')} returns selected item from GraphMenu
array = getappdata(0,'LoadData');

%Defining nesseary audio file details
fs = 24000;
L = length(array) ;
t=0:1/fs:(length(array)-1)/fs;
soundData2 = zeros(length(array),2);
soundData2(:,2) = array(:,2).^2;
%%Sum of energy Graph
timeStep = 0.02; 
steps = timeStep/(1/fs);
energyData = zeros(L,1);
    for i = 1:L-steps
    energyData(i) = sum(soundData2(i:i+steps,2).^2);
    end
    
    

%Defining variables nesseary for graphs
NFFT = L
soundData2fft = fft(array(:,2),NFFT)
F = linspace(0,fs,NFFT);

axes(handles.axes3);
switch get(handles.GraphMenu,'Value')
    case 2
        plot(t,array(:,2))
        title('PostFiltered Channel Two');
        ylabel('Filtered Amplitude');
        xlabel('Time (in seconds)');
    case 3
        plot(F(1:NFFT/2+1),abs(soundData2fft(1:NFFT/2+1,1)))
        title('PostFiltered FFT');
        ylabel('Filtered Spectrum');
        xlabel('Freq (in Hz)');
    case 4
        plot(t(1:L),energyData);
        xlabel('Time');
        ylabel('Energy');
        title('Energy vs Time');
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
