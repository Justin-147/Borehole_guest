% --------------------------------------------------------------------
% ��ж����Ӧ�����������û��Զ���ģʽ
% --------------------------------------------------------------------
function YHZDYMjxzMenu_Callback(hObject, eventdata, handles)
% ��ж����Ӧ�����������û��Զ���ģʽ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tinf={'ѡ���Խ��������ļ�';'�����ļ��ĸ�ʽ���£�';'�ļ��� ģ������ γ��(��) ����(��) �߳�(��) ��λ��(��)';...
    'D:\��������\�ߴ�̨\h1.dat 4 31.3531 119.0168 20 146';'D:\��������\�ߴ�̨\P.dat 4 31.3531 119.0168 20 11';...
    'D:\��������\�ߴ�̨\W.dat 4 31.3531 119.0168 20 11';' ';' ';...
    'ģ������˵����1����ģ��,2������ѹӰ���ģ��,3����ˮλӰ���ģ��,4ͬʱ������ѹ��ˮλӰ���ģ��';...
    'ע�⣺�����ļ���ģ��������Ҫ������ȷ���ļ�������˳����Ҫ��ģ���������'};
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
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%��������Ĳ���
%����Ĭ��ֵ
dep=struct('IHS','8','QS','999999.0','CCH','30','BCH','10','WZ','30');
prompt={'ʱ��ϵͳ','ȱ�����','����(��,����30�����)','����(��,��Χ��1������)','���λ��(1������)'};
title='������ֵ'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Full_Name=tmp_para{1};%�����ļ�������·��
Full_Modeltype=tmp_para{2};%�����ļ���ģ������
Full_Weidu=tmp_para{3};%�����ļ���γ��
Full_Jingdu=tmp_para{4};%�����ļ��ľ���
Full_Gaocheng=tmp_para{5};%�����ļ��ĸ߳�
Full_Fangweijiao=tmp_para{6};%�����ļ��ķ�λ��
NFZ=length(Full_Weidu);%�������ļ�����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iiNFZ=1;%��ʼ
while (1)%�����forѭ�����ڲ�����ѭ������ֵ���ⲿ��Ӱ��
    dep.MX=num2str(Full_Modeltype(iiNFZ));
    dep.FB=num2str(Full_Weidu(iiNFZ));
    dep.FL=num2str(Full_Jingdu(iiNFZ));
    dep.HH=num2str(Full_Gaocheng(iiNFZ));
    dep.AZ=num2str(Full_Fangweijiao(iiNFZ));
    dep.QS=dep.QS; dep.SCF='1';%��Ϊȱ�������ͬ�����ǵ�λ��������Ϊ1
    if dep.MX=='1'||dep.MX=='2'||dep.MX=='3'||dep.MX=='4'
        %��Ӧ���ļ�
        dbfileY=Full_Name{iiNFZ};
        [datazY,timetY,fbz]=dzdsj1(dbfileY);
        if fbz==0
            iiNFZ=iiNFZ+floor(str2num(dep.MX)/2)+1;
            continue;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        if dep.MX=='2'
            %����ѹ�ļ�
            iiNFZ=iiNFZ+1;
            dbfileP=Full_Name{iiNFZ};
            [datazP,timetP,fbz]=dzdsj1(dbfileP);
            if fbz==0
                iiNFZ=iiNFZ+1; continue;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif dep.MX=='3'
            %��ˮλ�ļ�
            iiNFZ=iiNFZ+1;
            dbfileW=Full_Name{iiNFZ};
            [datazW,timetW,fbz]=dzdsj1(dbfileW);
            if fbz==0
                iiNFZ=iiNFZ+1; continue;
            end
        elseif dep.MX=='4'
            %����ѹ�ļ�
            iiNFZ=iiNFZ+1;
            dbfileP=Full_Name{iiNFZ};
            [datazP,timetP,fbz]=dzdsj1(dbfileP);
            if fbz==0
                iiNFZ=iiNFZ+2; continue;
            end
            %��ˮλ�ļ�
            iiNFZ=iiNFZ+1;
            dbfileW=Full_Name{iiNFZ};
            [datazW,timetW,fbz]=dzdsj1(dbfileW);
            if fbz==0
                iiNFZ=iiNFZ+1; continue;
            end
        else
        end
    else
        tinf={'�����ļ��д���ģ��������������У�������ǰ����'};
        set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
        return; %ģ��ѡ�����
    end
    %%%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����
    QS=str2num(dep.QS);
    [datazY,timetY]=sjycl(datazY,timetY,dep);
    [datazY,timetY]=tbds(datazY,timetY,QS);%�����
    if dep.MX=='2'
        [datazP,timetP]=sjycl(datazP,timetP,dep);
        [datazP,timetP]=tbds(datazP,timetP,QS);%�����
        %��ѡ����ʱ�Σ�ͳһȱ��λ�ã�����NaN�滻
        [timet,IY,IP]=intersect(timetY,timetP);
        datazY=datazY(IY);    datazP=datazP(IP);
        qswz=union(find(datazY==QS),find(datazP==QS));
        datazY(qswz)=NaN;    datazP(qswz)=NaN;
        handles.shujup=datazP;
    elseif dep.MX=='3'
        [datazW,timetW]=sjycl(datazW,timetW,dep);
        [datazW,timetW]=tbds(datazW,timetW,QS);%�����
        %��ѡ����ʱ�Σ�ͳһȱ��λ�ã�����NaN�滻
        [timet,IY,IW]=intersect(timetY,timetW);
        datazY=datazY(IY);    datazW=datazW(IW);
        qswz=union(find(datazY==QS),find(datazW==QS));
        datazY(qswz)=NaN;    datazW(qswz)=NaN;
        handles.shujuw=datazW;
    elseif dep.MX=='4'
        [datazP,timetP]=sjycl(datazP,timetP,dep);
        [datazP,timetP]=tbds(datazP,timetP,QS);%�����
        [datazW,timetW]=sjycl(datazW,timetW,dep);
        [datazW,timetW]=tbds(datazW,timetW,QS);%�����
        %��ѡ����ʱ�Σ�ͳһȱ��λ�ã�����NaN�滻
        timet=intersect(intersect(timetY,timetP),timetW);
        [tt,IY,II]=intersect(timetY,timet);
        [tt,IP,II]=intersect(timetP,timet);
        [tt,IW,II]=intersect(timetW,timet);
        datazY=datazY(IY);    datazP=datazP(IP);    datazP=datazP(IW);
        qswz=union(union(find(datazY==QS),find(datazP==QS)),find(datazW==QS));
        datazY(qswz)=NaN;    datazP(qswz)=NaN;    datazW(qswz)=NaN;
        handles.shujup=datazP; handles.shujuw=datazW;
    else
        timet=timetY;   datazY(find(datazY==QS))=NaN;
    end
    timeuz=unique(fix(timet/100));%���յ�ʱ������
    handles.canshu=dep;
    handles.shijian=timeuz; handles.tt=timet;
    fdwz=find(dbfileY=='\',1,'last');
    handles.pny=dbfileY(1:fdwz);
    handles.fny=dbfileY(fdwz+1:length(dbfileY));
    handles.shujuy=datazY;
    dbfileY=[];dbfileP=[];dbfileW=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.stif={['��׼�������ļ�',num2str(NFZ),'��'];['��ʼ��',num2str(iiNFZ-1),'��']};
    JXZLQ(handles,0,1);
    iiNFZ=iiNFZ+1;%��һ���ļ����
    if iiNFZ>NFZ
        break;
    end
end
set(handles.inform,'String',{['�������ļ�',num2str(NFZ),'��']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');