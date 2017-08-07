function varargout = Glove_plot_GUI(varargin)
% GLOVE_PLOT_GUI MATLAB code for Glove_plot_GUI.fig
%      GLOVE_PLOT_GUI, by itself, creates a new GLOVE_PLOT_GUI or raises the existing
%      singleton*.
%
%      H = GLOVE_PLOT_GUI returns the handle to a new GLOVE_PLOT_GUI or the handle to
%      the existing singleton*.
%
%      GLOVE_PLOT_GUI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in GLOVE_PLOT_GUI.M with the given input arguments.
%
%      GLOVE_PLOT_GUI('Property','Value',...) creates a new GLOVE_PLOT_GUI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before Glove_plot_GUI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to Glove_plot_GUI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help Glove_plot_GUI

% Last Modified by GUIDE v2.5 25-Jul-2017 14:33:56

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @Glove_plot_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @Glove_plot_GUI_OutputFcn, ...
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

% --- Executes just before Glove_plot_GUI is made visible.
function Glove_plot_GUI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to Glove_plot_GUI (see VARARGIN)
% Choose default command line output for Glove_plot_GUI
handles.output = hObject;
% Update handles structure
guidata(hObject, handles);
% UIWAIT makes Glove_plot_GUI wait for user response (see UIRESUME)
% uiwait(handles.figure1);
set(handles.figure1, 'Name', 'Left Hand Motion Capturer');
% Set the Serial Port
global Baud_Rate InputBuffer_Size Time_Out popup_click;
popup_click=0;
delete(instrfindall);
info  = instrhwinfo('serial');
if(~isempty(info.AvailableSerialPorts))
    set(handles.com_port_selection_button,'String',flip(info.AvailableSerialPorts));
else
    set(handles.com_port_selection_button,'Enable','off');
    set(handles.start_button,'Enable','off');
    set(handles.pause_button,'Enable','off');
end
Baud_Rate=115200;
InputBuffer_Size = 500;
Time_Out=2;
% Sketch Setting
axis equal                                  % Set the propotion of the axes are eual 
xlabel('X-axis(cm)');
ylabel('Y-axis(cm)');
zlabel('Z-axis(cm)');
global pan tilt start_check;
pan=60;
tilt=45;
start_check=0;
view(pan,tilt)
set(handles.pan_slider,'Value',pan);
set(handles.tilt_slider,'Value',tilt);
set(handles.pan_value,'String',num2str(pan));
set(handles.tilt_value,'String',num2str(tilt));
grid on
hold on
% Parameters Initialization
global imu t0  t_pre count number store_limit plot_interval y p r time data first;
imu=10;
t0=0;
t_pre=0;
count=1;
number=1;
store_limit=5;
plot_interval=0.08;
y=[0,0,0,0,0,0,0,0,0,0];
p=[0,0,0,0,0,0,0,0,0,0];
r=[0,0,0,0,0,0,0,0,0,0];
time=[0,0,0,0,0,0,0,0,0,0];
data=[ ];
first=1;

% --- Outputs from this function are returned to the command line.
function varargout = Glove_plot_GUI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Get default command line output from handles structure
varargout{1} = handles.output;

% --- Executes on button press in start_button.
function start_button_Callback(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global start_check pause_check stop_check;
global s COM_Port Baud_Rate InputBuffer_Size Time_Out popup_click s_available;
global imu t0 t t_pre count number store_limit plot_interval y p r time data first;
global P_0 T3_0 T2_0 T1_0 I3_0 I2_0 I1_0 M3_0 M2_0 M1_0;
pause_check=0;
stop_check=0;
if((~popup_click)&&(~pause_check)&&(~stop_check)&&(ishandle(handles.output)))
    popup_click=1;
    s_available=0;
    delete(instrfindall);
    num=get(handles.com_port_selection_button,'Value');
    contents=get(handles.com_port_selection_button,'String');
    COM_Port=contents(num);
    s = serial(COM_Port, ...
                     'BaudRate', Baud_Rate, ...
                     'DataBits', 8, 'StopBits', 1, ...
                     'Parity', 'none', 'FlowControl', 'none', ...
                     'ReadAsyncMode' , 'continuous',...
                     'InputBufferSize', InputBuffer_Size, ...
                     'Timeout',Time_Out);
    if(isvalid(s))
        fclose(s);
        fopen(s);
        pause(1);
        if(s.BytesAvailable==0)
            fclose(s);
            msgbox({'The serial port object of is not available.' 'Pleasse select the other one!'},'Error','error');
            popup_click=0;
        else
            s_available=1;
            set(handles.com_port_selection_button, 'Enable', 'off');
        end
    else
        msgbox({'The serial port object of is invalid.' 'Pleasse select the other one!'},'Error','error');
        popup_click=0;
    end
end
if(( s_available)&&(~start_check)&&(~pause_check)&&(~stop_check)&&(ishandle(handles.output)))
    start_check=1;
     % First time read
    while(isempty(data))
        buffer = fscanf(s,'%c',InputBuffer_Size);
        data=str2num(buffer);
    end
    if(length(data)==5)
        i=data(:,1)+1;
        y(1,i)=data(:,2);
        p(1,i)=data(:,3);
        r(1,i)=data(:,4);
        t0=data(:,5);
        time(1,i)=0;
    end
    % read until full imu data
    while(count<imu)
         buffer = fscanf(s,'%c',InputBuffer_Size);
         data=str2num(buffer);
         if(length(data)==5)
             i=data(:,1)+1;
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
            time(end,i)=t;
            set(handles.passed_time,'String',ConvertTimeFormat(t));
            count=count+1;
        end
    end
    P_0= [y(1,1), p(1,1), r(1,1)];
    T3_0=[y(1,2), p(1,2), r(1,2)];
    T2_0=[y(1,3), p(1,3), r(1,3)];
    T1_0=[y(1,4), p(1,4), r(1,4)];
    I3_0=[y(1,5), p(1,5), r(1,5)];
    I2_0=[y(1,6), p(1,6), r(1,6)];
    I1_0=[y(1,7), p(1,7), r(1,7)];
    M3_0=[y(1,8), p(1,8), r(1,8)];
    M2_0=[y(1,9), p(1,9), r(1,9)];
    M1_0=[y(1,10), p(1,10), r(1,10)];
    count=0;
end
while(( s_available)&&(number<=store_limit-1)&&(~pause_check)&&(~stop_check)&&(ishandle(handles.output)))
     buffer = fscanf(s,'%c',InputBuffer_Size);
     data=str2num(buffer);
     if(length(data)==5)
     i=data(:,1)+1;
        if(count<imu)
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             set(handles.passed_time,'String',ConvertTimeFormat(t));
             count=count+1;
        else
             count=0;
             y=[y;zeros(1,10)];
             p=[p;zeros(1,10)];
             r=[r;zeros(1,10)];
             time=[time;zeros(1,10)];
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             set(handles.passed_time,'String',ConvertTimeFormat(t));
             number=number+1;
        end
    end
end
count=0;
while(( s_available)&&(~pause_check)&&(~stop_check)&&(ishandle(handles.output)))
    cla
    % Capture the Angle Data of Joints
    buffer = fscanf(s,'%c',InputBuffer_Size);
    data=str2num(buffer);
    if(length(data)==5)
        i=data(:,1)+1;
        if(count<imu)
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             set(handles.passed_time,'String',ConvertTimeFormat(t));
             count=count+1;
        else
             count=0;
             y(1:store_limit,1:10)=[y(2:store_limit,1:10);zeros(1,10)];
             p(1:store_limit,1:10)=[p(2:store_limit,1:10);zeros(1,10)];
             r(1:store_limit,1:10)=[r(2:store_limit,1:10);zeros(1,10)];
             time(1:store_limit,1:10)=[time(2:store_limit,1:10);zeros(1,10)];
             y(end,i)=data(:,2);
             p(end,i)=data(:,3);
             r(end,i)=data(:,4);
             t=data(:,5)-t0;
             time(end,i)=t;
             set(handles.passed_time,'String',ConvertTimeFormat(t));
             number=number+1;
             % first plot
             if(t_pre==0&&first==1)
             P= [y(1,1), p(1,1), r(1,1)]-P_0;
             T3=[y(1,2), p(1,2), r(1,2)]-T3_0;
             T2=[y(1,3), p(1,3), r(1,3)]-T2_0;
             T1=[y(1,4), p(1,4), r(1,4)]-T1_0;
             I3=[y(1,5), p(1,5), r(1,5)]-I3_0;
             I2=[y(1,6), p(1,6), r(1,6)]-I2_0;
             I1=[y(1,7), p(1,7), r(1,7)]-I1_0;
             M3=[y(1,8), p(1,8), r(1,8)]-M3_0;
             M2=[y(1,9), p(1,9), r(1,9)]-M2_0;
             M1=[y(1,10), p(1,10), r(1,10)]-M1_0;
             qT=[JointAngle(T3(3), P(3)), JointAngle(T3(1), P(1)), JointAngle(T2(3), T3(3)), JointAngle(T2(1), T3(1)), JointAngle(T1(3), T2(3))];
             qI=[JointAngle(I3(1), P(1)), JointAngle(I3(3), P(3)), JointAngle(I2(3), I3(3)), JointAngle(I1(3), I2(3))];
             qM=[JointAngle(M3(1), P(1)), JointAngle(M3(3), P(3)), JointAngle(M2(3), M3(3)), JointAngle(M1(3), M2(3))];
             % Angles of Joints
             theta = {[90,  -qT(2), -qT(3), -qT(4), -qT(5)];[90, -qI(3), -qI(3), -qI(4)];[90, -qM(2), -qM(3), -qM(4)];[90, 0, 0, 0];[90, 0, 0, 0]};                                % joint angle ( degree )
%              theta = {[90-qT(1), -qT(2), -qT(3), qT(4), -qT(5)];[90+qI(1), -qI(2), -qI(3), -qI(4)];[90+qM(1), -qM(2), -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle (degree )
             theta=cellfun(@deg2rad,theta,'UniformOutput',false);
             % Calculate the Model
             [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
                 t_pre=t;
                 first=0;
                 for i=1:5
                     for k=2:coordinate_num(i)
                         DrawLine(W{i}{k-1}, W{i}{k},'o');
                     end
%                      if(i==2)
%                         DrawLine(W{i-1}{3}, W{i}{2});
%                      elseif(i>2)
%                         DrawLine(W{i-1}{2}, W{i}{2});
%                      end
                 end
                 drawnow
             end
             if(t-t_pre>plot_interval&&first==0)
                 % Real-Time Plot
                 P= [y(1,1), p(1,1), r(1,1)]-P_0;
                 T3=[y(1,2), p(1,2), r(1,2)]-T3_0;
                 T2=[y(1,3), p(1,3), r(1,3)]-T2_0;
                 T1=[y(1,4), p(1,4), r(1,4)]-T1_0;
                 I3=[y(1,5), p(1,5), r(1,5)]-I3_0;
                 I2=[y(1,6), p(1,6), r(1,6)]-I2_0;
                 I1=[y(1,7), p(1,7), r(1,7)]-I1_0;
                 M3=[y(1,8), p(1,8), r(1,8)]-M3_0;
                 M2=[y(1,9), p(1,9), r(1,9)]-M2_0;
                 M1=[y(1,10), p(1,10), r(1,10)]-M1_0;
                 qT=[JointAngle(T3(3), P(3)), JointAngle(T3(1), P(1)), JointAngle(T2(3), T3(3)), JointAngle(T2(1), T3(1)), JointAngle(T1(3), T2(3))];
                 qI=[JointAngle(I3(1), P(1)), JointAngle(I3(3), P(3)), JointAngle(I2(3), I3(3)), JointAngle(I1(3), I2(3))];
                 qM=[JointAngle(M3(1), P(1)), JointAngle(M3(3), P(3)), JointAngle(M2(3), M3(3)), JointAngle(M1(3), M2(3))];
                 % Angles of Joints
                 theta = {[90,  -qT(2), -qT(3), -qT(4), -qT(5)];[90, -qI(3), -qI(3), -qI(4)];[90, -qM(2), -qM(3), -qM(4)];[90, 0, 0, 0];[90, 0, 0, 0]};                        % joint angle ( degree )
    %              theta = {[90-qT(1), -qT(2), -qT(3), qT(4), -qT(5)];[90+qI(1), -qI(2), -qI(3), -qI(4)];[90+qM(1), -qM(2), -qM(3), -qM(4)];[90,60, 120, 80];[90,60, 120, 80]};                                % joint angle ( degree )
                 theta=cellfun(@deg2rad,theta,'UniformOutput',false);
                % Calculate the Model
                 [W,H,coordinate_num]=LeftHand(theta); %W: the position vecter w.r.t global system; H: the rotation matrix w.r.t global system
                 t_pre=t;
                 for i=1:5
                    for k=2:coordinate_num(i)
                       DrawLine(W{i}{k-1}, W{i}{k},'o');
                    end
%                     if(i==2)
%                         DrawLine(W{i-1}{3}, W{i}{2});
%                     elseif(i>2)
%                         DrawLine(W{i-1}{2}, W{i}{2});
%                     end
                 end
                drawnow
             end
        end
          t=t+1;
    end
end

% --- Executes on button press in pause_button.
function pause_button_Callback(hObject, eventdata, handles)
% hObject    handle to pause_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global  pause_check;
pause_check=get(handles.pause_button,'Value');

% --- Executes on button press in stop_button.
function stop_button_Callback(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global s start_check popup_click stop_check;
global Baud_Rate InputBuffer_Size Time_Out;
start_check=0;
popup_click=0;
stop_check=get(handles.stop_button,'Value');
set(handles.passed_time,'String',ConvertTimeFormat(0));
if(exist('s','var')&&~isempty(s))
    if(isvalid(s))
        fclose(s);
    end
end
set(handles.com_port_selection_button, 'Enable', 'on');
cla
% Set the Serial Port
delete(instrfindall);
info  = instrhwinfo('serial');
if(~isempty(info.AvailableSerialPorts))
    set(handles.com_port_selection_button,'String',flip(info.AvailableSerialPorts));
    set(handles.com_port_selection_button,'Enable','on');
    set(handles.start_button,'Enable','on');
    set(handles.pause_button,'Enable','on');
else
    set(handles.com_port_selection_button,'Enable','off');
    set(handles.start_button,'Enable','off');
    set(handles.pause_button,'Enable','off');
end
Baud_Rate=115200;
InputBuffer_Size = 500;
Time_Out=2;
% Parameters Initialization
global imu t0  t_pre count number store_limit plot_interval y p r time data first;
imu=10;
t0=0;
t_pre=0;
count=1;
number=1;
store_limit=5;
plot_interval=0.08;
y=[0,0,0,0,0,0,0,0,0,0];
p=[0,0,0,0,0,0,0,0,0,0];
r=[0,0,0,0,0,0,0,0,0,0];
time=[0,0,0,0,0,0,0,0,0,0];
data=[ ];
first=1;

% --- Executes on slider movement.
function pan_slider_Callback(hObject, eventdata, handles)
% hObject    handle to pan_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pan tilt
pan=get(handles.pan_slider,'Value');
view(pan,tilt);
set(handles.pan_value,'String',num2str(round(pan)));

% --- Executes during object creation, after setting all properties.
function pan_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to pan_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- Executes on slider movement.
function tilt_slider_Callback(hObject, eventdata, handles)
% hObject    handle to tilt_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global pan tilt
tilt=get(handles.tilt_slider,'Value');
view(pan,tilt);
set(handles.tilt_value,'String',num2str(round(tilt)));

% --- Executes during object creation, after setting all properties.
function tilt_slider_CreateFcn(hObject, eventdata, handles)
% hObject    handle to tilt_slider (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over pause_button.
function pause_button_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to pause_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% --- Executes on selection change in com_port_selection_button.
function com_port_selection_button_Callback(hObject, eventdata, handles)
% hObject    handle to com_port_selection_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hints: contents = cellstr(get(hObject,'String')) returns com_port_selection_button contents as cell array
%        contents{get(hObject,'Value')} returns selected item from com_port_selection_button
global s COM_Port Baud_Rate InputBuffer_Size Time_Out popup_click s_available;
global pause_check;
if((~pause_check))
    popup_click=1;
    s_available=0;
    delete(instrfindall);
    num=get(handles.com_port_selection_button,'Value');
    contents=get(handles.com_port_selection_button,'String');
    COM_Port=contents(num);
    s = serial(COM_Port, ...
                     'BaudRate', Baud_Rate, ...
                     'DataBits', 8, 'StopBits', 1, ...
                     'Parity', 'none', 'FlowControl', 'none', ...
                     'ReadAsyncMode' , 'continuous',...
                     'InputBufferSize', InputBuffer_Size, ...
                     'Timeout',Time_Out);
     if(isvalid(s))
            fclose(s);
            fopen(s);
            pause(1);
            if(s.BytesAvailable==0)
                fclose(s);
                msgbox({'The serial port object of is not available.' 'Pleasse select the other one!'},'Error','error');
            else
                s_available=1;
                set(handles.com_port_selection_button, 'Enable', 'off');
            end
     else
            msgbox({'The serial port object of is invalid.' 'Pleasse select the other one!'},'Error','error');
     end
end

% --- Executes during object creation, after setting all properties.
function com_port_selection_button_CreateFcn(hObject, eventdata, handles)
% hObject    handle to com_port_selection_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called
% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes on button press in reset_view_button.
function reset_view_button_Callback(hObject, eventdata, handles)
% hObject    handle to reset_view_button (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
global pan tilt;
pan=60;
tilt=45;
view(pan,tilt)
set(handles.pan_slider,'Value',pan);
set(handles.tilt_slider,'Value',tilt);
set(handles.pan_value,'String',num2str(pan));
set(handles.tilt_value,'String',num2str(tilt));

% --- Executes when user attempts to close figure1.
function figure1_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% Hint: delete(hObject) closes the figure
delete(hObject);
global s;
if(exist('s','var')&&~isempty(s))
    if(isvalid(s))
        fclose(s);
    end
end
delete(instrfindall);
clc;

% --- Executes on key press with focus on figure1 and none of its controls.
function figure1_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.FIGURE)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata; % Let's see the KeyPress event data
global pan tilt
val=double(get(gcf,'CurrentCharacter'));
switch(val)
    case 28
        pan=pan-2;
        if(pan>= get(handles.pan_slider,'Min'))
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan+2;
        end
    case 29
        pan=pan+2;
        if(pan<= get(handles.pan_slider,'Max')) 
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan-2;
        end
    case 30
        tilt=tilt+1;
        if(tilt<= get(handles.tilt_slider,'Max'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt-1;
        end
    case 31
        tilt=tilt-1;
        if(tilt>= get(handles.tilt_slider,'Min'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt+1;
        end
end

% --- Executes on key press with focus on reset_view_button and none of its controls.
function reset_view_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to reset_view_button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata; % Let's see the KeyPress event data
global pan tilt
val=double(get(gcf,'CurrentCharacter'));
switch(val)
    case 28
        pan=pan-2;
        if(pan>= get(handles.pan_slider,'Min'))
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan+2;
        end
    case 29
        pan=pan+2;
        if(pan<= get(handles.pan_slider,'Max')) 
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan-2;
        end
    case 30
        tilt=tilt+1;
        if(tilt<= get(handles.tilt_slider,'Max'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt-1;
        end
    case 31
        tilt=tilt-1;
        if(tilt>= get(handles.tilt_slider,'Min'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt+1;
        end
end

% --- Executes on key press with focus on start_button and none of its controls.
function start_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to start_button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata; % Let's see the KeyPress event data
global pan tilt
val=double(get(gcf,'CurrentCharacter'));
switch(val)
    case 28
        pan=pan-2;
        if(pan>= get(handles.pan_slider,'Min'))
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan+2;
        end
    case 29
        pan=pan+2;
        if(pan<= get(handles.pan_slider,'Max')) 
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan-2;
        end
    case 30
        tilt=tilt+1;
        if(tilt<= get(handles.tilt_slider,'Max'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt-1;
        end
    case 31
        tilt=tilt-1;
        if(tilt>= get(handles.tilt_slider,'Min'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt+1;
        end
end

% --- Executes on key press with focus on pause_button and none of its controls.
function pause_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to pause_button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata; % Let's see the KeyPress event data
global pan tilt
val=double(get(gcf,'CurrentCharacter'));
switch(val)
    case 28
        pan=pan-2;
        if(pan>= get(handles.pan_slider,'Min'))
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan+2;
        end
    case 29
        pan=pan+2;
        if(pan<= get(handles.pan_slider,'Max')) 
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan-2;
        end
    case 30
        tilt=tilt+1;
        if(tilt<= get(handles.tilt_slider,'Max'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt-1;
        end
    case 31
        tilt=tilt-1;
        if(tilt>= get(handles.tilt_slider,'Min'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt+1;
        end
end

% --- Executes on key press with focus on stop_button and none of its controls.
function stop_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to stop_button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata; % Let's see the KeyPress event data
global pan tilt
val=double(get(gcf,'CurrentCharacter'));
switch(val)
    case 28
        pan=pan-2;
        if(pan>= get(handles.pan_slider,'Min'))
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan+2;
        end
    case 29
        pan=pan+2;
        if(pan<= get(handles.pan_slider,'Max')) 
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan-2;
        end
    case 30
        tilt=tilt+1;
        if(tilt<= get(handles.tilt_slider,'Max'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt-1;
        end
    case 31
        tilt=tilt-1;
        if(tilt>= get(handles.tilt_slider,'Min'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt+1;
        end
end

% --- Executes on key press with focus on com_port_selection_button and none of its controls.
function com_port_selection_button_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to com_port_selection_button (see GCBO)
% eventdata  structure with the following fields (see MATLAB.UI.CONTROL.UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)
eventdata; % Let's see the KeyPress event data
global pan tilt
val=double(get(gcf,'CurrentCharacter'));
switch(val)
    case 28
        pan=pan-2;
        if(pan>= get(handles.pan_slider,'Min'))
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan+2;
        end
    case 29
        pan=pan+2;
        if(pan<= get(handles.pan_slider,'Max')) 
            view(pan,tilt);
            set(handles.pan_slider,'Value',pan);
            set(handles.pan_value,'String',num2str(round(pan)));
        else
            pan=pan-2;
        end
    case 30
        tilt=tilt+1;
        if(tilt<= get(handles.tilt_slider,'Max'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt-1;
        end
    case 31
        tilt=tilt-1;
        if(tilt>= get(handles.tilt_slider,'Min'))
            view(pan,tilt);
            set(handles.tilt_slider,'Value',tilt);
            set(handles.tilt_value,'String',num2str(round(tilt)));
        else
             tilt=tilt+1;
        end
end