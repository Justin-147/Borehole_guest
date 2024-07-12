function varargout = BoreholeStrainOfLiuqi(varargin)
% BOREHOLESTRAINOFLIUQI M-file for BoreholeStrainOfLiuqi.fig
%      BOREHOLESTRAINOFLIUQI, by itself, creates a new BOREHOLESTRAINOFLIUQI or raises the existing
%      singleton*.
%
%      H = BOREHOLESTRAINOFLIUQI returns the handle to a new BOREHOLESTRAINOFLIUQI or the handle to
%      the existing singleton*.
%
%      BOREHOLESTRAINOFLIUQI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in BOREHOLESTRAINOFLIUQI.M with the given input arguments.
%
%      BOREHOLESTRAINOFLIUQI('Property','Value',...) creates a new BOREHOLESTRAINOFLIUQI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before BoreholeStrainOfLiuqi_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to BoreholeStrainOfLiuqi_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help BoreholeStrainOfLiuqi

% Last Modified by GUIDE v2.5 08-Apr-2015 22:41:17

% Begin initialization code - DO NOT EDIT
addpath(genpath(pwd));
gui_Singleton = 0;
gui_State = struct('gui_Name',       mfilename, ...
    'gui_Singleton',  gui_Singleton, ...
    'gui_OpeningFcn', @BoreholeStrainOfLiuqi_OpeningFcn, ...
    'gui_OutputFcn',  @BoreholeStrainOfLiuqi_OutputFcn, ...
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


% --- Executes just before BoreholeStrainOfLiuqi is made visible.
function BoreholeStrainOfLiuqi_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to BoreholeStrainOfLiuqi (see VARARGIN)

% Choose default command line output for BoreholeStrainOfLiuqi
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);


% UIWAIT makes BoreholeStrainOfLiuqi wait for user response (see UIRESUME)
% uiwait(handles.Zfigure);


% --- Outputs from this function are returned to the command line.
function varargout = BoreholeStrainOfLiuqi_OutputFcn(hObject, eventdata, handles)
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%函数添加区
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --------------------------------------------------------------------
function ExitMenuItem_Callback(hObject, eventdata, handles)
% hObject    handle to ExitMenuItem (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

selection=questdlg(['关闭这个程序么？'],...
    ['关闭' get(handles.Zfigure,'Name') '...'],...
    'Yes','No','Yes');
if strcmp(selection,'No')
    return;
end
delete(handles.Zfigure)


% --------------------------------------------------------------------
%绘图区存图
% --------------------------------------------------------------------
function SaveFoHTQ_Callback(hObject, eventdata, handles)
[fname,pname,fi] = uiputfile({'*.emf','emf文件(*.emf)';'*.pdf','pdf文件(*.pdf)'},'保存图件为：');
dbfile= strcat(pname,fname);
if sum(dbfile)==0
    QKtsxx(handles);    return;
end
hz={'emf','pdf'};
set(handles.inform,'visible','off');
ZT=get(handles.CSPN,'visible');
set(gcf,'PaperPositionMode','auto');
if strcmp(ZT,'on')
    KJXpn(handles,'off');
    saveas(handles.MainPlotZone,dbfile,hz{fi});
    KJXpn(handles,'on');
else
    saveas(handles.MainPlotZone,dbfile,hz{fi});
    
end
set(handles.inform,'visible','on');
set(handles.inform,'String',{['图件',fname,'保存完毕'];['可在',pname,'下找到']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
return;


% --------------------------------------------------------------------
function THFXProcessMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------


% --------------------------------------------------------------------
function SFTHMenuItem_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------


% --------------------------------------------------------------------
%抽取指定分波数据并保存
% --------------------------------------------------------------------
function SelectFB_Callback(hObject, eventdata, handles)
STHCoCaP(handles,1);
return;


% --------------------------------------------------------------------
%单文件调和分析的画图程序
% --------------------------------------------------------------------
function THPinMPZ_Callback(hObject, eventdata, handles)
STHCoCaP(handles,2);
return;


% --------------------------------------------------------------------
function PLCLMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------


% --------------------------------------------------------------------
function DMMenu_Callback(hObject, eventdata, handles)
% --------------------------------------------------------------------


% --------------------------------------------------------------------
%显示鼠标点坐标
% --------------------------------------------------------------------
function uitoggletool21_ClickedCallback(hObject, eventdata, handles)
global hh
hh=handles; dcmObj = datacursormode;
set(dcmObj,'DisplayStyle','datatip','SnapToDataVertex','on','UpdateFcn', @ChooseText);
return;


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%系统生成区
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% --- Executes during object creation, after setting all properties.
function XXXZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XXXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
xxn={'可以进行线型改变';'-';':';'-.';'--';'none'};
set(hObject,'String',xxn);


% --- Executes during object creation, after setting all properties.
function YSXZ_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YSXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
xxn={'可以进行颜色改变';'黑色';'红色';'绿色';'蓝色';'青绿色';'洋红色';'黄色'};
set(hObject,'String',xxn);


function LWED_Callback(hObject, eventdata, handles)
% hObject    handle to LWED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of LWED as text
%        str2double(get(hObject,'String')) returns contents of LWED as a
%        double


% --- Executes during object creation, after setting all properties.
function MainPlotZone_CreateFcn(hObject, eventdata, handles)
% hObject    handle to MainPlotZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: place code in OpeningFcn to populate MainPlotZone


function XTMin_Callback(hObject, eventdata, handles)
% hObject    handle to XTMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XTMin as text
%        str2double(get(hObject,'String')) returns contents of XTMin as a double


% --- Executes during object creation, after setting all properties.
function XTMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XTMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function XTMax_Callback(hObject, eventdata, handles)
% hObject    handle to XTMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of XTMax as text
%        str2double(get(hObject,'String')) returns contents of XTMax as a double


% --- Executes during object creation, after setting all properties.
function XTMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to XTMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function YTMin_Callback(hObject, eventdata, handles)
% hObject    handle to YTMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YTMin as text
%        str2double(get(hObject,'String')) returns contents of YTMin as a double


% --- Executes during object creation, after setting all properties.
function YTMin_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YTMin (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function YTStep_Callback(hObject, eventdata, handles)
% hObject    handle to YTStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YTStep as text
%        str2double(get(hObject,'String')) returns contents of YTStep as a double


% --- Executes during object creation, after setting all properties.
function YTStep_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YTStep (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function YTMax_Callback(hObject, eventdata, handles)
% hObject    handle to YTMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of YTMax as text
%        str2double(get(hObject,'String')) returns contents of YTMax as a double


% --- Executes during object creation, after setting all properties.
function YTMax_CreateFcn(hObject, eventdata, handles)
% hObject    handle to YTMax (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function Zfigure_CreateFcn(hObject, eventdata, handles)
% hObject    handle to Zfigure (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function SJLY_CreateFcn(hObject, eventdata, handles)
% hObject    handle to SJLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: listbox controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function LWED_CreateFcn(hObject, eventdata, handles)
% hObject    handle to LWED (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes during object creation, after setting all properties.
function inform_CreateFcn(hObject, eventdata, handles)
% hObject    handle to inform (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --------------------------------------------------------------------
function SJWJHT_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to SJWJHT_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function ShuoMing_Callback(hObject, eventdata, handles)
msgbox({'本程序由中国地震局地震预测研究所刘琦编制';'当前版本号V1.0，最后调试时间2015-10-11';...
    'Email：liuqi@ief.ac.cn'},'程序说明');


% --------------------------------------------------------------------
function OuHeProcessMenu_Callback(hObject, eventdata, handles)
% hObject    handle to OuHeProcessMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SJYCL_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to SJYCL_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function JXZXYBProcessMenu_Callback(hObject, eventdata, handles)
% hObject    handle to JXZXYBProcessMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function SignalProcess_Menu_Callback(hObject, eventdata, handles)
% hObject    handle to SignalProcess_Menu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --- Executes during object deletion, before destroying properties.
function MainPlotZone_DeleteFcn(hObject, eventdata, handles)
% hObject    handle to MainPlotZone (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function STransformMenu_Callback(hObject, eventdata, handles)
% hObject    handle to STransformMenu (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function NakaiCompute_Callback(hObject, eventdata, handles)
% hObject    handle to NakaiCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


% --------------------------------------------------------------------
function JxzCompute_Callback(hObject, eventdata, handles)
% hObject    handle to JxzCompute (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
