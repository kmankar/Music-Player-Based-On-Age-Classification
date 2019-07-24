function varargout = Camera(varargin)
% CAMERA MATLAB code for Camera.fig
%      CAMERA, by itself, creates a new CAMERA or raises the existing
%      singleton*.
%
%      H = CAMERA returns the handle to a new CAMERA or the handle to
%      the existing singleton*.
%
%      CAMERA('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CAMERA.M with the given input arguments.
%
%      CAMERA('Property','Value',...) creates a new CAMERA or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Camera_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Camera_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Camera

% Last Modified by GUIDE v2.5 09-Oct-2017 22:28:51

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Camera_OpeningFcn, ...
                   'gui_OutputFcn',  @Camera_OutputFcn, ...
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


% --- Executes just before Camera is made visible.
function Camera_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Camera (see VARARGIN)

% Choose default command line output for Camera
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes Camera wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = Camera_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
    varargout{1} = handles.output;

    global vid;
    vid = videoinput('winvideo', 1, 'YUY2_1920x1080');
    vid.FramesPerTrigger = 1;
    vid.ReturnedColorspace = 'rgb';
    triggerconfig(vid, 'manual');
    vidRes = get(vid, 'VideoResolution');
    imWidth = vidRes(1);
    imHeight = vidRes(2);
    hImage = image(zeros(imHeight, imWidth), 'parent', handles.axPreview);
    preview(vid, hImage);

% --- Executes on button press in pbCapture.
function pbCapture_Callback(hObject, eventdata, handles)

    % prepare for capturing the image preview
    global vid;
    start(vid); 
    % do capture!
    trigger(vid);
    % stop the preview
    stoppreview(vid);
    % get the captured image data and save it on capt1 variable
    capt1 = getdata(vid);
    delete(Camera);
    detection(capt1);