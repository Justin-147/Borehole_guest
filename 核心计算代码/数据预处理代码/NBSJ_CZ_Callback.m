% --------------------------------------------------------------------
% 整时值、日均值缺失补值预处理(整时值连续缺失不超过24h，日均值连续缺失不超过4个值)
% --------------------------------------------------------------------
function NBSJ_CZ_Callback(hObject, eventdata, handles)
% 整时值、日均值缺失补值预处理(整时值连续缺失不超过24h，日均值连续缺失不超过4个值)
% 由于缺数位置的连续性等情况，可能仅会实现部分测值的补值
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示帮助信息
tinf={'整时值、日均值缺失补值预处理(整时值连续缺失不超过24h，日均值连续缺失不超过4个值)';...
    '由于缺数位置的连续性等情况，可能仅会实现部分测值的补值，并且要求处理前数据必须是连续的，不能有断数';...
    '处理前自动调用了“缺数标记补全断数”'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
    [dataz,timet]=tbds(dataz,timet,QS);
    %插值
    inq=find(dataz==QS);%定位缺数位置
    dataz(inq)=NaN;%替换缺数标记为NaN便于计算
    lentm=length(num2str(timet(1)));
    lendata=length(dataz);
    
    if lentm==10%整点值
        xzs1=48;        xzs2=48;
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));%定位可以进行插值的缺数位置
        %这里不用考虑累计连续缺值时间是否大于24h,由于NaN的引入，会自行实现
        if isempty(iny)==0
            inyy=inq(iny);
            tmp=(4*(dataz(inyy+24)+dataz(inyy-24))-(dataz(inyy+48)+dataz(inyy-48)))/6;
            dataz(inyy)=tmp;
        end
    elseif lentm==8%日均值
        %插值分缺1个数值、连续2个、连续3个、连续4个的情况，比较复杂
        %这里连续进行4次处理来实现
        xzs1=2;        xzs2=2;%第1次
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmp=(4*(dataz(inyy+1)+dataz(inyy-1))-(dataz(inyy+2)+dataz(inyy-2)))/6;
            dataz(inyy)=tmp;
        end
        xzs1=2;        xzs2=3;%第2次
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmpz1=(10*dataz(inyy+2)+5*dataz(inyy-1)-3*dataz(inyy+3)-2*dataz(inyy-2))/10;
            tmp=(10*dataz(inyy-1)+5*dataz(inyy+2)-3*dataz(inyy-2)-2*dataz(inyy+3))/10;
            dataz(inyy)=tmp; dataz(inyy+1)=tmpz1;
        end
        xzs1=3;        xzs2=3;%第3次
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmpz1=(12*dataz(inyy+2)+4*dataz(inyy-2)-4*dataz(inyy+3)-2*dataz(inyy-3))/10;
            tmpf1=(12*dataz(inyy-2)+4*dataz(inyy+2)-4*dataz(inyy-3)-2*dataz(inyy+3))/10;
            tmp=(9*dataz(inyy-2)+9*dataz(inyy+2)-4*dataz(inyy+3)-4*dataz(inyy-3))/10;
            dataz(inyy)=tmp; dataz(inyy+1)=tmpz1; dataz(inyy-1)=tmpf1;
        end
        xzs1=4;        xzs2=3;%第4次
        iny=intersect(find(inq-xzs1>=1),find(inq+xzs2<=lendata));
        if isempty(iny)==0
            inyy=inq(iny);
            tmpf2=(28*dataz(inyy-3)+7*dataz(inyy+2)-10*dataz(inyy-4)-4*dataz(inyy+3))/21;
            tmpz1=(28*dataz(inyy+2)+7*dataz(inyy-3)-10*dataz(inyy+3)-4*dataz(inyy-4))/21;
            tmpf1=(42*dataz(inyy-3)+28*dataz(inyy+2)-20*dataz(inyy-4)-15*dataz(inyy+3))/35;
            tmp=(42*dataz(inyy+2)+28*dataz(inyy-3)-20*dataz(inyy+3)-15*dataz(inyy-4))/35;
            dataz(inyy)=tmp; dataz(inyy+1)=tmpz1; dataz(inyy-1)=tmpf1;  dataz(inyy-2)=tmpf2;
        end
    else
        return;
    end
    dataz(isnan(dataz))=QS;
    
    f_nn=find(FF=='.')-1;
    outname=strcat(Pname,FF(1:f_nn),'-cz','.txt');
    fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
    fido=fopen(outname,'wt');
    fprintf(fido,fm,[timet';dataz']);
    fclose(fido);
end
set(handles.inform,'String',{'处理后的数据已经按默认文件名保存完毕';['可在',Pname,'下找到'];'后缀为-cz.txt'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
