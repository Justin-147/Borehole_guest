% --------------------------------------------------------------------
% 用缺数标记补全断数，主要调用“程序功能代码\tbds.m”
% --------------------------------------------------------------------
function BQDS_Menu_Callback(hObject, eventdata, handles)
% 用缺数标记补全断数，主要调用“程序功能代码\tbds.m”
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    end
    %填补断数
    [datao,timeo]=tbds(dataz,timet,QS);
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'-tbqs','.txt');
    fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
    fido=fopen(outname,'wt');
    fprintf(fido,fm,[timeo';datao']);
    fclose(fido);
end
set(handles.inform,'String',{'处理后的数据已经按默认文件名保存完毕';['可在',Pname,'下找到'];'后缀为-tbqs.txt'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
