% --------------------------------------------------------------------
%单文件调和分析抽取分波和绘制分波的公用部分
% --------------------------------------------------------------------
function STHCoCaP(handles,op)
tinf={'%请保证您之前曾经做过调和分析处理';...
    '%找到程序之前为您存储的以TH-打头的mat文件'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
[Fname,Pname]=uigetfile({'TH-*.mat','调和分析结果文件(*.mat)'},'请挑选待处理的文件','MultiSelect','off');
%[Fname,Pname]=uigetfile({'TC_TH-*.mat;TH-*.mat','调和分析结果文件(*.mat)';'TC_TH-*.mat','剔除异常点后的结果文件(*.mat)';'TH-*.mat','未剔除异常点的结果文件(*.mat)'},'请挑选待处理的文件','MultiSelect','off');
dbfile=[Pname,Fname];
%如果没有打开文件，则跳出程序
if sum(dbfile)==0
    %errordlg('打开文件失败！', '文件错误');
    QKtsxx(handles);     return;
end
load(dbfile);
if (exist('FBM','var')&&exist('Factor','var')&&exist('PhaseL','var')&&exist('Msf','var')&&exist('Msp','var')&&exist('timej','var'))==0
    errordlg('文件内数据不全，请确认之前进行过调和分析！', '数据错误');
    QKtsxx(handles);     return;
end

if op==1
    dnl=[1,2,3,4];
    [inl,valuel]=listdlg('PromptString','选择所需的数据','SelectionMode',...
        'Multiple','ListString',{'潮汐因子','潮汐因子误差','相位滞后','相位滞后误差'},...
        'InitialValue',dnl,'ListSize',[200 250]);
else
    dnl=1;
    [inl,valuel]=listdlg('PromptString','选择所需的数据','SelectionMode',...
        'Single','ListString',{'潮汐因子','潮汐因子(标注地震)','相位滞后','相位滞后(标注地震)'},...
        'InitialValue',dnl,'ListSize',[200 250]);
    if valuel==0
        QKtsxx(handles);     return;
    end
    if inl==2||inl==4%标注地震的情况
        set(handles.inform,'String',{'地震目录文件的格式为：';'2008-05-12  14:28:04.0   31.0   103.4   14  Ms8.0  四川汶川县';...
            '2008-05-11  03:42:00.9   24.0   122.5   33  Ms5.6  台湾以东海中'},'Fontsize',10,'Fontweight','normal',...
            'Horizontalalignment','left');
        [dzFname,dzPname]=uigetfile({'*.*','地震目录文件(*.*)'},'请选择地震目录','MultiSelect','off');
        dzfile=[dzPname,dzFname];
        %如果没有打开文件，则跳出程序
        if sum(dzfile)==0
            QKtsxx(handles);     return;
        end
        %%%输入基本的参数
        %设置默认值
        dep=struct('jfw','0','wfw','200','zjxx','5.0','zjsx','10.0','zysdxx','0','zysdsx','50');
        prompt={'距离台站的距离下限(公里)','距离台站的距离上限(公里)','震级下限','震级上限','震源深度下限(km)','震源深度上限(km)'};
        title='地震目录筛选参数'; lines=1; resize='off';
        hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
        if isempty(hi)
            QKtsxx(handles);     return;
        end
        fields={'jfw','wfw','zjxx','zjsx','zysdxx','zysdsx'};
        if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
        %%%清空提示信息栏
        QKtsxx(handles);
    end
end

len=length(FBM);
for ii=1:1:len
    FM{ii}=FBM(ii).name;
end
[inh,valueh]=listdlg('PromptString','选择所需的分波','SelectionMode',...
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
%保存计算结果部分
if op==1
    for ii=1:1:length(inl)
        if inl(ii)==1
            data=Factor;         pre='潮汐因子';
        elseif inl(ii)==2
            data=Msf;            pre='因子误差';
        elseif inl(ii)==3
            data=PhaseL;         pre='相位滞后';
        else
            data=Msp;            pre='相位误差';
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
    set(handles.inform,'String',{'抽取的分波数据已经按默认文件名保存完毕';['可在',Pname,'下找到']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
    %画图部分
else
    QKtsxx(handles);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %刻度及label位置
    xx=datenum(num2str(timej),'yyyymmdd');
    ny=fix(timej/100);%年月
    ys=length(unique(ny));%月数
    jgt=round(ys/12);%取几个月作为minortick间隔,1年数据以月为间隔，2年数据以2月为间隔
    stdate=timej(1);%第一个时间
    if jgt==5
        jgt=4;
    elseif jgt==0
        jgt=1;
    elseif jgt>5
        jgt=12;%6年以上数据直接用一种tick
    end
    styy=mod(fix(stdate/100),100);%第一个月份
    stnn=fix(stdate/10000);%第一个年份
    TickJieguo=FHXtick(jgt,stnn,styy,timej(end));%返回tick及label
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %绘图参数
    LW=str2num(get(handles.LWED,'String'));%线宽
    color_error=0.85;%errorbar的灰度
    cc={'k-','r-','g-','b-','c-','m-','y-','k:','r:','g:','b:','c:','m:','y:',...
        'k-.','r-.','g-.','b-.','c-.','m-.','y-.','k--','r--','g--','b--','c--','m--','y--'};
    %支持21种线型
    bs=6;%控制曲线绘制范围
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    namel=[];
    if inl==1||inl==2
        data=Factor;       edata=Msf;          pre='潮汐因子';
    elseif inl==3||inl==4
        data=PhaseL;       edata=Msp;          pre='相位滞后';
    end
    
    hold off;
    %先画了一遍errorbar，又plot一遍，是为了能够让曲线覆盖在errorbar之上
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
    %%%%%%%%%防止由于奇异数据导致曲线拉平
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
    %%%%%%%%%防止由于奇异数据导致曲线拉平
    handles.dzjubing=[];
    handles.zjjubing=[];
    handles.txzhenji=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if inl==2||inl==4
        dzoutname=strcat(Pname,'筛选的地震目录-',Fname(f_mm:f_nn),'.txt');
        %         if Fname(1:2)=='TC'
        %             dzoutname=strcat(Pname,'筛选的地震目录-',Fname(f_mm:f_nn),'tc.txt');
        %         else
        %             dzoutname=strcat(Pname,'筛选的地震目录-',Fname(f_mm:f_nn),'.txt');
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
    set(handles.SJLY,'String',['挑选欲改变的曲线';namel;'选中全部曲线  '],'Value',1);
    KJXpn(handles,'on');
end
return;