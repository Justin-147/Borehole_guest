% --------------------------------------------------------------------
%���ļ����ͷ�����ȡ�ֲ��ͻ��Ʒֲ��Ĺ��ò���
% --------------------------------------------------------------------
function STHCoCaP(handles,op)
tinf={'%�뱣֤��֮ǰ�����������ͷ�������';...
    '%�ҵ�����֮ǰΪ���洢����TH-��ͷ��mat�ļ�'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
[Fname,Pname]=uigetfile({'TH-*.mat','���ͷ�������ļ�(*.mat)'},'����ѡ��������ļ�','MultiSelect','off');
%[Fname,Pname]=uigetfile({'TC_TH-*.mat;TH-*.mat','���ͷ�������ļ�(*.mat)';'TC_TH-*.mat','�޳��쳣���Ľ���ļ�(*.mat)';'TH-*.mat','δ�޳��쳣��Ľ���ļ�(*.mat)'},'����ѡ��������ļ�','MultiSelect','off');
dbfile=[Pname,Fname];
%���û�д��ļ�������������
if sum(dbfile)==0
    %errordlg('���ļ�ʧ�ܣ�', '�ļ�����');
    QKtsxx(handles);     return;
end
load(dbfile);
if (exist('FBM','var')&&exist('Factor','var')&&exist('PhaseL','var')&&exist('Msf','var')&&exist('Msp','var')&&exist('timej','var'))==0
    errordlg('�ļ������ݲ�ȫ����ȷ��֮ǰ���й����ͷ�����', '���ݴ���');
    QKtsxx(handles);     return;
end

if op==1
    dnl=[1,2,3,4];
    [inl,valuel]=listdlg('PromptString','ѡ�����������','SelectionMode',...
        'Multiple','ListString',{'��ϫ����','��ϫ�������','��λ�ͺ�','��λ�ͺ����'},...
        'InitialValue',dnl,'ListSize',[200 250]);
else
    dnl=1;
    [inl,valuel]=listdlg('PromptString','ѡ�����������','SelectionMode',...
        'Single','ListString',{'��ϫ����','��ϫ����(��ע����)','��λ�ͺ�','��λ�ͺ�(��ע����)'},...
        'InitialValue',dnl,'ListSize',[200 250]);
    if valuel==0
        QKtsxx(handles);     return;
    end
    if inl==2||inl==4%��ע��������
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
        hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
        if isempty(hi)
            QKtsxx(handles);     return;
        end
        fields={'jfw','wfw','zjxx','zjsx','zysdxx','zysdsx'};
        if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
        %%%�����ʾ��Ϣ��
        QKtsxx(handles);
    end
end

len=length(FBM);
for ii=1:1:len
    FM{ii}=FBM(ii).name;
end
[inh,valueh]=listdlg('PromptString','ѡ������ķֲ�','SelectionMode',...
    'Multiple','ListString',FM,'InitialValue',1,'ListSize',[200 250]);
if valueh==0
    QKtsxx(handles);     return;
end

f_nn=find(Fname=='.')-1;
f_mm=find(Fname=='-',1)+1;
if isempty(f_mm)
    f_mm=1;
end
if isempty(f_nn)
    f_nn=length(Fname);
end
%�������������
if op==1
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
            datat=data(:,inh(jj)); namel=[FM{inh(jj)},pre];
            namel(isspace(namel))=[];
            outname=strcat(Pname,namel,Fname(f_mm:f_nn),'.txt');
            %             if Fname(1:2)=='TC'
            %                 outname=strcat(Pname,namel,Fname(f_mm:f_nn),'tc.txt');
            %             else
            %                 outname=strcat(Pname,namel,Fname(f_mm:f_nn),'.txt');
            %             end
            fido=fopen(outname,'wt');
            fprintf(fido,'%8i %.5f\n',[timej';datat']);
            fclose(fido);
            %dlmwrite(outname,[timej,datat],'delimiter',' ','precision','%i%f','newline','pc');
        end
    end
    set(handles.inform,'String',{'��ȡ�ķֲ������Ѿ���Ĭ���ļ����������';['����',Pname,'���ҵ�']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
    %��ͼ����
else
    QKtsxx(handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %��ͼ����
    LW=str2num(get(handles.LWED,'String'));%�߿�
    color_error=0.85;%errorbar�ĻҶ�
    cc={'k-','r-','g-','b-','c-','m-','y-','k:','r:','g:','b:','c:','m:','y:',...
        'k-.','r-.','g-.','b-.','c-.','m-.','y-.','k--','r--','g--','b--','c--','m--','y--'};
    %֧��21������
    bs=6;%�������߻��Ʒ�Χ
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    namel=[];
    if inl==1||inl==2
        data=Factor;       edata=Msf;          pre='��ϫ����';
    elseif inl==3||inl==4
        data=PhaseL;       edata=Msp;          pre='��λ�ͺ�';
    end
    
    hold off;
    %�Ȼ���һ��errorbar����plotһ�飬��Ϊ���ܹ������߸�����errorbar֮��
    datat=data(:,inh(1)); ee=edata(:,inh(1)); namel=[namel;FM{inh(1)},pre];
    hpt(1)=errorbar(handles.MainPlotZone,xx,datat,ee,'color',color_error*ones(1,3),'LineStyle','none');
    set(hpt(1),'UserData',ee);
    hold on;
    for jj=2:1:length(inh)
        datat=data(:,inh(jj)); ee=edata(:,inh(jj)); namel=[namel;FM{inh(jj)},pre];
        hpt(jj)=errorbar(handles.MainPlotZone,xx,datat,ee,'color',color_error*ones(1,3),'LineStyle','none');
        set(hpt(jj),'UserData',ee);
    end
    for jj=1:1:length(inh)
        datat=data(:,inh(jj)); ee=edata(:,inh(jj));
        hp(jj)=plot(handles.MainPlotZone,xx,datat,cc{jj},'LineWidth',LW);
        set(hp(jj),'UserData',ee);
        yxi=find(isfinite(datat));
        jzd(jj)=mean(datat(yxi));
        sdd(jj)=std(datat(yxi),1);
    end
    axis tight;    ym=ylim;        xm=xlim;
    %%%%%%%%%��ֹ�����������ݵ���������ƽ
    sxx=max(jzd+bs*sdd);
    xxx=min(jzd-bs*sdd);
    if ym(1)<xxx
        ylim([xxx ym(2)]);
    end
    ym=ylim;
    if ym(2)>sxx
        ylim([ym(1) sxx]);
    end
    ym=ylim;
    %%%%%%%%%��ֹ�����������ݵ���������ƽ
    handles.dzjubing=[];
    handles.zjjubing=[];
    handles.txzhenji=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if inl==2||inl==4
        dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',Fname(f_mm:f_nn),'.txt');
        %         if Fname(1:2)=='TC'
        %             dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',Fname(f_mm:f_nn),'tc.txt');
        %         else
        %             dzoutname=strcat(Pname,'ɸѡ�ĵ���Ŀ¼-',Fname(f_mm:f_nn),'.txt');
        %         end
        [txfznum,txzhenji]=TiaoXuanDiZhen1(1234,1,dzfile,dzoutname,FL,FB,str2num(dep.jfw),str2num(dep.wfw),...
            str2num(dep.zjxx),str2num(dep.zjsx),xx(1),xx(end),str2num(dep.zysdxx),str2num(dep.zysdsx));
        if ~isempty(txfznum)
            lentx=length(txfznum);
            yfw=ym(2)-ym(1);
            yyx=ym(2)-yfw/5;
            yys=ym(2)-yfw/10;
            dzx=[txfznum';txfznum';NaN*ones(1,lentx)];
            dzy=[yyx*ones(1,lentx);yys*ones(1,lentx);NaN*ones(1,lentx)];
            dzx=dzx(:);
            dzy=dzy(:);
            dzjb=plot(handles.MainPlotZone,dzx,dzy,'r-');
            zjjb=text(txfznum,yys*ones(lentx,1),txzhenji,'VerticalAlignment','bottom','HorizontalAlignment','center');
            handles.dzjubing=dzjb;
            handles.zjjubing=zjjb;
            handles.txzhenji=txzhenji;
        end
    end
    
    [h2,h3,h4,h5,h6,cout]=BmTick(handles.MainPlotZone,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn);
    legend(hp,namel);        hold off;
    handles.sj=timej; handles.xx=xx; handles.namel=namel; handles.datexx=[xx(1),xx(end)];
    handles.jubing={h2,h3,h4,h5,h6};
    handles.shuju=cout;
    handles.htjubing=hp;  handles.htjb=[];
    handles.wcjubing=hpt; handles.wcjb=[];
    guidata(gcbo,handles);
    ytt=get(handles.MainPlotZone,'Ytick');
    set(handles.YTMin,'String',num2str(ytt(1)));
    set(handles.YTStep,'String',num2str(ytt(2)-ytt(1)));
    set(handles.YTMax,'String',num2str(ytt(end)));
    set(handles.XTMin,'String',num2str(timej(1)));
    set(handles.XTMax,'String',num2str(timej(end)));
    set(handles.SJLY,'String',['��ѡ���ı������';namel;'ѡ��ȫ������  '],'Value',1);
    KJXpn(handles,'on');
end
return;