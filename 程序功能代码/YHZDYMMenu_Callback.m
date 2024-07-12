% --------------------------------------------------------------------
% 调和分析批量处理，用户自定义模式
% --------------------------------------------------------------------
function YHZDYMMenu_Callback(hObject, eventdata, handles)
% 调和分析批量处理，用户自定义模式
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tinf={'选择自建的引导文件';'引导文件的格式如下：';'文件名 数据类型 纬度(度) 经度(度) 高程(米) 方位角(度)';...
    'D:\整点数据\高淳台\h1.dat 4 31.3531 119.0168 20 146';'D:\整点数据\高淳台\h2.dat 4 31.3531 119.0168 20 11';...
    ' ';' ';'数据类型说明：1重力,2倾斜南北分量,3倾斜东西分量,4应变南北分量,5应变东西分量,6应变剪切分量,7体应变,8面应变'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.*','所有符合要求的文件(*.*)'},'请选择创建好的引导文件','MultiSelect','off');
dbfile=[Pname,Fname];
if sum(dbfile)==0
    %errordlg('打开文件失败！', '文件错误');
    QKtsxx(handles);     return;
end
fid=fopen(dbfile);
str_nouse=fgetl(fid);%跳过文件头
if str_nouse==-1%如果引导文件里没有内容，则跳出程序
    QKtsxx(handles);     return;
end
tmp_para = textscan(fid,'%s%f%f%f%f%f');%读入参数数据
fclose(fid);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示参数的帮助信息
tinf=thcanshuhelp( );
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%输入基本的参数
%设置默认值
dep=struct('SCF','0.1','IBOL','5','IBIAO',...
    '4','IJG','1','IHS','8','QS','999999.0','CCH','30','BCH','5','WZ','30');
prompt={'单位换算因子','潮汐类型','潮汐表类型','可分潮波结构',...
    '时间系统','缺数标记','窗长(天,建议30或更长)','步长(天,范围：1至窗长)','结果位置(1至窗长)'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'SCF','IBOL','IBIAO','IJG','IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%清空提示信息栏
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Full_Name=tmp_para{1};%所有文件的完整路径
Full_Datatype=tmp_para{2};%所有文件的数据类型
Full_Weidu=tmp_para{3};%所有文件的纬度
Full_Jingdu=tmp_para{4};%所有文件的经度
Full_Gaocheng=tmp_para{5};%所有文件的高程
Full_Fangweijiao=tmp_para{6};%所有文件的方位角
weizhi_tichu=find(isnan(Full_Fangweijiao));%查找出参数不完整的行
Full_Name(weizhi_tichu)=[];%剔除不完整的行
Full_Datatype(weizhi_tichu)=[];
Full_Weidu(weizhi_tichu)=[];
Full_Jingdu(weizhi_tichu)=[];
Full_Gaocheng(weizhi_tichu)=[];
Full_Fangweijiao(weizhi_tichu)=[];
NFZ=length(Full_Weidu);%待处理文件个数
j2NFZ=0;%用来统计选中但因数据列数不符合要求，未处理的文件个数
j3NFZ=0;%用来统计选中但因数据不是整点值，未处理的文件个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for iiNFZ=1:1:NFZ
    dbfile=Full_Name{iiNFZ};
    if sum(dbfile)==0%文件名为空，跳过
        continue;
    end
    tmp=load(dbfile); [M,N]=size(tmp);
    %如果不是两列数据，则跳过文件
    if N~=2
        j2NFZ=j2NFZ+1;
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
        %如果不是整点值数据，则跳过文件
        if length(num2str(timet(1)))~=10
            j3NFZ=j3NFZ+1;
            continue;
        end
    end
    dep.IZL=num2str(Full_Datatype(iiNFZ));
    dep.FB=num2str(Full_Weidu(iiNFZ));
    dep.FL=num2str(Full_Jingdu(iiNFZ));
    dep.HH=num2str(Full_Gaocheng(iiNFZ));
    dep.AZ=num2str(Full_Fangweijiao(iiNFZ));    
    %%%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据   
    QS=str2num(dep.QS);
    [dataz,timet]=sjycl(dataz,timet,dep);
    [dataz,timet]=tbds(dataz,timet,QS);%填补断数
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    timeuz=unique(fix(timet/100));%整日的时间序列
    handles.canshu=dep; handles.shuju=dataz;
    handles.shijian=timeuz; 
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fdwz=find(dbfile=='\',1,'last');
    handles.pn=dbfile(1:fdwz);
    handles.fn=dbfile(fdwz+1:length(dbfile));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.stif={['共准备处理文件',num2str(NFZ),'个'];['开始第',num2str(iiNFZ),'个']};
    THFXLQ(handles,0);
end
set(handles.inform,'String',{['共准备处理文件',num2str(NFZ),'个'];['其中',num2str(j2NFZ),'个因数据列数不符合要求未处理'];...
    [num2str(j3NFZ),'个因数据不是整点值未处理']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');




