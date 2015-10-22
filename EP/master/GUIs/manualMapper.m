function varargout = manualMapper(varargin)
% MANUALMAPPER MATLAB code for manualMapper.fig
%      MANUALMAPPER, by itself, creates a new MANUALMAPPER or raises the existing
%      singleton*.
%
%      H = MANUALMAPPER returns the handle to a new MANUALMAPPER or the handle to
%      the existing singleton*.
%
%      MANUALMAPPER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in MANUALMAPPER.M with the given input arguments.
%
%      MANUALMAPPER('Property','Value',...) creates a new MANUALMAPPER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before manualMapper_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to manualMapper_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help manualMapper

% Last Modified by GUIDE v2.5 13-Oct-2015 10:57:50

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @manualMapper_OpeningFcn, ...
                   'gui_OutputFcn',  @manualMapper_OutputFcn, ...
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


% --- Executes just before manualMapper is made visible.
function manualMapper_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to manualMapper (see VARARGIN)


mList=moduleListMaster('M');

for i=1:length(mList)
    modStrings{i} = mList{i}{2};
end


set(handles.sModule,'string',modStrings)

% Choose default command line output for manualMapper
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes manualMapper wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = manualMapper_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on selection change in sModule.
function sModule_Callback(hObject, eventdata, handles)
% hObject    handle to sModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns sModule contents as cell array
%        contents{get(hObject,'Value')} returns selected item from sModule


% --- Executes during object creation, after setting all properties.
function sModule_CreateFcn(hObject, eventdata, handles)
% hObject    handle to sModule (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in bplay.
function bplay_Callback(hObject, eventdata, handles)
% hObject    handle to bplay (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

global  Mstate

%update Mstate
Mstate.running = 0; 
updateMstate 

%get correct module
mi = get(handles.sModule,'value');
mList=moduleListMaster('M');
modId=mList{mi}{1};

%update parameters 
%configurePstate(mi,'M');

%%%%Send parameters to display
%sendPinfo(modId)
%waitforDisplayResp
sendMinfo
waitforDisplayResp
%%%%%%%%%%%%%%%%%%%%%%%%%%

startStimulus(modId) 
