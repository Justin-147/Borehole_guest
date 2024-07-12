%---------------------------------------------------------
% 更改指定曲线的线型
%---------------------------------------------------------
function XXXZ_Callback(hObject, eventdata, handles)
% 更改指定曲线的线型
% hObject    handle to XXXZ (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = get(hObject,'String') returns XXXZ contents as cell array
%        contents{get(hObject,'Value')} returns selected item from XXXZ
xxn={'-';':';'-.';'--';'none'};
ii=get(hObject,'Value');
lename=handles.namel;
jbl=handles.htjubing;
htjb=handles.htjb;
wcjb=handles.wcjb;
if isempty(htjb)||ii==1
    return;
else
    if ii==6
        set(htjb,'Visible','off');
        set(wcjb,'Visible','off');
    else
        set(htjb,'Visible','on');
        set(wcjb,'Visible','on');
        set(htjb,'LineStyle',xxn{ii-1});
    end
end

len=length(jbl);
jj=[];
for ii=1:1:len
    if strcmp(get(jbl(ii),'Visible'),'on')
        jj=[jj;ii];
    end
end
lename=lename(jj,:);
jbl=jbl(jj);
legend(jbl,lename);

if isfield(handles,'dzjubing')
    dzjb=handles.dzjubing;
    zjjb=handles.zjjubing;
    if isempty(jj)   
        set(dzjb,'Visible','off');
        set(zjjb,'Visible','off');
    else
        set(dzjb,'Visible','on');
        set(zjjb,'Visible','on');
    end    
end



