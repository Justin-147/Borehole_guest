% --------------------------------------------------------------------
% �޳��쳣��ֵ��
% --------------------------------------------------------------------
function TCYC_Menu_Callback(hObject, eventdata, handles)
% �޳��쳣��ֵ��
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
dnFW=[1];
[inFW,valueFW]=listdlg('PromptString','�޶���ʽ','SelectionMode',...
    'Single','ListString',{'��׼���޶�','��Χ�޶�'},...
    'InitialValue',dnFW,'ListSize',[200 250]);
if valueFW==0
    QKtsxx(handles);     return;
end

if inFW==1
    depfw=struct('bs','3','QS','999999.0');
    prompt={'����������׼������ݵ��޳�','ȱ�����'};
    title='��׼���޶�'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'bs','QS'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
elseif inFW==2
    depfw=struct('yxmi','0','yxma','1','QS','99999');
    prompt={'��������','��������','ȱ�����'};
    title='��Χ�޶�'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'yxmi','yxma','QS'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
else
    return;
end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%һ���ļ�
    Fname={Fname};
end
QS=str2num(depfw.QS);

if inFW==1
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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dataz(find(dataz==QS))=NaN;%�滻ȱ��ΪNaN�����ڼ���
        bs=str2num(depfw.bs);
        iny=find(isfinite(dataz));
        jz=mean(dataz(iny));
        bzc=std(dataz(iny),1);
        dataz(find(dataz<jz-bs*bzc))=NaN;
        dataz(find(dataz>jz+bs*bzc))=NaN;
        
        dataz(find(isnan(dataz)))=QS;%�滻NaNΪȱ�����
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'-tcyc','.txt');
        fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
        fido=fopen(outname,'wt');
        fprintf(fido,fm,[timet';dataz']);
        fclose(fido);
    end
elseif inFW==2
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
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dataz(find(dataz==QS))=NaN;%�滻ȱ��ΪNaN�����ڼ���
        yxmi=str2num(depfw.yxmi);
        yxma=str2num(depfw.yxma);
        dataz(find(dataz<yxmi))=NaN;
        dataz(find(dataz>yxma))=NaN;
        
        dataz(find(isnan(dataz)))=QS;%�滻NaNΪȱ�����
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'-tcyc','.txt');
        fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
        fido=fopen(outname,'wt');
        fprintf(fido,fm,[timet';dataz']);
        fclose(fido);
    end    
else
    return;
end
set(handles.inform,'String',{'�����������Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�'];'��׺����-tcyc.txt'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
