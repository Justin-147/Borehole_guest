%---------------------------------------------------------
% �򿪵��ļ�������������
%---------------------------------------------------------
function [dataz,timet,fbz]=dzdsj1(dbfile)
fbz=0;
dataz=[];
timet=[];
%���û�д��ļ�������������
if sum(dbfile)==0
    return;
end
tmp=load(dbfile); [M,N]=size(tmp);
if N~=2
    errordlg('��Ҫ��������', '��������'); return;
else
    dataz=tmp(:,2);    timet=tmp(:,1);
    %�����������ֵ���ݣ�����������
    if length(num2str(timet(1)))~=10
        errordlg('��Ҫ����ֵ������', '��������'); return;
    end
    fbz=1;
end
return;