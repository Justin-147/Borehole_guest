% --------------------------------------------------------------------
% 单文件调和分析的计算程序
% --------------------------------------------------------------------
function SFTHCompute_Callback(hObject, eventdata, handles)
% 单文件调和分析的计算程序
%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname,dataz,timet,fbz]=dzdsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件');
if fbz==0
    QKtsxx(handles);     return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示参数的帮助信息
tinf=thcanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%输入基本的参数
%设置默认值
dep=struct('FB','30.12','FL','102.18','HH','1450',...
    'AZ','51','SCF','0.1','IZL','4','IBOL','5','IBIAO',...
    '4','IJG','1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'台站纬度(度,十进制)','台站经度(度,十进制)','高程(米)','观测数据的方位角(度,十进制)','单位换算因子',...
    '数据类型','潮汐类型','潮汐表类型','可分潮波结构','时间系统','缺数标记','窗长(天,建议30或更长)','步长(天,范围：1至窗长)','结果位置(1至窗长)'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'FB','FL','HH','AZ','SCF','IZL','IBOL','IBIAO','IJG','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%清空提示信息栏
QKtsxx(handles);
%%%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据
QS=str2num(dep.QS);
[dataz,timet]=sjycl(dataz,timet,dep);
[dataz,timet]=tbds(dataz,timet,QS);%填补断数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
timeuz=unique(fix(timet/100));%整日的时间序列
handles.canshu=dep; handles.shuju=dataz;
handles.shijian=timeuz; handles.pn=Pname;
handles.fn=Fname; 
THFXLQ(handles,1);
return;