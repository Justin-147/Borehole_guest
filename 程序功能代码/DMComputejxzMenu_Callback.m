% --------------------------------------------------------------------
% ��ж����Ӧ����������Ĭ�ϼ���ģʽ
% --------------------------------------------------------------------
function DMComputejxzMenu_Callback(hObject, eventdata, handles)
% ��ж����Ӧ����������Ĭ�ϼ���ģʽ
% ���޻���ģ�ͣ���Ӧ��
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��������ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    QKtsxx(handles); return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ�����İ�����Ϣ
tinf='';
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
load('Station.mat');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
j1NFZ=0;%����ͳ��ѡ�е������������Ϲ涨��δ������ļ�����
j2NFZ=0;%����ͳ��ѡ�е�����������������Ҫ��δ������ļ�����
j3NFZ=0;%����ͳ��ѡ�е������ݲ�������ֵ��δ������ļ�����
j4NFZ=0;%����ͳ��ѡ�е���ȱ����Ӧ��̨վ��Ϣ��δ������ļ�����
jzNFZ=0;%����ͳ��ѡ�е�δ������ļ��ܸ���

if NFZ==1%һ���ļ�
    Fname={Fname};
end
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    %�������Ĭ���������ļ����������ļ�
    FF=Fname{iiNFZ};
    cx=strmatch(FF(9:12),SFLDM);%�жϲ����Ƿ���������ñ���
    if length(FF)<12||isempty(cx)
        j1NFZ=j1NFZ+1;
        continue;
    end
    switch cx
        case 1
            dep.IZL='7';%��Ӧ��
        case {2,3,8,9,13,20,15,16,17,18,19,21}
            dep.IZL='2';%�����бNS��EW,ˮ����бNS��EW��NE��NW,ˮƽ����бNS��EW,��ֱ����бNS��EW��NE��NW
        case {4,5,6,7,10,11,12,14}
            dep.IZL='4';%���Ӧ��1-4����,����Ӧ��NS��EW��NE��NW
        otherwise
    end
    
    tkkx=strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]);
    kkx=strmatch(FF(9:12),FLDM(tkkx,:));
    kkx=tkkx(kkx);
    %kkx=intersect(strmatch(strcat(FF(1:5),FF(7)),[TZDM,CDBH]),);
    %���Station.mat�ļ����Ҳ�����Ӧ��Ϣ���������ļ�
    if isempty(kkx)
        j4NFZ=j4NFZ+1;
        continue;
    end
    tmp=load(dbfile); [~,N]=size(tmp);
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
    %�̡߳���λ�ǡ���γ�ȸ�ֵ
    dep.HH=num2str(GC(kkx));
    dep.AZ=num2str(FWJ(kkx));
    dep.FB=num2str(JWD(kkx,2));
    dep.FL=num2str(JWD(kkx,1));
    dep.MX='1';%����ģ��
    dep.SCF='1';%��Ϊȱ�������ͬ�����ǵ�λ��������Ϊ1
    %%%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����
    QS=str2num(dep.QS);
    [dataz,timet]=sjycl(dataz,timet,dep);
    [dataz,timet]=tbds(dataz,timet,QS);%�����
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timeuz=unique(fix(timet/100));%���յ�ʱ������
    handles.canshu=dep; handles.shujuy=dataz;
    handles.tt=timet; handles.shijian=timeuz; 
    handles.pny=Pname; handles.fny=FF;
    handles.stif={['ѡ���ļ�',num2str(NFZ),'��'];['��ʼ��',num2str(iiNFZ),'��']};
    JXZLQ(handles,0,1);
end
jzNFZ=j1NFZ+j2NFZ+j3NFZ+j4NFZ;
set(handles.inform,'String',{['ѡ���ļ�',num2str(NFZ),'��'];['����',num2str(j1NFZ),'�������������Ϲ涨δ����'];...
    [num2str(j2NFZ),'������������������Ҫ��δ����'];[num2str(j3NFZ),'�������ݲ�������ֵδ����'];[num2str(j4NFZ),...
    '����ȱ����Ӧ��̨վ��Ϣδ����'];['����',num2str(jzNFZ),'��δ����']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
return;