% --------------------------------------------------------------------
% 线应变单文件耦合系数计算程序
% --------------------------------------------------------------------
function SFNakaiCompute_Callback(hObject, eventdata, handles)
% 线应变单文件耦合系数计算程序
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示参数的帮助信息
tinf=nakaicanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%输入基本的参数
%设置默认值
dep=struct('MX','1','FB','30','FL','100','HH','0',...
    'AZ','10','SCF','0.1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'拟合模型类型','台站纬度(度,十进制)','台站经度(度,十进制)','高程(米)','观测数据的方位角(度,十进制)','应变单位换算因子',...
    '时间系统','缺数标记','窗长(天,建议30或更长)','步长(天,范围：1至窗长)','结果位置(1至窗长)'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'MX','FB','FL','HH','AZ','SCF','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if dep.MX=='1'||dep.MX=='2'||dep.MX=='3'||dep.MX=='4'
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %读应变文件
    [FnameY,PnameY,datazY,timetY,fbz]=dzdsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选应变文件');
    if fbz==0
        QKtsxx(handles);     return;
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%
    if dep.MX=='2'
        %读气压文件
        [FnameP,PnameP,datazP,timetP,fbz]=dzdsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选气压文件');
        if fbz==0
            QKtsxx(handles);     return;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
    elseif dep.MX=='3'
        [FnameW,PnameW,datazW,timetW,fbz]=dzdsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选水位文件');
        if fbz==0
            QKtsxx(handles);     return;
        end
    elseif dep.MX=='4'
        [FnameP,PnameP,datazP,timetP,fbz]=dzdsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选气压文件');
        if fbz==0
            QKtsxx(handles);     return;
        end
        [FnameW,PnameW,datazW,timetW,fbz]=dzdsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选水位文件');
        if fbz==0
            QKtsxx(handles);     return;
        end
    else
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
else
    QKtsxx(handles);     return; %模型选择错误
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%清空提示信息栏
QKtsxx(handles);
%%%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据
QS=str2num(dep.QS);
[datazY,timetY]=sjycl(datazY,timetY,dep);
[datazY,timetY]=tbds(datazY,timetY,QS);%填补断数
dept.QS=dep.QS; dept.SCF='1';%认为缺数标记相同，但是单位换算因子为1
if dep.MX=='2'
    [datazP,timetP]=sjycl(datazP,timetP,dept);
    [datazP,timetP]=tbds(datazP,timetP,QS);%填补断数
    %挑选公共时段，统一缺数位置，并用NaN替换
    [timet,IY,IP]=intersect(timetY,timetP);
    datazY=datazY(IY);    datazP=datazP(IP);
    qswz=union(find(datazY==QS),find(datazP==QS));
    datazY(qswz)=NaN;    datazP(qswz)=NaN;
    handles.pnp=PnameP; handles.fnp=FnameP; handles.shujup=datazP;
elseif dep.MX=='3'
    [datazW,timetW]=sjycl(datazW,timetW,dept);
    [datazW,timetW]=tbds(datazW,timetW,QS);%填补断数
    %挑选公共时段，统一缺数位置，并用NaN替换
    [timet,IY,IW]=intersect(timetY,timetW);
    datazY=datazY(IY);    datazW=datazW(IW);
    qswz=union(find(datazY==QS),find(datazW==QS));
    datazY(qswz)=NaN;    datazW(qswz)=NaN;
    handles.pnw=PnameW; handles.fnw=FnameW; handles.shujuw=datazW;
elseif dep.MX=='4'
    [datazP,timetP]=sjycl(datazP,timetP,dept);
    [datazP,timetP]=tbds(datazP,timetP,QS);%填补断数
    [datazW,timetW]=sjycl(datazW,timetW,dept);
    [datazW,timetW]=tbds(datazW,timetW,QS);%填补断数
    %挑选公共时段，统一缺数位置，并用NaN替换
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
timeuz=unique(fix(timet/100));%整日的时间序列
handles.canshu=dep;
handles.shijian=timeuz; handles.tt=timet;
handles.pny=PnameY; handles.fny=FnameY; handles.shujuy=datazY;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
NAKAILQ(handles,1,1);
return;