% --------------------------------------------------------------------
% ���ͷ������������û��Զ���ģʽ
% --------------------------------------------------------------------
function YHZDYMMenu_Callback(hObject, eventdata, handles)
% ���ͷ������������û��Զ���ģʽ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tinf={'ѡ���Խ��������ļ�';'�����ļ��ĸ�ʽ���£�';'�ļ��� �������� γ��(��) ����(��) �߳�(��) ��λ��(��)';...
    'D:\��������\�ߴ�̨\h1.dat 4 31.3531 119.0168 20 146';'D:\��������\�ߴ�̨\h2.dat 4 31.3531 119.0168 20 11';...
    ' ';' ';'��������˵����1����,2��б�ϱ�����,3��б��������,4Ӧ���ϱ�����,5Ӧ�䶫������,6Ӧ����з���,7��Ӧ��,8��Ӧ��'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.*','���з���Ҫ����ļ�(*.*)'},'��ѡ�񴴽��õ������ļ�','MultiSelect','off');
dbfile=[Pname,Fname];
if sum(dbfile)==0
    %errordlg('���ļ�ʧ�ܣ�', '�ļ�����');
    QKtsxx(handles);     return;
end
fid=fopen(dbfile);
str_nouse=fgetl(fid);%�����ļ�ͷ
if str_nouse==-1%��������ļ���û�����ݣ�����������
    QKtsxx(handles);     return;
end
tmp_para = textscan(fid,'%s%f%f%f%f%f');%�����������
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ�����İ�����Ϣ
tinf=thcanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%��������Ĳ���
%����Ĭ��ֵ
dep=struct('SCF','0.1','IBOL','5','IBIAO',...
    '4','IJG','1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'��λ��������','��ϫ����','��ϫ������','�ɷֳ����ṹ',...
    'ʱ��ϵͳ','ȱ�����','����(��,����30�����)','����(��,��Χ��1������)','���λ��(1������)'};
title='������ֵ'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'SCF','IBOL','IBIAO','IJG','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Full_Name=tmp_para{1};%�����ļ�������·��
Full_Datatype=tmp_para{2};%�����ļ�����������
Full_Weidu=tmp_para{3};%�����ļ���γ��
Full_Jingdu=tmp_para{4};%�����ļ��ľ���
Full_Gaocheng=tmp_para{5};%�����ļ��ĸ߳�
Full_Fangweijiao=tmp_para{6};%�����ļ��ķ�λ��
weizhi_tichu=find(isnan(Full_Fangweijiao));%���ҳ���������������
Full_Name(weizhi_tichu)=[];%�޳�����������
Full_Datatype(weizhi_tichu)=[];
Full_Weidu(weizhi_tichu)=[];
Full_Jingdu(weizhi_tichu)=[];
Full_Gaocheng(weizhi_tichu)=[];
Full_Fangweijiao(weizhi_tichu)=[];
NFZ=length(Full_Weidu);%�������ļ�����
j2NFZ=0;%����ͳ��ѡ�е�����������������Ҫ��δ������ļ�����
j3NFZ=0;%����ͳ��ѡ�е������ݲ�������ֵ��δ������ļ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iiNFZ=1:1:NFZ
    dbfile=Full_Name{iiNFZ};
    if sum(dbfile)==0%�ļ���Ϊ�գ�����
        continue;
    end
    tmp=load(dbfile); [M,N]=size(tmp);
    %��������������ݣ��������ļ�
    if N~=2
        j2NFZ=j2NFZ+1;
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
        %�����������ֵ���ݣ��������ļ�
        if length(num2str(timet(1)))~=10
            j3NFZ=j3NFZ+1;
            continue;
        end
    end
    dep.IZL=num2str(Full_Datatype(iiNFZ));
    dep.FB=num2str(Full_Weidu(iiNFZ));
    dep.FL=num2str(Full_Jingdu(iiNFZ));
    dep.HH=num2str(Full_Gaocheng(iiNFZ));
    dep.AZ=num2str(Full_Fangweijiao(iiNFZ));    
    %%%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����   
    QS=str2num(dep.QS);
    [dataz,timet]=sjycl(dataz,timet,dep);
    [dataz,timet]=tbds(dataz,timet,QS);%�����
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timeuz=unique(fix(timet/100));%���յ�ʱ������
    handles.canshu=dep; handles.shuju=dataz;
    handles.shijian=timeuz; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fdwz=find(dbfile=='\',1,'last');
    handles.pn=dbfile(1:fdwz);
    handles.fn=dbfile(fdwz+1:length(dbfile));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.stif={['��׼�������ļ�',num2str(NFZ),'��'];['��ʼ��',num2str(iiNFZ),'��']};
    THFXLQ(handles,0);
end
set(handles.inform,'String',{['��׼�������ļ�',num2str(NFZ),'��'];['����',num2str(j2NFZ),'������������������Ҫ��δ����'];...
    [num2str(j3NFZ),'�������ݲ�������ֵδ����']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');




