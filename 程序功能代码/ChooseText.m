% --------------------------------------------------------------------
% datacursor�ĵ��ú�������ʾ��/��/�� ����ֵ
% --------------------------------------------------------------------
function output_txt = ChooseText(obj,event_obj)
% Display the position of the data cursor
% obj          Currently not used (empty)
% event_obj    Handle to event object
% output_txt   Data cursor text string (string or cell array of strings).
global hh
timej=hh.sj;
xx=hh.xx;
pos = get(event_obj,'Position');
pin=find(xx==pos(1));
tmp=num2str(timej(pin));
tmp=[tmp(1:4),'/',tmp(5:6),'/',tmp(7:8)];
output_txt = {['X: ',tmp],...
    ['Y: ',num2str(pos(2),4)]};

% If there is a Z-coordinate in the position, display it as well
if length(pos) > 2
    output_txt{end+1} = ['Z: ',num2str(pos(3),4)];
end

jb = get(event_obj,'Target');%ͼ�ξ��
txjb=get(jb);%ת���ɽṹ��
if isfield(txjb,'UserData')%����������������ʾ
    edata=txjb.UserData;
    output_txt{end+1} = ['error: ',num2str(edata(pin),4)];
end

