% --------------------------------------------------------------------
% 别尔采夫滤波
% --------------------------------------------------------------------
function BRCF_Filter_Callback(hObject, eventdata, handles)
% 别尔采夫滤波
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    QKtsxx(handles);     return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示帮助信息
set(handles.inform,'String',{'别尔采夫滤波器是一个18阶的组合，它曾被国际固体潮中心（ICET）推荐为世界各国统一使用的计算瞬时仪器零漂值的方法';...
    '处理之前自动进行了填补断数处理'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%输入基本的参数
%设置默认值
dep=struct('QS','999999.0');
prompt={'缺数标记'};
title='参数赋值'; lines=1; resize='off';
hi=inputdlg(prompt,title,lines,struct2cell(dep),resize);
if isempty(hi)
    QKtsxx(handles);     return;
end
fields={'QS'};
if size(hi,1)>0 dep=cell2struct(hi,fields,1); end
%%%清空提示信息栏
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件
    Fname={Fname};
end
QS=str2num(dep.QS);

for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    FF=Fname{iiNFZ};
    tmp=load(dbfile); [M,N]=size(tmp);
    %如果不是两列数据，则跳过文件
    if N~=2
        continue;
    else
        dataz=tmp(:,2);    timet=tmp(:,1);
        %如果不是整点值数据，则跳过文件
        if length(num2str(timet(1)))~=10
            continue;
        end
    end
    %填补断数    
    [dataz,timet]=tbds(dataz,timet,QS);
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    dataz(find(dataz==QS))=NaN;%替换缺数为NaN，便于计算
    
    tmp=dataz;
    
    tmpf2=[ones(2,1)*NaN;dataz(1:end-2)];
    tmpf3=[ones(3,1)*NaN;dataz(1:end-3)];
    tmpf5=[ones(5,1)*NaN;dataz(1:end-5)];
    tmpf8=[ones(8,1)*NaN;dataz(1:end-8)];
    tmpf10=[ones(10,1)*NaN;dataz(1:end-10)];
    tmpf13=[ones(13,1)*NaN;dataz(1:end-13)];
    tmpf18=[ones(18,1)*NaN;dataz(1:end-18)];
    
    tmpz2=[dataz(1+2:end);ones(2,1)*NaN];
    tmpz3=[dataz(1+3:end);ones(3,1)*NaN];
    tmpz5=[dataz(1+5:end);ones(5,1)*NaN];
    tmpz8=[dataz(1+8:end);ones(8,1)*NaN];
    tmpz10=[dataz(1+10:end);ones(10,1)*NaN];
    tmpz13=[dataz(1+13:end);ones(13,1)*NaN];
    tmpz18=[dataz(1+18:end);ones(18,1)*NaN];

    yf=(tmp+tmpf2+tmpf3+tmpf5+tmpf8+tmpf10+tmpf13+tmpf18+tmpz2+tmpz3+tmpz5+tmpz8+tmpz10+tmpz13+tmpz18)/15;%瞬时零漂值
    yr=tmp-yf;%去除零漂后的结果
    yf(find(isnan(yf)))=QS;%替换NaN为缺数标记
    yr(find(isnan(yr)))=QS;%替换NaN为缺数标记
    
    f_nn=find(FF=='.')-1;
    outnamef=strcat(Pname,FF(1:f_nn),'-BRFf','.txt');
    outnamer=strcat(Pname,FF(1:f_nn),'-BRFr','.txt');
    fm=strcat('%10i %.5f\n');
    fidof=fopen(outnamef,'wt');
    fprintf(fidof,fm,[timet';yf']);
    fclose(fidof);    
    fidor=fopen(outnamer,'wt');
    fprintf(fidor,fm,[timet';yr']);
    fclose(fidor);     
end
set(handles.inform,'String',{'滤波处理后的数据已经按默认文件名保存完毕';['可在',Pname,'下找到'];'-BRFf.txt是瞬时零漂值，-BRFr.txt是去除零漂后的结果'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
