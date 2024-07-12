%---------------------------------------------------------
%��ѡ���ĵ���Ŀ¼����е���ɸѡ������ĳ������㣬��һ���ľ��뷶Χ��һ�����𼶷�Χ��һ����ʱ�䷶Χ��,һ������ȷ�Χ��
%�����ѡ�ĵ���Ŀ¼���ļ���outdzdata������ѡ�������datenum;
%---------------------------------------------------------
function [txfznum,txzhenji]=TiaoXuanDiZhen1(xx,bc,inname,outname,jingdu,weidu,xx1,sx1,xx2,sx2,xx3,sx3,xx4,sx4)
%xx��ʾѡ�����ͣ�bc��ʾ�Ƿ��������Ŀ¼��inname��ʾ�������Ŀ¼��·���ļ�����outname��ʾ�������Ŀ¼��·���ļ�����
%xx1,sx1--xx4,sx4��ʾ�޶���Χ������ʾ���뷶Χʱ��xx1��ʾ���붨��ľ������ޣ�sx1��ʾ���붨��ľ������ޡ�
txfznum=[];
txzhenji=[];
fiddz=fopen(inname,'r');
dzmldata=textscan(fiddz,'%s%s%f%f%d%s%s');%�����˵���Ŀ¼����
fclose(fiddz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isempty(jingdu)||isempty(weidu)||isnan(jingdu)||isnan(weidu)
    return;
end
dz_date=dzmldata{1};%��������
dz_time=dzmldata{2};%����ʱ��
dz_weidu=dzmldata{3};%����γ��
dz_jingdu=dzmldata{4};%���о���
dz_shendu=dzmldata{5};%��Դ���
dz_zhenji=dzmldata{6};%��
dz_zhenzhong=dzmldata{7};%����
if isempty(dz_date)||isempty(dz_time)||isempty(dz_weidu)||isempty(dz_jingdu)||isempty(dz_shendu)||isempty(dz_zhenji)||isempty(dz_zhenzhong)
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=length(dz_jingdu);
bb=blanks(len)';
%ת�����ַ���
dz_dates=char(dz_date);
dz_times=char(dz_time);
dz_zhenjis=char(dz_zhenji);
dz_zhenzhongs=char(dz_zhenzhong);
%���𼶻�������
zhenji=dz_zhenjis(:,end-3:end);
zhenji(isletter(zhenji))=' ';
zhenji=str2num(zhenji);
%����ʱ�̵�datenum
fzsk=[dz_dates,bb,dz_times];
datenum_fz=datenum(fzsk,'yyyy-mm-dd HH:MM:SS');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if isnan(xx1)
    xx1=-Inf;
end
if isnan(xx2)
    xx2=-Inf;
end
if isnan(xx3)
    xx3=-Inf;
end
if isnan(xx4)
    xx4=-Inf;
end
if isnan(sx1)
    sx1=Inf;
end
if isnan(sx2)
    sx2=Inf;
end
if isnan(sx3)
    sx3=Inf;
end
if isnan(sx4)
    sx4=Inf;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if xx==1%ֻ�޶����뷶Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi_tiaoxuan=intersect(find(dis>=xx1),find(dis<=sx1));
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==2%ֻ�޶��𼶷�Χ
    weizhi_tiaoxuan=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    if isempty(weizhi_tiaoxuan)%ָ���𼶷�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==3%ֻ�޶�ʱ�䷶Χ
    weizhi_tiaoxuan=intersect(find(datenum_fz>=xx1),find(datenum_fz<=sx1));%xx1,sx1����ת�����datenum
    if isempty(weizhi_tiaoxuan)%ָ��ʱ�䷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==4%ֻ�޶���ȷ�Χ
    weizhi_tiaoxuan=intersect(find(dz_shendu>=xx1),find(dz_shendu<=sx1));
    if isempty(weizhi_tiaoxuan)%ָ����Դ��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==12%ֻ�޶����롢�𼶷�Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi2);
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,�𼶷�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==13%ֻ�޶����롢ʱ�䷶Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi3);
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,ʱ�䷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==14%ֻ�޶����롢��ȷ�Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi4);
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==23%ֻ�޶��𼶡�ʱ�䷶Χ
    weizhi2=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi_tiaoxuan=intersect(weizhi2,weizhi3);
    if isempty(weizhi_tiaoxuan)%ָ���𼶷�Χ,ʱ�䷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==24%ֻ�޶��𼶡���ȷ�Χ
    weizhi2=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi2,weizhi4);
    if isempty(weizhi_tiaoxuan)%ָ���𼶷�Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==34%ֻ�޶�ʱ�䡢��ȷ�Χ
    weizhi3=intersect(find(datenum_fz>=xx1),find(datenum_fz<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi3,weizhi4);
    if isempty(weizhi_tiaoxuan)%ָ��ʱ�䷶Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==123%ֻ�޶����롢�𼶡�ʱ�䷶Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi3=intersect(find(datenum_fz>=xx3),find(datenum_fz<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),weizhi3);
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,�𼶷�Χ,ʱ�䷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==124%ֻ�޶����롢�𼶡���ȷ�Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),weizhi4);
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,�𼶷�Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==134%ֻ�޶����롢ʱ�䡢��ȷ�Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi3),weizhi4);
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,ʱ�䷶Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==234%ֻ�޶��𼶡�ʱ�䡢��ȷ�Χ
    weizhi2=intersect(find(zhenji>=xx1),find(zhenji<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi2,weizhi3),weizhi4);
    if isempty(weizhi_tiaoxuan)%ָ���𼶷�Χ,ʱ�䷶Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==1234%�޶����롢�𼶡�ʱ�䡢��ȷ�Χ
    dweidu=ones(length(dz_weidu),1)*weidu;
    djingdu=ones(length(dz_jingdu),1)*jingdu;
    dis = vdist(dweidu,djingdu,dz_weidu,dz_jingdu);
    dis=dis/1000;%����ɹ���
    weizhi1=intersect(find(dis>=xx1),find(dis<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi3=intersect(find(datenum_fz>=xx3),find(datenum_fz<=sx3));
    weizhi4=intersect(find(dz_shendu>=xx4),find(dz_shendu<=sx4));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),intersect(weizhi3,weizhi4));
    if isempty(weizhi_tiaoxuan)%����̨վָ�����뷶Χ,�𼶷�Χ��ʱ�䷶Χ����ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
else%��������ֱ�ӷ���
    txfznum=[];
    txzhenji=[];
    return;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%�����ѡ��Ŀ¼���ļ�
if bc==1%Ҫ�����
    dataout=[dz_dates,bb,dz_times,bb,num2str(dz_weidu),bb,num2str(dz_jingdu),bb,num2str(dz_shendu),bb,dz_zhenjis,bb,dz_zhenzhongs]';
    dataout=dataout(:,weizhi_tiaoxuan);
    [~,s2]=size(dataout);
    fido=fopen(outname,'wt');
    for ii=1:1:s2
        fprintf(fido,'%s\n',dataout(:,ii));
    end
    fclose(fido);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������Ҫ�ı���,����ѡ���ĵ����datenum�Ͷ�Ӧ����
txfznum=datenum_fz(weizhi_tiaoxuan);
txzhenji=dz_zhenji(weizhi_tiaoxuan);
end
