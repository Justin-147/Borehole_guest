% --------------------------------------------------
% 更改指定曲线的颜色
% --------------------------------------------------
function YSXZ_Callback(hObject, eventdata, handles)
% 更改指定曲线的颜色
% hObject    handle to YSXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns YSXZ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from YSXZ
xxn={'k';'r';'g';'b';'c';'m';'y'};
ii=get(hObject,'Value');
htjb=handles.htjb;
if isempty(htjb)||ii==1
    return;
else
    len=length(htjb);
    for jj=1:1:len
        set(htjb(jj),'Color',xxn{ii-1});
    end
end