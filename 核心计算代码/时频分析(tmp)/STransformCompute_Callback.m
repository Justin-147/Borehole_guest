% --------------------------------------------------------------------
% S�任������ã�tmp��
% --------------------------------------------------------------------
function STransformCompute_Callback(hObject, eventdata, handles)
% S�任������ã�tmp��
%%%%%%%%%%%%%%%%%%%%%%%%%%
%���ļ���
[Fname,Pname,dataz,timet,fbz]=dllsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��������ļ�');
if fbz==0
    QKtsxx(handles);     return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ�����İ�����Ϣ
%Ҫ������û��ȱ��,�ҳ��Ȳ���̫��
tinf=stcanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%��������Ĳ���
%����Ĭ��ֵ
dep=struct('MinFre','0','MaxFre',num2str(fix(length(dataz)/2)),'SR','1','FR','1');
prompt={'������ʼƵ��','������ֹƵ��','���в�����','Ƶ�ʼ��'};
title='������ֵ'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'MinFre','MaxFre','SR','FR'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;%��ʼ��ʱ
[stout,tout,fout] = st(dataz,str2num(dep.MinFre),str2num(dep.MaxFre),str2num(dep.SR),str2num(dep.FR));
f_nn=find(Fname=='.')-1;
if isempty(f_nn)
    f_nn=length(Fname);
end
outname=strcat(Pname,'ST-',Fname(1:f_nn),'.mat');
save(outname,'stout','tout','fout');
ttu=toc/60;%��ʱ����
tinf={['�������======>','��ʱ',num2str(ttu),'����'];...
    ['S�任�����н��������',outname,'��'];...
    '                                                   ';...
    '����ʹ��matlab�򿪲鿴,���а�����';'stout:S�任���';'tout:ʱ��';'fout:Ƶ��'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
return;
