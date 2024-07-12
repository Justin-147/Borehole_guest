%---------------------------------------------------------
% 选择欲更改的曲线
%---------------------------------------------------------
function SJLY_Callback(hObject, eventdata, handles)
% hObject    handle to SJLY (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns SJLY contents as cell array
%        contents{get(hObject,'Value')} returns selected item from SJLY
ii=get(hObject,'Value');
htjubing=handles.htjubing;
wcjubing=handles.wcjubing;
namel=handles.namel;
len=length(htjubing);
if ii>len+1
    htjb=htjubing;
    wcjb=wcjubing;
elseif ii==1
    htjb=[];
    wcjb=[];
else
    htjb=htjubing(ii-1);
    wcjb=wcjubing(ii-1);
end
handles.htjb=htjb;
handles.wcjb=wcjb;
guidata(gcbo,handles);