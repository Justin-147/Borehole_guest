% --------------------------------------------------------------------
% ���ļ�����time-data��ʽ�Ķ�ά����
% --------------------------------------------------------------------
function Plot_Time_Data_Curve_Single_Callback(hObject, eventdata, handles)
% ��������time-data��ʽ�Ķ�ά����
tinf={'%�뱣֤����ѡ���ļ�Ϊʱ���������ݣ�����';...
    '%��һ��Ϊʱ��';...
    '%�ڶ���Ϊ����'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%���ļ���
[Fname,Pname]=uigetfile({'*.*','ʱ����������(*.*)'},'����ѡ����ͼ���ļ�','MultiSelect','off');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    QKtsxx(handles);     return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dnFW=[1];
[inFW,valueFW]=listdlg('PromptString','�Ƿ�Ի�ͼ��Χ�����޶�','SelectionMode',...
    'Single','ListString',{'��','������׼���޶�','ֱ�Ӹ�����Χ'},...
    'InitialValue',dnFW,'ListSize',[200 250]);
if valueFW==0
    QKtsxx(handles);     return;
end
if inFW==2
    depfw=struct('bs','6');
    prompt={'����������׼������ݵ㲻���'};
    title='��ͼ��Χ�޶�'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'bs'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[str2num(depfw.bs),NaN,NaN];
elseif inFW==3
    depfw=struct('yxmi','0','yxma','1');
    prompt={'y������Сֵ','y�������ֵ'};
    title='��ͼ��Χ�޶�'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'yxmi','yxma'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[NaN,str2num(depfw.yxmi),str2num(depfw.yxma)];
else
    fwcs=[NaN,NaN,NaN];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%�����ʾ��Ϣ��
QKtsxx(handles);
dep1=struct('QS','999999','YL','Ӧ��(10^{-10})','TNAME','');
prompt={'�����е�ȱ�����','y��label','ͼ������'};
title='��������'; lines=1; resize='off';
hi1=inputdlg(prompt,title,lines,struct2cell(dep1),resize);
if isempty(hi1)
    QKtsxx(handles);     return;
end
fields={'QS','YL','TNAME'};
if size(hi1,1)>0 dep1=cell2struct(hi1,fields,1); end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
dnxx=[1];
[inxx,valuexx]=listdlg('PromptString','ѡ����������','SelectionMode',...
    'Single','ListString',{'ʵ��-','����:','�㻮��.-','����--','ɢ��'},...
    'InitialValue',dnxx,'ListSize',[200 250]);
if valuexx==0
    QKtsxx(handles);     return;
end
dnxc=[1];
[inxc,valuexc]=listdlg('PromptString','ѡ��������ɫ','SelectionMode',...
    'Single','ListString',{'��ɫ','��ɫ','��ɫ','��ɫ'},...
    'InitialValue',dnxc,'ListSize',[200 250]);
if valuexc==0
    QKtsxx(handles);     return;
end
dnxb=[2];
[inxb,valuexb]=listdlg('PromptString','�Ƿ����y=0�Ļ�׼��','SelectionMode',...
    'Single','ListString',{'��','��'},...
    'InitialValue',dnxb,'ListSize',[200 250]);
if valuexb==0
    QKtsxx(handles);     return;
end

dnl=[1];
[inl,valuel]=listdlg('PromptString','ѡ���Ƿ��ע����','SelectionMode',...
    'Single','ListString',{'����ע','��ע'},...
    'InitialValue',dnl,'ListSize',[200 250]);
if valuel==0
    QKtsxx(handles);     return;
end
if ~isempty(find(inl==2))%��ע��������
    set(handles.inform,'String',{'����Ŀ¼�ļ��ĸ�ʽΪ��';'2008-05-12  14:28:04.0   31.0   103.4   14  Ms8.0  �Ĵ��봨��';...
        '2008-05-11  03:42:00.9   24.0   122.5   33  Ms5.6  ̨���Զ�����'},'Fontsize',10,'Fontweight','normal',...
        'Horizontalalignment','left');
    [dzFname,dzPname]=uigetfile({'*.*','����Ŀ¼�ļ�(*.*)'},'��ѡ�����Ŀ¼','MultiSelect','off');
    dzfile=[dzPname,dzFname];
    %���û�д��ļ�������������
    if sum(dzfile)==0
        QKtsxx(handles);     return;
    end
    %%%��������Ĳ���
    %����Ĭ��ֵ
    dep=struct('jingdu','102','weidu','31','jfw','0','wfw','500','zjxx','6.0','zjsx','10.0','ssdate','20080101','eedate','20141231','zysdxx','0','zysdsx','30');
    prompt={'̨վ����','̨վγ��','����̨վ�ľ�������(����)','����̨վ�ľ�������(����)','������','������','��ʼ����','��ֹ����','��Դ�������(km)','��Դ�������(km)'};
    title='����Ŀ¼ɸѡ����'; lines=1; resize='off';
    hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
    set(handles.inform,'String',{'����Ӧ������ΪNaN���޶�'},'Fontsize',10,'Fontweight','normal',...
        'Horizontalalignment','left');
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'jingdu','weidu','jfw','wfw','zjxx','zjsx','ssdate','eedate','zysdxx','zysdsx'};
    if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
    %%%�����ʾ��Ϣ��
    QKtsxx(handles);
end
QS=str2num(dep1.QS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%һ���ļ������ļ���ȡ��Щ���
    Fname={Fname};
end
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];        drsj=load(dbfile); %��������
    [~,N]=size(drsj);
    %��������������ݣ��������ļ�
    if N~=2
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    FF=Fname{iiNFZ};
    tname=dep1.TNAME;
    %%%%%%%%%%%%%%%%%%%%%%%
    timej=drsj(:,1);
    data=drsj(:,2);
    %[data,timej]=FillGap(data,timej,QS);%�����
    data(data==QS)=NaN;%�滻ȱ��ΪNaN�����ڻ�ͼ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�̶ȼ�labelλ��
    stdate=timej(1);%��һ��ʱ��
    etdate=timej(end);%���һ��ʱ��
    ttp=length(num2str(timej(1)));%ʱ��λ��
    if ttp==8
        yy=floor(timej/1e4);%��
        mm=mod(floor(timej/1e2),1e2);%��
        dd=mod(timej,1e2);%��
        xx=datenum([yy,mm,dd]);
        tend=timej(end);
    elseif ttp==10
        yy=floor(timej/1e6);%��
        mm=mod(floor(timej/1e4),1e2);%��
        dd=mod(floor(timej/1e2),1e2);%��
        HH=mod(timej,1e2);%Сʱ
        xx=datenum([yy,mm,dd,HH,zeros(length(yy),2)]);
        tend=fix(timej(end)/100);
    elseif ttp==12
        yy=floor(timej/1e8);%��
        mm=mod(floor(timej/1e6),1e2);%��
        dd=mod(floor(timej/1e4),1e2);%��
        HH=mod(floor(timej/1e2),1e2);%Сʱ
        MM=mod(timej,1e2);%����
        xx=datenum([yy,mm,dd,HH,MM,zeros(length(yy),1)]);
        tend=fix(timej(end)/10000);
    end
    styy=mm(1);%��һ���·�
    stnn=yy(1);%��һ�����
    ys=floor((xx(end)-xx(1))/30)+1;%��������
    
    jgt=round(ys/12);%ȡ��������Ϊminortick���,1����������Ϊ�����2��������2��Ϊ���
    if jgt==5
        jgt=4;
    elseif jgt==0
        jgt=1;
    elseif jgt>5
        jgt=12;%6����������ֱ����һ��tick
    end
    
    TickJieguo=FHXtick(jgt,stnn,styy,tend);%����tick��label
    FF=Fname{iiNFZ};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    txfznum=[];
    txzhenji=[];
    if ~isempty(find(inl==2))%
        jingdu=str2num(dep.jingdu);
        weidu=str2num(dep.weidu);
        if  ~isnan(jingdu)&&~isnan(weidu)
            lens1=length(dep.ssdate);
            if lens1==8
                ss1=datenum(dep.ssdate,'yyyymmdd');
            elseif lens1==10
                ss1=datenum(dep.ssdate,'yyyymmddHH');
            elseif lens1==12
                ss1=datenum(dep.ssdate,'yyyymmddHHMM');
            else
                ss1=NaN;
            end
            lens2=length(dep.eedate);
            if lens2==8
                ee1=datenum(dep.eedate,'yyyymmdd');
            elseif lens2==10
                ee1=datenum(dep.eedate,'yyyymmddHH');
            elseif lens2==12
                ee1=datenum(dep.eedate,'yyyymmddHHMM');
            else
                ee1=NaN;
            end
            dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',FF,'.txt');
            var1=str2num(dep.jfw); var2=str2num(dep.wfw);
            var3=str2num(dep.zjxx); var4=str2num(dep.zjsx);
            var5=str2num(dep.zysdxx); var6=str2num(dep.zysdsx);
            [txfznum,txzhenji]=TiaoXuanDiZhen1(1234,0,dzfile,dzoutname,jingdu,weidu,...
                var1,var2,var3,var4,ss1,ee1,var5,var6);
        end
    end
    for jj=1:1:length(inxx)
        for mm=1:1:length(inxc)
            for nn=1:1:length(inxb)
                for qq=1:1:length(inl)
                    plhtzhs1(inl(qq),inxx(jj),inxc(mm),inxb(nn),data,xx,jgt,TickJieguo,Pname,FF,txfznum,txzhenji,dep1.YL,fwcs,tname);
                end
            end
        end
    end
end
set(handles.inform,'String',{'�Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
