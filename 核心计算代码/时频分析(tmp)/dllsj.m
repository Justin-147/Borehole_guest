%---------------------------------------------------------
% 打开单文件读入一般的两列数据
%---------------------------------------------------------
function [Fname,Pname,dataz,timet,fbz]=dllsj(FF,ST)
[Fname,Pname]=uigetfile(FF,ST,'MultiSelect','off');
%完整文件路径
dbfile=[Pname,Fname];
fbz=0;
dataz=[];
timet=[];
%如果没有打开文件，则跳出程序
if sum(dbfile)==0
    return;
end
tmp=load(dbfile); [M,N]=size(tmp);
if N~=2
    errordlg('需要两列数据', '读数错误'); return;
else
    dataz=tmp(:,2);    timet=tmp(:,1);
    fbz=1;
end
return;
