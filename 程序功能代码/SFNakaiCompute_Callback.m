% --------------------------------------------------------------------
% ��Ӧ�䵥�ļ����ϵ���������
% --------------------------------------------------------------------
function SFNakaiCompute_Callback(hObject, eventdata, handles)
% ��Ӧ�䵥�ļ����ϵ���������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ�����İ�����Ϣ
tinf=nakaicanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%��������Ĳ���
%����Ĭ��ֵ
dep=struct('MX','1','FB','30','FL','100','HH','0',...
    'AZ','10','SCF','0.1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'���ģ������','̨վγ��(��,ʮ����)','̨վ����(��,ʮ����)','�߳�(��)','�۲����ݵķ�λ��(��,ʮ����)','Ӧ�䵥λ��������',...
    'ʱ��ϵͳ','ȱ�����','����(��,����30�����)','����(��,��Χ��1������)','���λ��(1������)'};
title='������ֵ'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'MX','FB','FL','HH','AZ','SCF','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if dep.MX=='1'||dep.MX=='2'||dep.MX=='3'||dep.MX=='4'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %��Ӧ���ļ�
    [FnameY,PnameY,datazY,timetY,fbz]=dzdsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡӦ���ļ�');
    if fbz==0
        QKtsxx(handles);     return;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    if dep.MX=='2'
        %����ѹ�ļ�
        [FnameP,PnameP,datazP,timetP,fbz]=dzdsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��ѹ�ļ�');
        if fbz==0
            QKtsxx(handles);     return;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif dep.MX=='3'
        [FnameW,PnameW,datazW,timetW,fbz]=dzdsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡˮλ�ļ�');
        if fbz==0
            QKtsxx(handles);     return;
        end
    elseif dep.MX=='4'
        [FnameP,PnameP,datazP,timetP,fbz]=dzdsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡ��ѹ�ļ�');
        if fbz==0
            QKtsxx(handles);     return;
        end
        [FnameW,PnameW,datazW,timetW,fbz]=dzdsj({'*.txt','txt�ļ�(*.txt)';'*.dat','dat�ļ�(*.dat)';'*.*','���з���Ҫ����ļ�(*.*)'},'����ѡˮλ�ļ�');
        if fbz==0
            QKtsxx(handles);     return;
        end
    else
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    QKtsxx(handles);     return; %ģ��ѡ�����
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%�����ʾ��Ϣ��
QKtsxx(handles);
%%%����Ԥ������ɵ�λ���㣬�ӵ�һ����ȱ����0�����ݿ�ʼ��ȡ����
QS=str2num(dep.QS);
[datazY,timetY]=sjycl(datazY,timetY,dep);
[datazY,timetY]=tbds(datazY,timetY,QS);%�����
dept.QS=dep.QS; dept.SCF='1';%��Ϊȱ�������ͬ�����ǵ�λ��������Ϊ1
if dep.MX=='2'
    [datazP,timetP]=sjycl(datazP,timetP,dept);
    [datazP,timetP]=tbds(datazP,timetP,QS);%�����
    %��ѡ����ʱ�Σ�ͳһȱ��λ�ã�����NaN�滻
    [timet,IY,IP]=intersect(timetY,timetP);
    datazY=datazY(IY);    datazP=datazP(IP);
    qswz=union(find(datazY==QS),find(datazP==QS));
    datazY(qswz)=NaN;    datazP(qswz)=NaN;
    handles.pnp=PnameP; handles.fnp=FnameP; handles.shujup=datazP;
elseif dep.MX=='3'
    [datazW,timetW]=sjycl(datazW,timetW,dept);
    [datazW,timetW]=tbds(datazW,timetW,QS);%�����
    %��ѡ����ʱ�Σ�ͳһȱ��λ�ã�����NaN�滻
    [timet,IY,IW]=intersect(timetY,timetW);
    datazY=datazY(IY);    datazW=datazW(IW);
    qswz=union(find(datazY==QS),find(datazW==QS));
    datazY(qswz)=NaN;    datazW(qswz)=NaN;
    handles.pnw=PnameW; handles.fnw=FnameW; handles.shujuw=datazW;
elseif dep.MX=='4'
    [datazP,timetP]=sjycl(datazP,timetP,dept);
    [datazP,timetP]=tbds(datazP,timetP,QS);%�����
    [datazW,timetW]=sjycl(datazW,timetW,dept);
    [datazW,timetW]=tbds(datazW,timetW,QS);%�����
    %��ѡ����ʱ�Σ�ͳһȱ��λ�ã�����NaN�滻
    timet=intersect(intersect(timetY,timetP),timetW);
    [tt,IY,II]=intersect(timetY,timet);
    [tt,IP,II]=intersect(timetP,timet);
    [tt,IW,II]=intersect(timetW,timet);
    datazY=datazY(IY);    datazP=datazP(IP);    datazP=datazP(IW);
    qswz=union(union(find(datazY==QS),find(datazP==QS)),find(datazW==QS));
    datazY(qswz)=NaN;    datazP(qswz)=NaN;    datazW(qswz)=NaN;
    handles.pnp=PnameP; handles.fnp=FnameP; handles.shujup=datazP;
    handles.pnw=PnameW; handles.fnw=FnameW; handles.shujuw=datazW;
else
    timet=timetY;   datazY(find(datazY==QS))=NaN;
end
timeuz=unique(fix(timet/100));%���յ�ʱ������
handles.canshu=dep;
handles.shijian=timeuz; handles.tt=timet;
handles.pny=PnameY; handles.fny=FnameY; handles.shujuy=datazY;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NAKAILQ(handles,1,1);
return;