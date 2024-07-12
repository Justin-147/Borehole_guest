% --------------------------------------------------------------------
% 加卸载响应比批量处理，用户自定义模式
% --------------------------------------------------------------------
function YHZDYMjxzMenu_Callback(hObject, eventdata, handles)
% 加卸载响应比批量处理，用户自定义模式
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
tinf={'选择自建的引导文件';'引导文件的格式如下：';'文件名 模型类型 纬度(度) 经度(度) 高程(米) 方位角(度)';...
    'D:\整点数据\高淳台\h1.dat 4 31.3531 119.0168 20 146';'D:\整点数据\高淳台\P.dat 4 31.3531 119.0168 20 11';...
    'D:\整点数据\高淳台\W.dat 4 31.3531 119.0168 20 11';' ';' ';...
    '模型类型说明：1基本模型,2考虑气压影响的模型,3考虑水位影响的模型,4同时考虑气压、水位影响的模型';...
    '注意：引导文件中模型类型需要输入正确，文件数量和顺序需要和模型类型相符'};
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
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%输入基本的参数
%设置默认值
dep=struct('IHS','8','QS','999999.0','CCH','30','BCH','10','WZ','30');
prompt={'时间系统','缺数标记','窗长(天,建议30或更长)','步长(天,范围：1至窗长)','结果位置(1至窗长)'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'IHS','QS','CCH','BCH','WZ'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%清空提示信息栏
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Full_Name=tmp_para{1};%所有文件的完整路径
Full_Modeltype=tmp_para{2};%所有文件的模型类型
Full_Weidu=tmp_para{3};%所有文件的纬度
Full_Jingdu=tmp_para{4};%所有文件的经度
Full_Gaocheng=tmp_para{5};%所有文件的高程
Full_Fangweijiao=tmp_para{6};%所有文件的方位角
NFZ=length(Full_Weidu);%待处理文件个数
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
iiNFZ=1;%起始
while (1)%如果用for循环，内部更改循环参量值对外部无影响
    dep.MX=num2str(Full_Modeltype(iiNFZ));
    dep.FB=num2str(Full_Weidu(iiNFZ));
    dep.FL=num2str(Full_Jingdu(iiNFZ));
    dep.HH=num2str(Full_Gaocheng(iiNFZ));
    dep.AZ=num2str(Full_Fangweijiao(iiNFZ));
    dep.QS=dep.QS; dep.SCF='1';%认为缺数标记相同，但是单位换算因子为1
    if dep.MX=='1'||dep.MX=='2'||dep.MX=='3'||dep.MX=='4'
        %读应变文件
        dbfileY=Full_Name{iiNFZ};
        [datazY,timetY,fbz]=dzdsj1(dbfileY);
        if fbz==0
            iiNFZ=iiNFZ+floor(str2num(dep.MX)/2)+1;
            continue;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%
        if dep.MX=='2'
            %读气压文件
            iiNFZ=iiNFZ+1;
            dbfileP=Full_Name{iiNFZ};
            [datazP,timetP,fbz]=dzdsj1(dbfileP);
            if fbz==0
                iiNFZ=iiNFZ+1; continue;
            end
            %%%%%%%%%%%%%%%%%%%%%%%%%%
        elseif dep.MX=='3'
            %读水位文件
            iiNFZ=iiNFZ+1;
            dbfileW=Full_Name{iiNFZ};
            [datazW,timetW,fbz]=dzdsj1(dbfileW);
            if fbz==0
                iiNFZ=iiNFZ+1; continue;
            end
        elseif dep.MX=='4'
            %读气压文件
            iiNFZ=iiNFZ+1;
            dbfileP=Full_Name{iiNFZ};
            [datazP,timetP,fbz]=dzdsj1(dbfileP);
            if fbz==0
                iiNFZ=iiNFZ+2; continue;
            end
            %读水位文件
            iiNFZ=iiNFZ+1;
            dbfileW=Full_Name{iiNFZ};
            [datazW,timetW,fbz]=dzdsj1(dbfileW);
            if fbz==0
                iiNFZ=iiNFZ+1; continue;
            end
        else
        end
    else
        tinf={'引导文件中存在模型类别输入错误的行，导致提前结束'};
        set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
        return; %模型选择错误
    end
    %%%数据预处理，完成单位换算，从第一个非缺数的0点数据开始截取数据
    QS=str2num(dep.QS);
    [datazY,timetY]=sjycl(datazY,timetY,dep);
    [datazY,timetY]=tbds(datazY,timetY,QS);%填补断数
    if dep.MX=='2'
        [datazP,timetP]=sjycl(datazP,timetP,dep);
        [datazP,timetP]=tbds(datazP,timetP,QS);%填补断数
        %挑选公共时段，统一缺数位置，并用NaN替换
        [timet,IY,IP]=intersect(timetY,timetP);
        datazY=datazY(IY);    datazP=datazP(IP);
        qswz=union(find(datazY==QS),find(datazP==QS));
        datazY(qswz)=NaN;    datazP(qswz)=NaN;
        handles.shujup=datazP;
    elseif dep.MX=='3'
        [datazW,timetW]=sjycl(datazW,timetW,dep);
        [datazW,timetW]=tbds(datazW,timetW,QS);%填补断数
        %挑选公共时段，统一缺数位置，并用NaN替换
        [timet,IY,IW]=intersect(timetY,timetW);
        datazY=datazY(IY);    datazW=datazW(IW);
        qswz=union(find(datazY==QS),find(datazW==QS));
        datazY(qswz)=NaN;    datazW(qswz)=NaN;
        handles.shujuw=datazW;
    elseif dep.MX=='4'
        [datazP,timetP]=sjycl(datazP,timetP,dep);
        [datazP,timetP]=tbds(datazP,timetP,QS);%填补断数
        [datazW,timetW]=sjycl(datazW,timetW,dep);
        [datazW,timetW]=tbds(datazW,timetW,QS);%填补断数
        %挑选公共时段，统一缺数位置，并用NaN替换
        timet=intersect(intersect(timetY,timetP),timetW);
        [tt,IY,II]=intersect(timetY,timet);
        [tt,IP,II]=intersect(timetP,timet);
        [tt,IW,II]=intersect(timetW,timet);
        datazY=datazY(IY);    datazP=datazP(IP);    datazP=datazP(IW);
        qswz=union(union(find(datazY==QS),find(datazP==QS)),find(datazW==QS));
        datazY(qswz)=NaN;    datazP(qswz)=NaN;    datazW(qswz)=NaN;
        handles.shujup=datazP; handles.shujuw=datazW;
    else
        timet=timetY;   datazY(find(datazY==QS))=NaN;
    end
    timeuz=unique(fix(timet/100));%整日的时间序列
    handles.canshu=dep;
    handles.shijian=timeuz; handles.tt=timet;
    fdwz=find(dbfileY=='\',1,'last');
    handles.pny=dbfileY(1:fdwz);
    handles.fny=dbfileY(fdwz+1:length(dbfileY));
    handles.shujuy=datazY;
    dbfileY=[];dbfileP=[];dbfileW=[];
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    handles.stif={['共准备处理文件',num2str(NFZ),'个'];['开始第',num2str(iiNFZ-1),'个']};
    JXZLQ(handles,0,1);
    iiNFZ=iiNFZ+1;%下一个文件序号
    if iiNFZ>NFZ
        break;
    end
end
set(handles.inform,'String',{['共处理文件',num2str(NFZ),'个']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');