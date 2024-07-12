% --------------------------------------------------------------------
% 单文件绘制time-data形式的二维曲线
% --------------------------------------------------------------------
function Plot_Time_Data_Curve_Single_Callback(hObject, eventdata, handles)
% 批量绘制time-data形式的二维曲线
tinf={'%请保证您挑选的文件为时间序列数据，即：';...
    '%第一列为时间';...
    '%第二列为数据'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%读文件名
[Fname,Pname]=uigetfile({'*.*','时间序列数据(*.*)'},'请挑选待绘图的文件','MultiSelect','off');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    QKtsxx(handles);     return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dnFW=[1];
[inFW,valueFW]=listdlg('PromptString','是否对绘图范围进行限定','SelectionMode',...
    'Single','ListString',{'否','几倍标准差限定','直接给出范围'},...
    'InitialValue',dnFW,'ListSize',[200 250]);
if valueFW==0
    QKtsxx(handles);     return;
end
if inFW==2
    depfw=struct('bs','6');
    prompt={'超过几倍标准差的数据点不绘出'};
    title='绘图范围限定'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'bs'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[str2num(depfw.bs),NaN,NaN];
elseif inFW==3
    depfw=struct('yxmi','0','yxma','1');
    prompt={'y坐标最小值','y坐标最大值'};
    title='绘图范围限定'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'yxmi','yxma'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[NaN,str2num(depfw.yxmi),str2num(depfw.yxma)];
else
    fwcs=[NaN,NaN,NaN];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%清空提示信息栏
QKtsxx(handles);
dep1=struct('QS','999999','YL','应变(10^{-10})','TNAME','');
prompt={'数据中的缺数标记','y轴label','图件标题'};
title='参数设置'; lines=1; resize='off';
hi1=inputdlg(prompt,title,lines,struct2cell(dep1),resize);
if isempty(hi1)
    QKtsxx(handles);     return;
end
fields={'QS','YL','TNAME'};
if size(hi1,1)>0 dep1=cell2struct(hi1,fields,1); end
%%%清空提示信息栏
QKtsxx(handles);
dnxx=[1];
[inxx,valuexx]=listdlg('PromptString','选择曲线类型','SelectionMode',...
    'Single','ListString',{'实线-','点线:','点划线.-','划线--','散点'},...
    'InitialValue',dnxx,'ListSize',[200 250]);
if valuexx==0
    QKtsxx(handles);     return;
end
dnxc=[1];
[inxc,valuexc]=listdlg('PromptString','选择曲线颜色','SelectionMode',...
    'Single','ListString',{'黑色','红色','绿色','蓝色'},...
    'InitialValue',dnxc,'ListSize',[200 250]);
if valuexc==0
    QKtsxx(handles);     return;
end
dnxb=[2];
[inxb,valuexb]=listdlg('PromptString','是否添加y=0的基准线','SelectionMode',...
    'Single','ListString',{'是','否'},...
    'InitialValue',dnxb,'ListSize',[200 250]);
if valuexb==0
    QKtsxx(handles);     return;
end

dnl=[1];
[inl,valuel]=listdlg('PromptString','选择是否标注地震','SelectionMode',...
    'Single','ListString',{'不标注','标注'},...
    'InitialValue',dnl,'ListSize',[200 250]);
if valuel==0
    QKtsxx(handles);     return;
end
if ~isempty(find(inl==2))%标注地震的情况
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
    dep=struct('jingdu','102','weidu','31','jfw','0','wfw','500','zjxx','6.0','zjsx','10.0','ssdate','20080101','eedate','20141231','zysdxx','0','zysdsx','30');
    prompt={'台站经度','台站纬度','距离台站的距离下限(公里)','距离台站的距离上限(公里)','震级下限','震级上限','起始日期','终止日期','震源深度下限(km)','震源深度上限(km)'};
    title='地震目录筛选参数'; lines=1; resize='off';
    hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
    set(handles.inform,'String',{'将对应参数设为NaN则不限定'},'Fontsize',10,'Fontweight','normal',...
        'Horizontalalignment','left');
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'jingdu','weidu','jfw','wfw','zjxx','zjsx','ssdate','eedate','zysdxx','zysdsx'};
    if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
    %%%清空提示信息栏
    QKtsxx(handles);
end
QS=str2num(dep1.QS);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件与多个文件读取有些差别
    Fname={Fname};
end
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];        drsj=load(dbfile); %导入数据
    [~,N]=size(drsj);
    %如果不是两列数据，则跳过文件
    if N~=2
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%
    FF=Fname{iiNFZ};
    tname=dep1.TNAME;
    %%%%%%%%%%%%%%%%%%%%%%%
    timej=drsj(:,1);
    data=drsj(:,2);
    %[data,timej]=FillGap(data,timej,QS);%填补断数
    data(data==QS)=NaN;%替换缺数为NaN，便于画图
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %刻度及label位置
    stdate=timej(1);%第一个时间
    etdate=timej(end);%最后一个时间
    ttp=length(num2str(timej(1)));%时间位数
    if ttp==8
        yy=floor(timej/1e4);%年
        mm=mod(floor(timej/1e2),1e2);%月
        dd=mod(timej,1e2);%日
        xx=datenum([yy,mm,dd]);
        tend=timej(end);
    elseif ttp==10
        yy=floor(timej/1e6);%年
        mm=mod(floor(timej/1e4),1e2);%月
        dd=mod(floor(timej/1e2),1e2);%日
        HH=mod(timej,1e2);%小时
        xx=datenum([yy,mm,dd,HH,zeros(length(yy),2)]);
        tend=fix(timej(end)/100);
    elseif ttp==12
        yy=floor(timej/1e8);%年
        mm=mod(floor(timej/1e6),1e2);%月
        dd=mod(floor(timej/1e4),1e2);%日
        HH=mod(floor(timej/1e2),1e2);%小时
        MM=mod(timej,1e2);%分钟
        xx=datenum([yy,mm,dd,HH,MM,zeros(length(yy),1)]);
        tend=fix(timej(end)/10000);
    end
    styy=mm(1);%第一个月份
    stnn=yy(1);%第一个年份
    ys=floor((xx(end)-xx(1))/30)+1;%大致月数
    
    jgt=round(ys/12);%取几个月作为minortick间隔,1年数据以月为间隔，2年数据以2月为间隔
    if jgt==5
        jgt=4;
    elseif jgt==0
        jgt=1;
    elseif jgt>5
        jgt=12;%6年以上数据直接用一种tick
    end
    
    TickJieguo=FHXtick(jgt,stnn,styy,tend);%返回tick及label
    FF=Fname{iiNFZ};
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    txfznum=[];
    txzhenji=[];
    if ~isempty(find(inl==2))%
        jingdu=str2num(dep.jingdu);
        weidu=str2num(dep.weidu);
        if  ~isnan(jingdu)&&~isnan(weidu)
            lens1=length(dep.ssdate);
            if lens1==8
                ss1=datenum(dep.ssdate,'yyyymmdd');
            elseif lens1==10
                ss1=datenum(dep.ssdate,'yyyymmddHH');
            elseif lens1==12
                ss1=datenum(dep.ssdate,'yyyymmddHHMM');
            else
                ss1=NaN;
            end
            lens2=length(dep.eedate);
            if lens2==8
                ee1=datenum(dep.eedate,'yyyymmdd');
            elseif lens2==10
                ee1=datenum(dep.eedate,'yyyymmddHH');
            elseif lens2==12
                ee1=datenum(dep.eedate,'yyyymmddHHMM');
            else
                ee1=NaN;
            end
            dzoutname=strcat(Pname,'筛选的地震目录-',FF,'.txt');
            var1=str2num(dep.jfw); var2=str2num(dep.wfw);
            var3=str2num(dep.zjxx); var4=str2num(dep.zjsx);
            var5=str2num(dep.zysdxx); var6=str2num(dep.zysdsx);
            [txfznum,txzhenji]=TiaoXuanDiZhen1(1234,0,dzfile,dzoutname,jingdu,weidu,...
                var1,var2,var3,var4,ss1,ee1,var5,var6);
        end
    end
    for jj=1:1:length(inxx)
        for mm=1:1:length(inxc)
            for nn=1:1:length(inxb)
                for qq=1:1:length(inl)
                    plhtzhs1(inl(qq),inxx(jj),inxc(mm),inxb(nn),data,xx,jgt,TickJieguo,Pname,FF,txfznum,txzhenji,dep1.YL,fwcs,tname);
                end
            end
        end
    end
end
set(handles.inform,'String',{'已经按默认文件名保存完毕';['可在',Pname,'下找到']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
