% --------------------------------------------------------------------
% ��ʱֵ���վ�ֵȱʧ��ֵԤ����(��ʱֵ����ȱʧ������24h���վ�ֵ����ȱʧ������4��ֵ)
% --------------------------------------------------------------------
function NBSJ_CZ_Callback(hObject, eventdata, handles)
% ��ʱֵ���վ�ֵȱʧ��ֵԤ����(��ʱֵ����ȱʧ������24h���վ�ֵ����ȱʧ������4��ֵ)
% ����ȱ��λ�õ������Ե���������ܽ���ʵ�ֲ��ֲ�ֵ�Ĳ�ֵ
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ������Ϣ
tinf={'��ʱֵ���վ�ֵȱʧ��ֵԤ����(��ʱֵ����ȱʧ������24h���վ�ֵ����ȱʧ������4��ֵ)';...
    '����ȱ��λ�õ������Ե���������ܽ���ʵ�ֲ��ֲ�ֵ�Ĳ�ֵ������Ҫ����ǰ���ݱ����������ģ������ж���';...
    '����ǰ�Զ������ˡ�ȱ����ǲ�ȫ������'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname]=uigetfile({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��������ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    QKtsxx(handles);     return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dep=struct('QS','999999.0');
prompt={'ȱ�����'};
title='������ֵ'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'QS'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%һ���ļ�
    Fname={Fname};
end
QS=str2num(dep.QS);

for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile); [M,N]=size(tmp);
    %��������������ݣ��������ļ�
    if N~=2
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
    end
    %�����
    [dataz,timet]=tbds(dataz,timet,QS);
    %��ֵ
    inq=find(dataz==QS);%��λȱ��λ��
    dataz(inq)=NaN;%�滻ȱ�����ΪNaN���ڼ���
    lentm=length(num2str(timet(1)));
    lendata=length(dataz);
    
    if lentm==10%����ֵ
        xzs1=48;        xzs2=48;
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));%��λ���Խ��в�ֵ��ȱ��λ��
        %���ﲻ�ÿ����ۼ�����ȱֵʱ���Ƿ����24h,����NaN�����룬������ʵ��
        if isempty(iny)==0
            inyy=inq(iny);
            tmp=(4*(dataz(inyy+24)+dataz(inyy-24))-(dataz(inyy+48)+dataz(inyy-48)))/6;
            dataz(inyy)=tmp;
        end
    elseif lentm==8%�վ�ֵ
        %��ֵ��ȱ1����ֵ������2��������3��������4����������Ƚϸ���
        %������������4�δ�����ʵ��
        xzs1=2;        xzs2=2;%��1��
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmp=(4*(dataz(inyy+1)+dataz(inyy-1))-(dataz(inyy+2)+dataz(inyy-2)))/6;
            dataz(inyy)=tmp;
        end
        xzs1=2;        xzs2=3;%��2��
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmpz1=(10*dataz(inyy+2)+5*dataz(inyy-1)-3*dataz(inyy+3)-2*dataz(inyy-2))/10;
            tmp=(10*dataz(inyy-1)+5*dataz(inyy+2)-3*dataz(inyy-2)-2*dataz(inyy+3))/10;
            dataz(inyy)=tmp; dataz(inyy+1)=tmpz1;
        end
        xzs1=3;        xzs2=3;%��3��
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmpz1=(12*dataz(inyy+2)+4*dataz(inyy-2)-4*dataz(inyy+3)-2*dataz(inyy-3))/10;
            tmpf1=(12*dataz(inyy-2)+4*dataz(inyy+2)-4*dataz(inyy-3)-2*dataz(inyy+3))/10;
            tmp=(9*dataz(inyy-2)+9*dataz(inyy+2)-4*dataz(inyy+3)-4*dataz(inyy-3))/10;
            dataz(inyy)=tmp; dataz(inyy+1)=tmpz1; dataz(inyy-1)=tmpf1;
        end
        xzs1=4;        xzs2=3;%��4��
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmpf2=(28*dataz(inyy-3)+7*dataz(inyy+2)-10*dataz(inyy-4)-4*dataz(inyy+3))/21;
            tmpz1=(28*dataz(inyy+2)+7*dataz(inyy-3)-10*dataz(inyy+3)-4*dataz(inyy-4))/21;
            tmpf1=(42*dataz(inyy-3)+28*dataz(inyy+2)-20*dataz(inyy-4)-15*dataz(inyy+3))/35;
            tmp=(42*dataz(inyy+2)+28*dataz(inyy-3)-20*dataz(inyy+3)-15*dataz(inyy-4))/35;
            dataz(inyy)=tmp; dataz(inyy+1)=tmpz1; dataz(inyy-1)=tmpf1;  dataz(inyy-2)=tmpf2;
        end
    else
        return;
    end
    dataz(isnan(dataz))=QS;
    
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'-cz','.txt');
    fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
    fido=fopen(outname,'wt');
    fprintf(fido,fm,[timet';dataz']);
    fclose(fido);
end
set(handles.inform,'String',{'�����������Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�'];'��׺Ϊ-cz.txt'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
