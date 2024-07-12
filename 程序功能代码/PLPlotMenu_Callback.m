% --------------------------------------------------------------------
% �������Ƶ��ͷ������ͼ
% --------------------------------------------------------------------
function PLPlotMenu_Callback(hObject, eventdata, handles)
% �������Ƶ��ͷ������ͼ
tinf={'%�뱣֤��֮ǰ�����������ͷ�������';...
    '%�ҵ�����֮ǰΪ���洢����TH-��ͷ��mat�ļ�'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%���ļ���
[Fname,Pname]=uigetfile({'TH-*.mat','���ͷ�������ļ�(*.mat)'},'����ѡ����ͼ���ļ�','MultiSelect','on');
%[Fname,Pname]=uigetfile({'TC_TH-*.mat;TH-*.mat','���ͷ�������ļ�(*.mat)';'TC_TH-*.mat','�޳��쳣���Ľ���ļ�(*.mat)';'TH-*.mat','δ�޳��쳣��Ľ���ļ�(*.mat)'},'����ѡ����ͼ���ļ�','MultiSelect','on');
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
[inFW,valueFW]=listdlg('PromptString','�Ƿ�Ի�ͼ���᷶Χ�����޶�','SelectionMode',...
    'Single','ListString',{'��','���������޶�','ֱ�Ӹ�����Χ'},...
    'InitialValue',dnFW,'ListSize',[200 250]);
if valueFW==0
    QKtsxx(handles);     return;
end

if inFW==2
    depfw=struct('bs','6');
    prompt={'����������������ݵ㲻���'};
    title='��ͼ��Χ�޶�'; resize='off';
    hi=inputdlg(prompt,title,[1 70],struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'bs'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[str2num(depfw.bs),NaN,NaN];
elseif inFW==3
    depfw=struct('yxmi','NaN','yxma','NaN');
    prompt={'y������Сֵ','y�������ֵ'};
    title='��ͼ��Χ�޶���NaN��ʾ���޶�)'; resize='off';
    hi=inputdlg(prompt,title,[1 70],struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'yxmi','yxma'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[NaN,str2num(depfw.yxmi),str2num(depfw.yxma)];
else
    fwcs=[NaN,NaN,NaN];
end

dnFW2=[1];
[inFW2,valueFW2]=listdlg('PromptString','�Ƿ�Ի�ͼ���᷶Χ�����޶�','SelectionMode',...
    'Single','ListString',{'��','������Χ'},...
    'InitialValue',dnFW2,'ListSize',[200 250]);
if valueFW2==0
    QKtsxx(handles);     return;
end
fwcs2=[NaN,NaN];
if inFW2==2
    depfw2=struct('xxmi','NaN','xxma','NaN');
    prompt={'x������Сֵ','x�������ֵ'};
    title='��ͼ��Χ�޶���yyyymmdd,NaN��ʾ���޶�)'; resize='off';
    hi=inputdlg(prompt,title,[1 70],struct2cell(depfw2),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'xxmi','xxma'};
    if size(hi,1)>0 depfw2=cell2struct(hi,fields,1); end
    fwcs2=[str2num(depfw2.xxmi),str2num(depfw2.xxma)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%�����ʾ��Ϣ��
QKtsxx(handles);

dnl=[1,2,3,4];
[inl,valuel]=listdlg('PromptString','ѡ�����������','SelectionMode',...
    'Multiple','ListString',{'��ϫ����','��ϫ����(��ע����)','��λ�ͺ�','��λ�ͺ�(��ע����)'},...
    'InitialValue',dnl,'ListSize',[200 250]);
if valuel==0
    QKtsxx(handles);     return;
end
if ~isempty(find(inl==2))||~isempty(find(inl==4))%��ע��������
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
    dep=struct('jfw','0','wfw','200','zjxx','5.0','zjsx','10.0','zysdxx','0','zysdsx','50');
    prompt={'����̨վ�ľ�������(����)','����̨վ�ľ�������(����)','������','������','��Դ�������(km)','��Դ�������(km)'};
    title='����Ŀ¼ɸѡ����'; lines=1; resize='off';
    hi=inputdlg(prompt,title,[1 250],lines,struct2cell(dep),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'jfw','wfw','zjxx','zjsx','zysdxx','zysdsx'};
    if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
    %%%�����ʾ��Ϣ��
    QKtsxx(handles);
end

set(handles.inform,'String','�ӱ���ѡ�����Ѽ��㲢ϣ����ͼ�ķֲ�','Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
FM={'  Q1','  O1','  M1','  J1','  K1','  S1','  P1','PSK1',' OO1','S1K1',' PI1','PSI1','PHI1',...
    ' 2N2','  N2','  M2','  L2','  S2','  K2','  M3'};
[inh,valueh]=listdlg('PromptString','ѡ������ķֲ�','SelectionMode',...
    'Multiple','ListString',FM,'InitialValue',1,'ListSize',[200 250]);
if valueh==0
    QKtsxx(handles);     return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%һ���ļ������ļ���ȡ��Щ���
    Fname={Fname};
end
load('Station.mat');
jwcl=0;%����ͳ��δ�����ļ���
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];        load(dbfile); %��������
    if (exist('FBM','var')&&exist('Factor','var')&&exist('PhaseL','var')&&exist('Msf','var')&&exist('Msp','var')&&exist('timej','var'))==0
        jwcl=jwcl+1;
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %�̶ȼ�labelλ��
    xx=datenum(num2str(timej),'yyyymmdd');
    ny=fix(timej/100);%����
    ys=length(unique(ny));%����
    jgt=round(ys/12);%ȡ��������Ϊminortick���,1����������Ϊ�����2��������2��Ϊ���
    stdate=timej(1);%��һ��ʱ��
    if jgt==5
        jgt=4;
    elseif jgt==0
        jgt=1;
    elseif jgt>5
        jgt=12;%6����������ֱ����һ��tick
    end
    styy=mod(fix(stdate/100),100);%��һ���·�
    stnn=fix(stdate/10000);%��һ�����
    TickJieguo=FHXtick(jgt,stnn,styy,timej(end));%����tick��label
    FF=Fname{iiNFZ};
    if length(FF)<19||isempty(strmatch(FF(12:15),SFLDM))%�жϲ����Ƿ���������ñ���
        tname='';%ͼ��
    else
        cx=strmatch(FF(12:15),SFLDM);
        houzhui=SFLM(cx,:);
        tkkx=strmatch(strcat(FF(4:8),FF(10)),[TZDM,CDBH]);
        if ~isempty(tkkx)
            tname=[deblank(TZM(tkkx(1),:)),houzhui];
        else
            tname='';
        end
    end
    f_nn=find(FF=='.')-1;
    f_mm=find(FF=='-',1)+1;
    if isempty(f_mm)
        f_mm=1;
    end
    if isempty(f_nn)
        f_nn=length(FF);
    end
    name_FBM=char(struct2cell(FBM));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(find(inl==2))||~isempty(find(inl==4))
        dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',FF(f_mm:f_nn),'.txt');
        %         if FF(1:2)=='TC'
        %             dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',FF(f_mm:f_nn),'tc.txt');
        %         else
        %             dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',FF(f_mm:f_nn),'.txt');
        %         end
        [txfznum,txzhenji]=TiaoXuanDiZhen1(1234,1,dzfile,dzoutname,FL,FB,str2num(dep.jfw),str2num(dep.wfw),...
            str2num(dep.zjxx),str2num(dep.zjsx),xx(1),xx(end),str2num(dep.zysdxx),str2num(dep.zysdsx));
    else
        txfznum=[];
        txzhenji=[];
    end
    for ii=1:1:length(inl)
        if inl(ii)==1||inl(ii)==2
            data=Factor;       edata=Msf;          pre='��ϫ����';
        elseif inl(ii)==3||inl(ii)==4
            data=PhaseL;       edata=Msp;          pre='��λ�ͺ�';
        end
        plhtzhs(inl(ii),inh,name_FBM,FM,data,edata,pre,xx,jgt,TickJieguo,Pname,FF,f_mm,f_nn,txfznum,txzhenji,fwcs,fwcs2,tname);
    end
end
set(handles.inform,'String',{'�Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�'];[num2str(jwcl),'���ļ������ݲ�ȫδ����']},...
    'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
