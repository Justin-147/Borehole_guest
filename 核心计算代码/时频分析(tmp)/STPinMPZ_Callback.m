% --------------------------------------------------------------------
%���ļ�S�任�����ͼ����ͼ
% --------------------------------------------------------------------
function STPinMPZ_Callback(hObject, eventdata, handles)
tinf={'%�뱣֤��֮ǰ��������S�任';...
    '%�ҵ�����֮ǰΪ���洢����ST-��ͷ��mat�ļ�';...
    '%��ע�⣬����������ϴ���ܵ��³������л�������Ӱ���������';...
    '%��رղ���������������������������'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
[Fname,Pname]=uigetfile({'ST-*.mat','S�任����ļ�(*.mat)'},'����ѡ��������ļ�','MultiSelect','off');
dbfile=[Pname,Fname];
%���û�д��ļ�������������
if sum(dbfile)==0
    QKtsxx(handles);     return;
end
load(dbfile);
if (exist('stout','var')&&exist('tout','var')&&exist('fout','var'))==0
    errordlg('�ļ������ݲ�ȫ����ȷ��֮ǰ���й�S�任��', '���ݴ���');
    QKtsxx(handles);     return;
end

dnl=1;
[inl,valuel]=listdlg('PromptString','ѡ���ͼ����','SelectionMode',...
    'Multiple','ListString',{'ƽ��ͼ','��ά����ͼ'},...
    'InitialValue',dnl,'ListSize',[200 250]);
KJXpn(handles,'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FNL=15;    FNX=14;%�ֺ�
FNNX='Times New Roman';
FNNL='����_GB2312';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if inl==1
    imagesc(tout,fout,abs(stout));  colorbar('eastoutside'); axis xy;
    colormap('jet');
    set(gca,'FontSize',FNX,'FontName',FNNX);
    ylabel('Ƶ��','FontSize',FNL,'FontName',FNNL);
    xlabel('ʱ��','FontSize',FNL,'FontName',FNNL);
elseif inl==2
    [TT,FF]=meshgrid(tout,fout);
    surf(TT,FF,abs(stout));
    colorbar('eastoutside');
    colormap('jet');
    shading interp;
    set(gca,'FontSize',FNX,'FontName',FNNX);
    ylabel('Ƶ��','FontSize',FNL,'FontName',FNNL);
    xlabel('ʱ��','FontSize',FNL,'FontName',FNNL);
    set(gca,'view',[6 72]);
else    
end
QKtsxx(handles);     return;

