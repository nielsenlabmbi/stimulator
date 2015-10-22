function varargout = paramSelect(varargin)
% PARAMSELECT M-file for paramSelect.fig
%      PARAMSELECT, by itself, creates a new PARAMSELECT or raises the existing
%      singleton*.
%
%      H = PARAMSELECT returns the handle to a new PARAMSELECT or the handle to
%      the existing singleton*.
%
%      PARAMSELECT('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in PARAMSELECT.M with the given input arguments.
%
%      PARAMSELECT('Property','Value',...) creates a new PARAMSELECT or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before paramSelect_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to paramSelect_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help paramSelect

% Last Modified by GUIDE v2.5 18-Jun-2010 15:17:05

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @paramSelect_OpeningFcn, ...
                   'gui_OutputFcn',  @paramSelect_OutputFcn, ...
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



% --- Executes just before paramSelect is made visible.
function paramSelect_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to paramSelect (see VARARGIN)

% Choose default command line output for paramSelect
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes paramSelect wait for user response (see UIRESUME)
% uiwait(handles.figure1);

global GUIhandles playSampleFlag 

mList=moduleListMaster('P'); %get correct module list

for i=1:length(mList)
    modStrings{i} = mList{i}{2};
end


set(handles.module,'string',modStrings)

GUIhandles.param = handles;

refreshParamView %the global Pstate has been set by calling stimulator2

playSampleFlag = 0;

% --- Outputs from this function are returned to the command line.
function varargout = paramSelect_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in parameterList.
function parameterList_Callback(hObject, eventdata, handles)
% hObject    handle to parameterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns parameterList contents as cell array
%        contents{get(hObject,'Value')} returns selected item from parameterList

global Pstate 

idx = get(handles.parameterList,'value');

set(handles.paramEditVal,'string',num2str(Pstate.param{idx}{3}));
set(handles.paramEdit,'string',Pstate.param{idx}{1});


% --- Executes during object creation, after setting all properties.
function parameterList_CreateFcn(hObject, eventdata, handles)
% hObject    handle to parameterList (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function paramEditVal_Callback(hObject, eventdata, handles)
% hObject    handle to paramEditVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of paramEditVal as text
%        str2double(get(hObject,'String')) returns contents of paramEditVal as a double

pval = get(handles.paramEditVal,'string');
psymbol = get(handles.paramEdit,'string');

updatePstate(psymbol,pval)
refreshParamView


% --- Executes during object creation, after setting all properties.
function paramEditVal_CreateFcn(hObject, eventdata, handles)
% hObject    handle to paramEditVal (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in loadParams.
function loadParams_Callback(hObject, eventdata, handles)
% hObject    handle to loadParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Pstate

[file path] = uigetfile({'*.param';'*.analyzer'},'Load parameter state');

id = find(file == '.');
fext = file(id+1:end);

if file  %if 'cancel' was not pressed
    file = [path file];
    
    if strcmp(fext,'param')  %selecting saved param file
        load(file,'-mat','Pstate')
    elseif strcmp(fext,'analyzer')  %selecting old experiment
        load(file,'-mat','Analyzer')
        Pstate = Analyzer.P;
    end
    
    refreshParamView
end

% --- Executes on button press in saveParams.
function saveParams_Callback(hObject, eventdata, handles)
% hObject    handle to saveParams (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global Pstate

[file path] = uiputfile('*.param','Save as');

if file  %if 'cancel' was not pressed
    file = [path file];
    save(file,'Pstate')
end


% --- Executes on selection change in module.
function module_Callback(hObject, eventdata, handles)
% hObject    handle to module (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns module contents as cell array
%        contents{get(hObject,'Value')} returns selected item from module

mi = get(hObject,'value');
configurePstate(mi,'P'); 
refreshParamView(1); %we're changing lists

% --- Executes during object creation, after setting all properties.
function module_CreateFcn(hObject, eventdata, handles)
% hObject    handle to module (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in send.
function send_Callback(hObject, eventdata, handles)
% hObject    handle to send (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global DcomState Mstate

set(handles.playSample,'enable','off')

Mstate.running = 0; %I don't think this is necessary, but doing it just in case for when I do 'sendMinfo'

updateMstate %this is only necessary for screendistance

mod = getmoduleID;

%%%%Send parameters to display
sendPinfo(mod)
waitforDisplayResp
sendMinfo
waitforDisplayResp
%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%Tell it to buffer the stimulus
msg = ['B;' mod ';-1;~'];  %-1 tells the display we're not looping, but just playing a sample
fwrite(DcomState.serialPortHandle,msg);  %Tell it to buffer images
waitforDisplayResp
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

set(handles.playSample,'enable','on')

% --- Executes on button press in playSample.
function playSample_Callback(hObject, eventdata, handles)
% hObject    handle to playSample (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

mod = getmoduleID;
startStimulus(mod)      %Tell Display to show its buffered images. 


