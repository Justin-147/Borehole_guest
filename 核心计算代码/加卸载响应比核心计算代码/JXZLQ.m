function JXZLQ(handles,wb,lx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%显示提示信息
if wb==1
    tif={['开始计算' handles.pny handles.fny];'可能会需要一段时间'};
else
    tif={['开始计算' handles.pny handles.fny];'可能会需要一段时间';handles.stif{1};handles.stif{2}};
end
set(handles.inform,'String',tif,'Fontsize',10,'Fontweight','bold','Horizontalalignment','left');
pause(1);
tic;%开始计时
if wb==1
    hw=waitbar(0,'加卸载响应比计算中...','Name',[handles.pny handles.fny]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%参数赋值
%处理的参数选择
MX=str2num(handles.canshu.MX);
IHS=str2num(handles.canshu.IHS);
%台站信息
FB=str2num(handles.canshu.FB);
FL=str2num(handles.canshu.FL);
HH=str2num(handles.canshu.HH);
AZ=str2num(handles.canshu.AZ);
%时窗
CCH=str2num(handles.canshu.CCH);
BCH=str2num(handles.canshu.BCH);
%其他
WZ=str2num(handles.canshu.WZ);%计算的结果认为代表哪个时间点上的信息
QS=str2num(handles.canshu.QS);%数据中的缺数标记，在调用本函数前已经替换成NaN了,输出时再转回
%SCF=str2num(handles.canshu.SCF);%单位换算因子，在调用本函数前已经使用并换算了
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%准备数据
timeuz=handles.shijian;%总的整日时间序列
timet=handles.tt;%总的整点时间序列
len=length(timeuz);%共有几天的数据
ds=fix((len-CCH)/BCH)+1;%总共需要分的段数
db=24*BCH;%步长，小时
dc=24*CCH;%窗长，小时
datazY=handles.shujuy;%总的应变数据
if lx==1
    pend='_xyb';
elseif lx==2
    pend='_myb';
elseif lx==3
    pend='_tyb';
end
if MX==2
    datazP=handles.shujup;%总的气压数据
    app=['_jxz',num2str(MX),pend];
elseif MX==3
    datazW=handles.shujuw;%总的水位数据
    app=['_jxz',num2str(MX),pend];
elseif MX==4
    datazP=handles.shujup;%总的气压数据
    datazW=handles.shujuw;%总的水位数据
    app=['_jxz',num2str(MX),pend];
else
    app=['_jxz',num2str(MX),pend];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ds>0
    %计算理论固体潮汐值
    if lx==1
        [datazV,tmp]=TheoryTide(FB,FL,HH,IHS,timet,AZ);%线应变，此函数在Nakai拟合核心计算代码中
    elseif lx==2
        [tmp,datazV]=TheoryTide(FB,FL,HH,IHS,timet,AZ);%面应变
    elseif lx==3
        [tmp,datazV]=TheoryTide(FB,FL,HH,IHS,timet,AZ);%体应变
        datazV=datazV*2/3;
    end
else
    return;
end
timej=[];%记录时间
RKK=[];%存储加卸载响应比
if MX==1
    for ii=1:1:ds
        timeu=timeuz(1+BCH*(ii-1):CCH+BCH*(ii-1));
        dataY=datazY(1+db*(ii-1):dc+db*(ii-1));
        dataV=datazV(1+db*(ii-1):dc+db*(ii-1));
        RK=dxnhJ(dataY,dataV);
        RKK=[RKK,RK];
        timej=[timej;timeu(WZ)];
        if wb==1
            waitbar(ii/ds,hw);
        end
    end
elseif MX==2
    for ii=1:1:ds
        timeu=timeuz(1+BCH*(ii-1):CCH+BCH*(ii-1));
        dataY=datazY(1+db*(ii-1):dc+db*(ii-1));
        dataV=datazV(1+db*(ii-1):dc+db*(ii-1));
        dataP=datazP(1+db*(ii-1):dc+db*(ii-1));
        RK=dxnhJ(dataY,dataV,dataP);
        RKK=[RKK,RK];
        timej=[timej;timeu(WZ)];
        if wb==1
            waitbar(ii/ds,hw);
        end
    end
elseif MX==3
    for ii=1:1:ds
        timeu=timeuz(1+BCH*(ii-1):CCH+BCH*(ii-1));
        dataY=datazY(1+db*(ii-1):dc+db*(ii-1));
        dataV=datazV(1+db*(ii-1):dc+db*(ii-1));
        dataW=datazW(1+db*(ii-1):dc+db*(ii-1));
        RK=dxnhJ(dataY,dataV,dataW);
        RKK=[RKK,RK];
        timej=[timej;timeu(WZ)];
        if wb==1
            waitbar(ii/ds,hw);
        end
    end
elseif MX==4
    for ii=1:1:ds
        timeu=timeuz(1+BCH*(ii-1):CCH+BCH*(ii-1));
        dataY=datazY(1+db*(ii-1):dc+db*(ii-1));
        dataV=datazV(1+db*(ii-1):dc+db*(ii-1));
        dataP=datazP(1+db*(ii-1):dc+db*(ii-1));
        dataW=datazW(1+db*(ii-1):dc+db*(ii-1));
        RK=dxnhJ(dataY,dataV,dataP,dataW);
        RKK=[RKK,RK];
        timej=[timej;timeu(WZ)];
        if wb==1
            waitbar(ii/ds,hw);
        end
    end
else
end
RKK(isnan(RKK))=QS;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
f_nn=find(handles.fny=='.')-1;
if isempty(f_nn)
    f_nn=length(handles.fny);
end
outname=strcat(handles.pny,handles.fny(1:f_nn),app,'.txt');
fido=fopen(outname,'wt');
fprintf(fido,'%8i %.5f\n',[timej';RKK]);
fclose(fido);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
ttu=toc/60;
if wb==1
    tinf={['计算完毕======>','耗时',num2str(ttu),'分钟'];...
        ['加卸载响应比的计算结果保存在',outname,'中']};
    set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
    close(hw);
end
end