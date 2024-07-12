%---------------------------------------------------------
%从选定的地震目录里进行地震筛选（对于某个坐标点，在一定的经纬度范围，一定的震级范围，一定的时间范围内,一定的深度范围）
%输出挑选的地震目录到文件，outdzdata返回挑选出地震的datenum;
%---------------------------------------------------------
function [txfznum,txzhenji]=TiaoXuanDiZhen(xx,bc,inname,outname,jingdu,weidu,xx1,sx1,xx2,sx2,xx3,sx3,xx4,sx4)
%xx表示选择类型，bc表示是否输出地震目录，inname表示读入地震目录的路径文件名，outname表示输出地震目录的路径文件名。
%xx1,sx1--xx4,sx4表示限定范围。当表示经纬度范围时，xx1表示距离定点的经度上限，sx1表示距离定点的纬度上限。
fiddz=fopen(inname,'r');
dzmldata=textscan(fiddz,'%s%s%f%f%d%s%s');%读入了地震目录数据
fclose(fiddz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dz_date=dzmldata{1};%发震日期
dz_time=dzmldata{2};%发震时间
dz_weidu=dzmldata{3};%震中纬度
dz_jingdu=dzmldata{4};%震中经度
dz_shendu=dzmldata{5};%震源深度
dz_zhenji=dzmldata{6};%震级
dz_zhenzhong=dzmldata{7};%震中
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=length(dz_jingdu);
bb=blanks(len)';
%转换成字符串
dz_dates=char(dz_date);
dz_times=char(dz_time);
dz_zhenjis=char(dz_zhenji);
dz_zhenzhongs=char(dz_zhenzhong);
%将震级换成数字
zhenji=str2num(dz_zhenjis(:,3:5));
%发震时刻的datenum
fzsk=[dz_dates,bb,dz_times];
datenum_fz=datenum(fzsk,'yyyy-mm-dd HH:MM:SS');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if xx==1%只限定经纬度范围
    weizhi_tiaoxuan=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));  
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==2%只限定震级范围
    weizhi_tiaoxuan=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    if isempty(weizhi_tiaoxuan)%指定震级范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==3%只限定时间范围
    weizhi_tiaoxuan=intersect(find(datenum_fz>=xx1),find(datenum_fz<=sx1));%xx1,sx1都是转换后的datenum
    if isempty(weizhi_tiaoxuan)%指定时间范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==4%只限定深度范围
    weizhi_tiaoxuan=intersect(find(dz_shendu>=xx1),find(dz_shendu<=sx1));
    if isempty(weizhi_tiaoxuan)%指定震源深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==12%只限定经纬度、震级范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));  
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi2);
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,震级范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;        
    end
elseif xx==13%只限定经纬度、时间范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi3);
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,时间范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==14%只限定经纬度、深度范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi4);
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==23%只限定震级、时间范围
    weizhi2=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi_tiaoxuan=intersect(weizhi2,weizhi3);
    if isempty(weizhi_tiaoxuan)%指定震级范围,时间范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==24%只限定震级、深度范围
    weizhi2=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi2,weizhi4);
    if isempty(weizhi_tiaoxuan)%指定震级范围,深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==34%只限定时间、深度范围
    weizhi3=intersect(find(datenum_fz>=xx1),find(datenum_fz<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi3,weizhi4);
    if isempty(weizhi_tiaoxuan)%指定时间范围,深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end    
elseif xx==123%只限定经纬度、震级、时间范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi3=intersect(find(datenum_fz>=xx3),find(datenum_fz<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),weizhi3);
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,震级范围,时间范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==124%只限定经纬度、震级、深度范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),weizhi4);
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,震级范围,深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==134%只限定经纬度、时间、深度范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi3),weizhi4);
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,时间范围,深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==234%只限定震级、时间、深度范围
    weizhi2=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi2,weizhi3),weizhi4);
    if isempty(weizhi_tiaoxuan)%指定震级范围,时间范围,深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end    
elseif xx==1234%限定经纬度、震级、时间、深度范围
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi3=intersect(find(datenum_fz>=xx3),find(datenum_fz<=sx3));
    weizhi4=intersect(find(dz_shendu>=xx4),find(dz_shendu<=sx4));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),intersect(weizhi3,weizhi4));
    if isempty(weizhi_tiaoxuan)%距离台站指定经纬度范围,震级范围，时间范围，深度范围内无地震，则直接返回
        txfznum=[];
        txzhenji=[];
        return;
    end
else%参数错误，直接返回
    txfznum=[];
    txzhenji=[];
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%输出挑选的目录到文件
if bc==1%要求输出
    dataout=[dz_dates,bb,dz_times,bb,num2str(dz_weidu),bb,num2str(dz_jingdu),bb,num2str(dz_shendu),bb,dz_zhenjis,bb,dz_zhenzhongs]';
    dataout=dataout(:,weizhi_tiaoxuan);
    [s1,s2]=size(dataout);
    fido=fopen(outname,'wt');
    for ii=1:1:s2
        fprintf(fido,'%s\n',dataout(:,ii));
    end
    fclose(fido);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%返回需要的变量,即挑选出的地震的datenum和对应的震级
txfznum=datenum_fz(weizhi_tiaoxuan);
txzhenji=dz_zhenji(weizhi_tiaoxuan);
end
