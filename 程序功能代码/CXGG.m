%station��ָ��̨�������ѯ������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ѯ
clc;
tname='�ϴ�����';
index=strmatch(tname,TZM);
fwj=FWJ(index);
gc=GC(index);
jwd=JWD(index,:);
disp(num2str([fwj,gc,jwd]));
% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% %���ģ��������̨վ��ƫ�ǰ�2����
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
