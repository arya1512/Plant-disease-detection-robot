function varargout = control(varargin)
%start vlc -vvv -Idummy rtsp://login:password@192.168.0.2/streaming/channels/2/preview --sout #transcode{vcodec=MJPG,venc=ffmpeg{strict=1},fps=10,width=640,height=360}:standard{access=http{mime=multipart/x-mixed-replace;boundary=--7b3cc56e5f51db803f790dad720ed50a},mux=mpjpeg,dst=:9911/}
% CONTROL MATLAB code for control.fig
%      CONTROL, by itself, creates a new CONTROL or raises the existing
%      singleton*.
%
%      H = CONTROL returns the handle to a new CONTROL or the handle to
%      the existing singleton*.
%
%      CONTROL('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in CONTROL.M with the given input arguments.
%
%      CONTROL('Property','Value',...) creates a new CONTROL or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before control_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to control_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help control

% Last Modified by GUIDE v2.5 14-Apr-2020 20:26:40

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @control_OpeningFcn, ...
                   'gui_OutputFcn',  @control_OutputFcn, ...
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


% --- Executes just before control is made visible.
function control_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to control (see VARARGIN)

% Choose default command line output for control
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes control wait for user response (see UIRESUME)
% uiwait(handles.figure1);

%system('"C:\Program Files (x86)\VideoLAN\VLC\vlc.exe" rtsp://192.168.1.103/live/ch00_1')
% actx = actxcontrol('WMPlayer.ocx.7'); % Create Controller
% media = actx.newMedia('D:\yash nupur\yash study\KIT clg\sem6\project\PROJECT final\wpfinal.mp4'); % Create Media object
% actx.CurrentMedia = media;
% actx.Controls.play

global a;

c = ipcam('http://127.0.0.1:9911');
%preview(I)
%img = snapshot(I);
%imshow(img)
%c = videoinput('winvideo',1);
axes(handles.livec);
cimage = image(zeros(300,650,3),'parent',handles.livec);
preview(c,cimage);
 handles.c = c;
  guidata(hObject,handles)




% --- Outputs from this function are returned to the command line.
function varargout = control_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;

clear all;
global a;
global b;
a= arduino;

      

% --- Executes on button press in pushbutton7.
function pushbutton7_Callback(hObject, eventdata, handles)
% hObject    handle to pushbutton7 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
 frame = snapshot(handles.c);
  axes(handles.axes2);
   imshow(frame);
    text=  ' Image Captured';
    set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);
    pause(1);
    set(handles.optext,'string','');
%=======================================imageprocess================================================
    
A=frame;
A_gray=rgb2gray(A);
A_hsv=rgb2hsv(A);
A_v=A_hsv (:,:,3);
A_v=histeq(A_v);
A_hsv(:,:,3)=A_v;
A_enhanced=hsv2rgb(A_hsv);
A_lab= rgb2lab(A);
ab = A_lab(:,:,2:3);
nrows = size(ab,1);
ncols = size(ab,2);
ab = reshape(ab,nrows*ncols,2);
nColors = 3;
[cluster_idx, cluster_center] = kmeans(ab,nColors,'distance','sqEuclidean', ...
                                      'Replicates',3);                                 
pixel_labels = reshape(cluster_idx,nrows,ncols);
%imshow(pixel_labels,[]), title('image labeled by cluster index');
segmented_images = cell(1,3);
rgb_label = repmat(pixel_labels,[1 1 3]);
for k = 1:nColors
    color = A;
    color(rgb_label ~= k) = 0;
    segmented_images{k} = color;
end
Agg=rgb2gray(segmented_images{2});
otsu_level= graythresh(Agg);
A_thresh=im2bw(A_lab,1/255);
A_thresh=~A_thresh;
se=strel ('disk',20);
A_erosion= imerode (A_thresh,se);
% subplot(3,3,1), imshow(A), title('original');
% subplot(3,3,2), imshow(A_gray), title('gray model');
% subplot(3,3,3), imshow(A_hsv), title('hsv model');
% subplot(3,3,4), imshow(A_enhanced), title('enhanced');
% subplot(3,3,5), imshow(A_lab), title('lab model');
% subplot(3,3,6), imshow(A_thresh), title('thresholding');
% subplot(3,3,7), imshow(segmented_images{1}), title('objects in cluster 1');
% subplot(3,3,8), imshow(segmented_images{2}), title('objects in cluster 2');
% subplot(3,3,9), imshow(segmented_images{3}), title('objects in cluster 3');
if A_erosion==0
    
      text=  ' Plant is affected ';
      set(handles.optext,'string',text,'ForegroundColor','red');
      clear text;
     
else
       text=  ' Plant is not affected ';
    
      set(handles.optext,'string',text,'ForegroundColor',[0.4660 0.6740 0.1880]);
     
    
end


%%=======================================================================================================%

function forwardb_Callback(hObject, eventdata, handles)
% hObject    handle to forwardb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in backb.
function backb_Callback(hObject, eventdata, handles)
% hObject    handle to backb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in rightb.
function rightb_Callback(hObject, eventdata, handles)
% hObject    handle to rightb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes on button press in leftb.
function leftb_Callback(hObject, eventdata, handles)
% hObject    handle to leftb (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

%==============================================================================================%
% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
%save the current object (that with focus)
  global a;
handles.controlWithFocus = gco;
guidata(hObject, handles);

if isfield(handles,'controlWithFocus') && handles.controlWithFocus == handles.forwardb
           %%%forward%%%%
      writeDigitalPin(a,'D9',1);
      writeDigitalPin(a,'D10',0);
      writeDigitalPin(a,'D11',1);
      writeDigitalPin(a,'D12',0);
      text=  'Forward';
      set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);

elseif isfield(handles,'controlWithFocus') && handles.controlWithFocus == handles.backb
               %%%reverse%%%%
      writeDigitalPin(a,'D9',0);
      writeDigitalPin(a,'D10',1);
      writeDigitalPin(a,'D11',0);
      writeDigitalPin(a,'D12',1);
       text=  'Reverse';
      set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);
    
elseif isfield(handles,'controlWithFocus') && handles.controlWithFocus == handles.rightb
      %%%right%%%%
      global b;
    if b==1
        
      writeDigitalPin(a,'D9',0);
      writeDigitalPin(a,'D10',1);
      writeDigitalPin(a,'D11',0);
      writeDigitalPin(a,'D12',0);
      text=  'Reverse Right ';
      set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);
    else
         writeDigitalPin(a,'D9',0);
        writeDigitalPin(a,'D10',0);
        writeDigitalPin(a,'D11',1);
        writeDigitalPin(a,'D12',0);
        text=  'Right';
      set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);
    end
          
elseif isfield(handles,'controlWithFocus') && handles.controlWithFocus == handles.leftb
               %%%left%%%%
     global b;
     if b==1
               
          writeDigitalPin(a,'D9',0);
          writeDigitalPin(a,'D10',0);
          writeDigitalPin(a,'D11',0);
          writeDigitalPin(a,'D12',1);
          text=  'Reverse Left';
      set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);
     else
          writeDigitalPin(a,'D9',1);
         writeDigitalPin(a,'D10',0);
         writeDigitalPin(a,'D11',0);
         writeDigitalPin(a,'D12',0);
           text=  ' Left';
          set(handles.optext,'string',text,'ForegroundColor',[0.6350 0.0780 0.1840]);
     end
      
else 
           %%%%%stop%%%%%S
      writeDigitalPin(a,'D9',0);
      writeDigitalPin(a,'D10',0);
      writeDigitalPin(a,'D11',0);
      writeDigitalPin(a,'D12',0);
     
end

% --- Executes on mouse press over figure background, over a disabled or
% --- inactive control, or over an axes background.
function figure1_WindowButtonUpFcn(hObject, eventdata, handles)
% hObject    handle to figure1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
   global a;
handles.mouseUpTime = now;
handles.controlWithFocus = [];
guidata(hObject, handles);
  writeDigitalPin(a,'D9',0);
      writeDigitalPin(a,'D10',0);
      writeDigitalPin(a,'D11',0);
      writeDigitalPin(a,'D12',0);
       set(handles.optext,'string','');

%%%===============================================slider=============================%%%
% --- Executes on slider movement.
function slider1_Callback(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'Value') returns position of slider
%        get(hObject,'Min') and get(hObject,'Max') to determine range of slider
global a; 
global b;
b= get(hObject,'value');
if b==1
    writeDigitalPin(a,'D2',1);
    
else
    writeDigitalPin(a,'D2',0);
    
end
     
        
 


% --- Executes during object creation, after setting all properties.
function slider1_CreateFcn(hObject, eventdata, handles)
% hObject    handle to slider1 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: slider controls usually have a light gray background.
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end


   
