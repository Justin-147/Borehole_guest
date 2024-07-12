%station表指定台项参数查询及更改
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%查询
clc;
tname='合川云门';
index=strmatch(tname,TZM);
fwj=FWJ(index);
gc=GC(index);
jwd=JWD(index,:);
disp(num2str([fwj,gc,jwd]));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %更改，重庆地区台站磁偏角按2度算
% fwj=[178;43;88;133];
% %gc=492;
% %jwd=[109.1188,31.1055];
% FWJ(index)=fwj;
% %GC(index)=gc;
% %JWD(index,:)=ones(length(index),1)*jwd;
% index=strmatch(tname,TZM);
% fwj=FWJ(index);
% gc=GC(index);
% jwd=JWD(index,:);
% disp(num2str([fwj,gc,jwd]));
