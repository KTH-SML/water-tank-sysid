function varargout = Tuner(varargin)
% TUNER MATLAB code for Tuner.fig
%      TUNER, by itself, creates a new TUNER or raises the existing
%      singleton*.
%
%      H = TUNER returns the handle to a new TUNER or the handle to
%      the existing singleton*.
%
%      TUNER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in TUNER.M with the given input arguments.
%
%      TUNER('Property','Value',...) creates a new TUNER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Tuner_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Tuner_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Tuner

% Last Modified by GUIDE v2.5 19-Jul-2017 12:23:16

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Tuner_OpeningFcn, ...
                   'gui_OutputFcn',  @Tuner_OutputFcn, ...
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


% --- Executes just before Tuner is made visible.
function Tuner_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Tuner (see VARARGIN)

% Choose default command line output for Tuner
handles.output = hObject;

handles.tgroup = uitabgroup('Parent', handles.Tuner);
handles.tab1 = uitab('Parent', handles.tgroup, 'Title', 'Pole Placement');
handles.tab2 = uitab('Parent', handles.tgroup, 'Title', 'Lead lag');

%Place panels into each tab
set(handles.P1,'Parent',handles.tab1)
set(handles.P2,'Parent',handles.tab2)

%Reposition each panel to same location as panel 1
set(handles.P2,'position',get(handles.P1,'position'));

% UIWAIT makes Tuner wait for user response (see UIRESUME)
% uiwait(handles.Tuner);

% Update handles structure
guidata(hObject, handles);

%% assign uicontextmenu to both figures

hCMZ = uicontextmenu;
hZMenu1 = uimenu(hCMZ,'Label','Switch to pan','Callback','pan(gcbf,''on'')');
hZMenu2 = uimenu(hCMZ,'Label','Switch to zoom','Callback','zoom(gcbf,''on'')');
hZMenu3 = uimenu(hCMZ,'Label','Switch to DataCursor','Callback','datacursormode(gcbf,''on'')');
hZoom = zoom(gcf);
hPan = pan(gcf);
hCursor = datacursormode(gcf);
hCursor.SnapToDataVertex = 'off';
hZoom.UIContextMenu = hCMZ;
hPan.UIContextMenu = hCMZ;
hCursor.UIContextMenu = hCMZ;
zoom('on')

% --- Outputs from this function are returned to the command line.
function varargout = Tuner_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

