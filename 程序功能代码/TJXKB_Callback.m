% -------------------------------------------------------
% 更改指定曲线的线宽
% -------------------------------------------------------
function TJXKB_Callback(hObject, eventdata, handles)
% 更改指定曲线的线宽
% hObject    handle to TJXKB (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
xk=str2num(get(handles.LWED,'String'));
htjb=handles.htjb;
if isempty(htjb)
    return;
else
    len=length(htjb);
    for jj=1:1:len
        set(htjb(jj),'LineWidth',xk);
    end
end