% --------------------------------------------------------------------
% S变换计算调用（tmp）
% --------------------------------------------------------------------
function STransformCompute_Callback(hObject, eventdata, handles)
% S变换计算调用（tmp）
%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname,dataz,timet,fbz]=dllsj({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件');
if fbz==0
    QKtsxx(handles);     return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示参数的帮助信息
%要求数据没有缺数,且长度不能太长
tinf=stcanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%输入基本的参数
%设置默认值
dep=struct('MinFre','0','MaxFre',num2str(fix(length(dataz)/2)),'SR','1','FR','1');
prompt={'计算起始频率','计算终止频率','序列采样率','频率间隔'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'MinFre','MaxFre','SR','FR'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%清空提示信息栏
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tic;%开始计时
[stout,tout,fout] = st(dataz,str2num(dep.MinFre),str2num(dep.MaxFre),str2num(dep.SR),str2num(dep.FR));
f_nn=find(Fname=='.')-1;
if isempty(f_nn)
    f_nn=length(Fname);
end
outname=strcat(Pname,'ST-',Fname(1:f_nn),'.mat');
save(outname,'stout','tout','fout');
ttu=toc/60;%计时结束
tinf={['计算完毕======>','耗时',num2str(ttu),'分钟'];...
    ['S变换的所有结果保存在',outname,'中'];...
    '                                                   ';...
    '可以使用matlab打开查看,其中包含：';'stout:S变换结果';'tout:时间';'fout:频率'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
return;
