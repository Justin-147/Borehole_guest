% --------------------------------------------------------------------
% ������ȡ��Ҫ�ֲ����ݱ���
% --------------------------------------------------------------------
function CQXYFB_Callback(hObject, eventdata, handles)
% ������ȡ��Ҫ�ֲ����ݱ���
tinf={'%�뱣֤��֮ǰ�����������ͷ�������';...
    '%�ҵ�����֮ǰΪ���洢����TH-��ͷ��mat�ļ�'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%���ļ���
[Fname,Pname]=uigetfile({'TH-*.mat','���ͷ�������ļ�(*.mat)'},'����ѡ��������ļ�','MultiSelect','on');
%[Fname,Pname]=uigetfile({'TC_TH-*.mat;TH-*.mat','���ͷ�������ļ�(*.mat)';'TC_TH-*.mat','�޳��쳣���Ľ���ļ�(*.mat)';'TH-*.mat','δ�޳��쳣��Ľ���ļ�(*.mat)'},'����ѡ��������ļ�','MultiSelect','on');
%�����ļ�·��
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %���û�д��ļ�������������
    QKtsxx(handles);     return;
else
    NFZ=1;
end
dnl=[1,2,3,4];
[inl,valuel]=listdlg('PromptString','ѡ�����������','SelectionMode',...
    'Multiple','ListString',{'��ϫ����','��ϫ�������','��λ�ͺ�','��λ�ͺ����'...
    },'InitialValue',dnl,'ListSize',[200 250]);
if valuel==0
    QKtsxx(handles);     return;
end
FM={'  Q1','  O1','  M1','  J1','  K1','  S1','  P1','PSK1',' OO1','S1K1',' PI1','PSI1','PHI1',...
    ' 2N2','  N2','  M2','  L2','  S2','  K2','  M3'};
[inh,valueh]=listdlg('PromptString','ѡ������ķֲ�','SelectionMode',...
    'Multiple','ListString',FM,'InitialValue',1,'ListSize',[200 250]);
if valueh==0
    QKtsxx(handles);     return;
end
set(handles.inform,'String','�ӱ���ѡ�����Ѽ��㲢ϣ����ѡ���ķֲ�','Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
if NFZ==1%һ���ļ�
    Fname={Fname};
end

for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    load(dbfile); %��������
    if (exist('FBM','var')&&exist('Factor','var')&&exist('PhaseL','var')&&exist('Msf','var')&&exist('Msp','var')&&exist('timej','var'))==0
        set(handles.inform,'String','�����ݲ�ȫδ����','Fontsize',10,'Fontweight','normal','Horizontalalignment','left'); return;
    end
    FF=Fname{iiNFZ};
    f_nn=find(FF=='.')-1;
    f_mm=find(FF=='-',1)+1;
    if isempty(f_mm)
        f_mm=1;
    end
    if isempty(f_nn)
        f_nn=length(FF);
    end
    name_FBM=char(struct2cell(FBM));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii=1:1:length(inl)
        if inl(ii)==1
            data=Factor;         pre='��ϫ����';
        elseif inl(ii)==2
            data=Msf;            pre='�������';
        elseif inl(ii)==3
            data=PhaseL;         pre='��λ�ͺ�';
        else
            data=Msp;            pre='��λ���';
        end
        data(find(isnan(data)==1))=QS;
        for jj=1:1:length(inh)
            hh=strmatch(FM{inh(jj)},name_FBM);
            datat=data(:,hh); namel=[FM{inh(jj)},pre];
            namel(isspace(namel))=[];
            outname=strcat(Pname,namel,FF(f_mm:f_nn),'.txt');
            %             if FF(1:2)=='TC'
            %                 outname=strcat(Pname,namel,FF(f_mm:f_nn),'tc.txt');
            %             else
            %                 outname=strcat(Pname,namel,FF(f_mm:f_nn),'.txt');
            %             end
            fido=fopen(outname,'wt');
            fprintf(fido,'%8i %.5f\n',[timej';datat']);
            fclose(fido);
        end
    end
end
set(handles.inform,'String',{'��ȡ�ķֲ������Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
end