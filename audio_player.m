function varargout = audio_player(varargin)
% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @audio_player_OpeningFcn, ...
                   'gui_OutputFcn',  @audio_player_OutputFcn, ...
                   'gui_LayoutFcn',  [], ...
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


% --- Executes just before audio_player is made visible.
function audio_player_OpeningFcn(hObject, eventdata, handles)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   unrecognized PropertyName/PropertyValue pairs from the
%            command line (see VARARGIN)

% Choose default command line output for audio_player
handles.output = hObject;

% path_name = load('name.mat');
% path = path_name.path;
    path = 'Songs\5\';
    directory = dir(path);
    n = length(directory)-2;
    [~,songs_name] = xlsread('Songs_Database.xlsx','A:B');
    [num,col] = size(songs_name);

    song_title = directory(3).name;
    song_name = strcat(path,song_title);
    [y, Fs] = audioread(song_name);
    handles.length = length(y);
    handles.player = audioplayer(y, Fs);
    handles.next_position = -1;

    x=0.08;
    y=0.02;
    w=0.8;
    h=0.04;
    button_spacing = 0.002;
    panel2_height= 2*y+n*(h+button_spacing);
    panel1 = findobj('Tag','panel1');
    panel2 = uipanel(panel1,'Units','normalized','Position',[0 -1 1 2],'Clipping','off');


    s = uicontrol(panel1,'Style','Slider',...
        'Units','normalized','Position',[0.96 0 0.04 1],'SliderStep',[0.1 0.2],...
        'Value',1,'Callback',{@scroller_callback,panel2});
    hold on
    for j=1:n
        i = n-j+1;
        name_of_file = directory(i+2).name;
        file_name = name_of_file(1:end-4);
        if strlength(file_name) >= 20
            file_display_name = strcat(file_name(1:20),'...');
        else
            file_display_name = file_name;
        end
        song_button = uicontrol(panel2,'Style','pushbutton','FontSize',12,'Units','normalized',...
                    'Position',[x y w h],'Callback',{@playMusic,path,name_of_file,handles});
        pxPos = getpixelposition(song_button);
        song_button.String = ['<html><div width="' num2str(pxPos(3)-30) 'px" alight="left">' file_display_name];
        for j=1:num
            if strcmp(songs_name(j,1),file_name)
                artist_name = songs_name(j,2);
                artist_info = uicontrol(panel2,'Style','text','BackgroundColor',[0.94 0.94 0.94],'FontSize',10,'String',artist_name,'Units','normalized',...
                'Position',[x+w/2 y w/2 h/2]);
            elseif ~strcmp(songs_name(j,1),file_name)
                artist_name = '';
            end
        end


    y=y+h+button_spacing;            
    end
    hold off

% Update handles structure
guidata(hObject, handles);


function scroller_callback(src,eventdata,panel_argument)
    val = get(src,'Value');
    set(panel_argument,'Position',[0 -val 1 2])


function playMusic(hObject, eventdata, path, name_of_file, handles)
    song_name = strcat(path,name_of_file);
    [y, Fs] = audioread(song_name);
    handles.length = length(y);
    handles.player = audioplayer(y, Fs);
    handles.next_position = -1;
    guidata(hObject,handles);
    
% --- Outputs from this function are returned to the command line.
function varargout = audio_player_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on slider movement.
function audio_slider_Callback(hObject, eventdata, handles)
% hObject    handle to audio_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
playerinfo = get(handles.player);
position = playerinfo.TotalSamples * get(hObject, 'Value');

if strcmp(get(handles.player, 'Running'), 'on')
    stop(handles.player);
    play(handles.player, round(position));
else
    handles.next_position = round(position);
    guidata(hObject, handles);
end


% --- Executes during object creation, after setting all properties.
function audio_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to audio_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


% --- Executes on button press in pause.
function pause_Callback(hObject, eventdata, handles)
% hObject    handle to pause (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

if strcmp(get(handles.player, 'Running'), 'on')
    pause(handles.player);
end


% --- Executes on button press in play.
function play_Callback(hObject, eventdata, handles)
% hObject    handle to play (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.player, 'Running'), 'off')
    if handles.next_position >= 0
        play(handles.player, handles.next_position);

        handles.next_position = -1;
        guidata(hObject, handles);
    else
        resume(handles.player);
    end
        
    while strcmp(get(handles.player, 'Running'), 'on')
        playerinfo = get(handles.player);
        position = playerinfo.CurrentSample / playerinfo.TotalSamples;
        set(handles.audio_slider, 'Value', position);

        %pause(0.5);
    end
end

% --- Executes on button press in stop.
function stop_Callback(hObject, eventdata, handles)
% hObject    handle to stop (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
if strcmp(get(handles.player, 'Running'), 'on')
    stop(handles.player);
    position = 0;
    set(handles.audio_slider, 'Value', position);
end