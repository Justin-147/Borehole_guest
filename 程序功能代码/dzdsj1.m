%---------------------------------------------------------
% 打开单文件读入整点数据
%---------------------------------------------------------
function [dataz,timet,fbz]=dzdsj1(dbfile)
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
    %如果不是整点值数据，则跳出程序
    if length(num2str(timet(1)))~=10
        errordlg('需要整点值的数据', '读数错误'); return;
    end
    fbz=1;
end
return;