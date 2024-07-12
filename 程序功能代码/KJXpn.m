% --------------------------------------------------------------------
% 控制两个绘图参数面板及其上控件的可见性
% --------------------------------------------------------------------
function KJXpn(handles,kj)
% 控制两个绘图参数面板及其上控件的可见性
set(handles.CSPN,'visible',kj);
set(handles.XXPN,'visible',kj);
set(handles.textxtmin,'visible',kj);
set(handles.textytmin,'visible',kj);
set(handles.textytstep,'visible',kj);
set(handles.textxtmax,'visible',kj);
set(handles.textytmax,'visible',kj);
set(handles.XTMin,'visible',kj);
set(handles.YTMin,'visible',kj);
set(handles.YTStep,'visible',kj);
set(handles.XTMax,'visible',kj);
set(handles.YTMax,'visible',kj);
set(handles.ReDraw,'visible',kj);
set(handles.text13,'visible',kj);
set(handles.text14,'visible',kj);
set(handles.text15,'visible',kj);
set(handles.text16,'visible',kj);
set(handles.SJLY,'visible',kj);
set(handles.YSXZ,'visible',kj);
set(handles.XXXZ,'visible',kj);
set(handles.LWED,'visible',kj);
set(handles.TJXKB,'visible',kj);
return;