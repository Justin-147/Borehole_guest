% --------------------------------------------------------------------
% ��ȱ����ǲ�ȫ��������Ҫ���á������ܴ���\tbds.m��
% --------------------------------------------------------------------
function BQDS_Menu_Callback(hObject, eventdata, handles)
% ��ȱ����ǲ�ȫ��������Ҫ���á������ܴ���\tbds.m��
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
    [datao,timeo]=tbds(dataz,timet,QS);
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'-tbqs','.txt');
    fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
    fido=fopen(outname,'wt');
    fprintf(fido,fm,[timeo';datao']);
    fclose(fido);
end
set(handles.inform,'String',{'�����������Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�'];'��׺Ϊ-tbqs.txt'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
