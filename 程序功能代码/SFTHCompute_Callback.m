% --------------------------------------------------------------------
% ���ļ����ͷ����ļ������
% --------------------------------------------------------------------
function SFTHCompute_Callback(hObject, eventdata, handles)
% ���ļ����ͷ����ļ������
%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname,dataz,timet,fbz]=dzdsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��������ļ�');
if fbz==0
    QKtsxx(handles);     return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ�����İ�����Ϣ
tinf=thcanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%��������Ĳ���
%����Ĭ��ֵ
dep=struct('FB','30.12','FL','102.18','HH','1450',...
    'AZ','51','SCF','0.1','IZL','4','IBOL','5','IBIAO',...
    '4','IJG','1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'̨վγ��(��,ʮ����)','̨վ����(��,ʮ����)','�߳�(��)','�۲����ݵķ�λ��(��,ʮ����)','��λ��������',...
    '��������','��ϫ����','��ϫ������','�ɷֳ����ṹ','ʱ��ϵͳ','ȱ�����','����(��,����30�����)','����(��,��Χ��1������)','���λ��(1������)'};
title='������ֵ'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'FB','FL','HH','AZ','SCF','IZL','IBOL','IBIAO','IJG','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����
QS=str2num(dep.QS);
[dataz,timet]=sjycl(dataz,timet,dep);
[dataz,timet]=tbds(dataz,timet,QS);%�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeuz=unique(fix(timet/100));%���յ�ʱ������
handles.canshu=dep; handles.shuju=dataz;
handles.shijian=timeuz; handles.pn=Pname;
handles.fn=Fname; 
THFXLQ(handles,1);
return;