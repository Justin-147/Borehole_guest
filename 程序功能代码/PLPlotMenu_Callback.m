% --------------------------------------------------------------------
% 批量绘制调和分析结果图
% --------------------------------------------------------------------
function PLPlotMenu_Callback(hObject, eventdata, handles)
% 批量绘制调和分析结果图
tinf={'%请保证您之前曾经做过调和分析处理';...
    '%找到程序之前为您存储的以TH-打头的mat文件'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%读文件名
[Fname,Pname]=uigetfile({'TH-*.mat','调和分析结果文件(*.mat)'},'请挑选待绘图的文件','MultiSelect','on');
%[Fname,Pname]=uigetfile({'TC_TH-*.mat;TH-*.mat','调和分析结果文件(*.mat)';'TC_TH-*.mat','剔除异常点后的结果文件(*.mat)';'TH-*.mat','未剔除异常点的结果文件(*.mat)'},'请挑选待绘图的文件','MultiSelect','on');
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
[inFW,valueFW]=listdlg('PromptString','是否对绘图纵轴范围进行限定','SelectionMode',...
    'Single','ListString',{'否','几倍方差限定','直接给出范围'},...
    'InitialValue',dnFW,'ListSize',[200 250]);
if valueFW==0
    QKtsxx(handles);     return;
end

if inFW==2
    depfw=struct('bs','6');
    prompt={'超过几倍方差的数据点不绘出'};
    title='绘图范围限定'; resize='off';
    hi=inputdlg(prompt,title,[1 70],struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'bs'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[str2num(depfw.bs),NaN,NaN];
elseif inFW==3
    depfw=struct('yxmi','NaN','yxma','NaN');
    prompt={'y坐标最小值','y坐标最大值'};
    title='绘图范围限定（NaN表示不限定)'; resize='off';
    hi=inputdlg(prompt,title,[1 70],struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'yxmi','yxma'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
    fwcs=[NaN,str2num(depfw.yxmi),str2num(depfw.yxma)];
else
    fwcs=[NaN,NaN,NaN];
end

dnFW2=[1];
[inFW2,valueFW2]=listdlg('PromptString','是否对绘图横轴范围进行限定','SelectionMode',...
    'Single','ListString',{'否','给出范围'},...
    'InitialValue',dnFW2,'ListSize',[200 250]);
if valueFW2==0
    QKtsxx(handles);     return;
end
fwcs2=[NaN,NaN];
if inFW2==2
    depfw2=struct('xxmi','NaN','xxma','NaN');
    prompt={'x坐标最小值','x坐标最大值'};
    title='绘图范围限定（yyyymmdd,NaN表示不限定)'; resize='off';
    hi=inputdlg(prompt,title,[1 70],struct2cell(depfw2),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'xxmi','xxma'};
    if size(hi,1)>0 depfw2=cell2struct(hi,fields,1); end
    fwcs2=[str2num(depfw2.xxmi),str2num(depfw2.xxma)];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%清空提示信息栏
QKtsxx(handles);

dnl=[1,2,3,4];
[inl,valuel]=listdlg('PromptString','选择所需的数据','SelectionMode',...
    'Multiple','ListString',{'潮汐因子','潮汐因子(标注地震)','相位滞后','相位滞后(标注地震)'},...
    'InitialValue',dnl,'ListSize',[200 250]);
if valuel==0
    QKtsxx(handles);     return;
end
if ~isempty(find(inl==2))||~isempty(find(inl==4))%标注地震的情况
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
    prompt={'距离台站的距离下线(公里)','距离台站的距离上限(公里)','震级下限','震级上限','震源深度下限(km)','震源深度上限(km)'};
    title='地震目录筛选参数'; lines=1; resize='off';
    hi=inputdlg(prompt,title,[1 250],lines,struct2cell(dep),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'jfw','wfw','zjxx','zjsx','zysdxx','zysdsx'};
    if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
    %%%清空提示信息栏
    QKtsxx(handles);
end

set(handles.inform,'String','从表中选中您已计算并希望画图的分波','Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
FM={'  Q1','  O1','  M1','  J1','  K1','  S1','  P1','PSK1',' OO1','S1K1',' PI1','PSI1','PHI1',...
    ' 2N2','  N2','  M2','  L2','  S2','  K2','  M3'};
[inh,valueh]=listdlg('PromptString','选择所需的分波','SelectionMode',...
    'Multiple','ListString',FM,'InitialValue',1,'ListSize',[200 250]);
if valueh==0
    QKtsxx(handles);     return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件与多个文件读取有些差别
    Fname={Fname};
end
load('Station.mat');
jwcl=0;%用来统计未处理文件数
for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];        load(dbfile); %导入数据
    if (exist('FBM','var')&&exist('Factor','var')&&exist('PhaseL','var')&&exist('Msf','var')&&exist('Msp','var')&&exist('timej','var'))==0
        jwcl=jwcl+1;
        continue;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    FF=Fname{iiNFZ};
    if length(FF)<19||isempty(strmatch(FF(12:15),SFLDM))%判断测项是否包含在内置表内
        tname='';%图名
    else
        cx=strmatch(FF(12:15),SFLDM);
        houzhui=SFLM(cx,:);
        tkkx=strmatch(strcat(FF(4:8),FF(10)),[TZDM,CDBH]);
        if ~isempty(tkkx)
            tname=[deblank(TZM(tkkx(1),:)),houzhui];
        else
            tname='';
        end
    end
    f_nn=find(FF=='.')-1;
    f_mm=find(FF=='-',1)+1;
    if isempty(f_mm)
        f_mm=1;
    end
    if isempty(f_nn)
        f_nn=length(FF);
    end
    name_FBM=char(struct2cell(FBM));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    if ~isempty(find(inl==2))||~isempty(find(inl==4))
        dzoutname=strcat(Pname,'筛选的地震目录-',FF(f_mm:f_nn),'.txt');
        %         if FF(1:2)=='TC'
        %             dzoutname=strcat(Pname,'筛选的地震目录-',FF(f_mm:f_nn),'tc.txt');
        %         else
        %             dzoutname=strcat(Pname,'筛选的地震目录-',FF(f_mm:f_nn),'.txt');
        %         end
        [txfznum,txzhenji]=TiaoXuanDiZhen1(1234,1,dzfile,dzoutname,FL,FB,str2num(dep.jfw),str2num(dep.wfw),...
            str2num(dep.zjxx),str2num(dep.zjsx),xx(1),xx(end),str2num(dep.zysdxx),str2num(dep.zysdsx));
    else
        txfznum=[];
        txzhenji=[];
    end
    for ii=1:1:length(inl)
        if inl(ii)==1||inl(ii)==2
            data=Factor;       edata=Msf;          pre='潮汐因子';
        elseif inl(ii)==3||inl(ii)==4
            data=PhaseL;       edata=Msp;          pre='相位滞后';
        end
        plhtzhs(inl(ii),inh,name_FBM,FM,data,edata,pre,xx,jgt,TickJieguo,Pname,FF,f_mm,f_nn,txfznum,txzhenji,fwcs,fwcs2,tname);
    end
end
set(handles.inform,'String',{'已经按默认文件名保存完毕';['可在',Pname,'下找到'];[num2str(jwcl),'个文件因数据不全未处理']},...
    'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
