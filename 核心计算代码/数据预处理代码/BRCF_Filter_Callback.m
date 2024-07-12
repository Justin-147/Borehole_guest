% --------------------------------------------------------------------
% ����ɷ��˲�
% --------------------------------------------------------------------
function BRCF_Filter_Callback(hObject, eventdata, handles)
% ����ɷ��˲�
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%��ʾ������Ϣ
set(handles.inform,'String',{'����ɷ��˲�����һ��18�׵���ϣ����������ʹ��峱���ģ�ICET���Ƽ�Ϊ�������ͳһʹ�õļ���˲ʱ������Ưֵ�ķ���';...
    '����֮ǰ�Զ����������������'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%��������Ĳ���
%����Ĭ��ֵ
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
        %�����������ֵ���ݣ��������ļ�
        if length(num2str(timet(1)))~=10
            continue;
        end
    end
    %�����    
    [dataz,timet]=tbds(dataz,timet,QS);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dataz(find(dataz==QS))=NaN;%�滻ȱ��ΪNaN�����ڼ���
    
    tmp=dataz;
    
    tmpf2=[ones(2,1)*NaN;dataz(1:end-2)];
    tmpf3=[ones(3,1)*NaN;dataz(1:end-3)];
    tmpf5=[ones(5,1)*NaN;dataz(1:end-5)];
    tmpf8=[ones(8,1)*NaN;dataz(1:end-8)];
    tmpf10=[ones(10,1)*NaN;dataz(1:end-10)];
    tmpf13=[ones(13,1)*NaN;dataz(1:end-13)];
    tmpf18=[ones(18,1)*NaN;dataz(1:end-18)];
    
    tmpz2=[dataz(1+2:end);ones(2,1)*NaN];
    tmpz3=[dataz(1+3:end);ones(3,1)*NaN];
    tmpz5=[dataz(1+5:end);ones(5,1)*NaN];
    tmpz8=[dataz(1+8:end);ones(8,1)*NaN];
    tmpz10=[dataz(1+10:end);ones(10,1)*NaN];
    tmpz13=[dataz(1+13:end);ones(13,1)*NaN];
    tmpz18=[dataz(1+18:end);ones(18,1)*NaN];

    yf=(tmp+tmpf2+tmpf3+tmpf5+tmpf8+tmpf10+tmpf13+tmpf18+tmpz2+tmpz3+tmpz5+tmpz8+tmpz10+tmpz13+tmpz18)/15;%˲ʱ��Ưֵ
    yr=tmp-yf;%ȥ����Ư��Ľ��
    yf(find(isnan(yf)))=QS;%�滻NaNΪȱ�����
    yr(find(isnan(yr)))=QS;%�滻NaNΪȱ�����
    
    f_nn=find(FF=='.')-1;
    outnamef=strcat(Pname,FF(1:f_nn),'-BRFf','.txt');
    outnamer=strcat(Pname,FF(1:f_nn),'-BRFr','.txt');
    fm=strcat('%10i %.5f\n');
    fidof=fopen(outnamef,'wt');
    fprintf(fidof,fm,[timet';yf']);
    fclose(fidof);    
    fidor=fopen(outnamer,'wt');
    fprintf(fidor,fm,[timet';yr']);
    fclose(fidor);     
end
set(handles.inform,'String',{'�˲������������Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�'];'-BRFf.txt��˲ʱ��Ưֵ��-BRFr.txt��ȥ����Ư��Ľ��'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
