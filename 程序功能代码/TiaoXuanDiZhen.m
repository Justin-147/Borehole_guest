%---------------------------------------------------------
%��ѡ���ĵ���Ŀ¼����е���ɸѡ������ĳ������㣬��һ���ľ�γ�ȷ�Χ��һ�����𼶷�Χ��һ����ʱ�䷶Χ��,һ������ȷ�Χ��
%�����ѡ�ĵ���Ŀ¼���ļ���outdzdata������ѡ�������datenum;
%---------------------------------------------------------
function [txfznum,txzhenji]=TiaoXuanDiZhen(xx,bc,inname,outname,jingdu,weidu,xx1,sx1,xx2,sx2,xx3,sx3,xx4,sx4)
%xx��ʾѡ�����ͣ�bc��ʾ�Ƿ��������Ŀ¼��inname��ʾ�������Ŀ¼��·���ļ�����outname��ʾ�������Ŀ¼��·���ļ�����
%xx1,sx1--xx4,sx4��ʾ�޶���Χ������ʾ��γ�ȷ�Χʱ��xx1��ʾ���붨��ľ������ޣ�sx1��ʾ���붨���γ�����ޡ�
fiddz=fopen(inname,'r');
dzmldata=textscan(fiddz,'%s%s%f%f%d%s%s');%�����˵���Ŀ¼����
fclose(fiddz);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dz_date=dzmldata{1};%��������
dz_time=dzmldata{2};%����ʱ��
dz_weidu=dzmldata{3};%����γ��
dz_jingdu=dzmldata{4};%���о���
dz_shendu=dzmldata{5};%��Դ���
dz_zhenji=dzmldata{6};%��
dz_zhenzhong=dzmldata{7};%����
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
len=length(dz_jingdu);
bb=blanks(len)';
%ת�����ַ���
dz_dates=char(dz_date);
dz_times=char(dz_time);
dz_zhenjis=char(dz_zhenji);
dz_zhenzhongs=char(dz_zhenzhong);
%���𼶻�������
zhenji=str2num(dz_zhenjis(:,3:5));
%����ʱ�̵�datenum
fzsk=[dz_dates,bb,dz_times];
datenum_fz=datenum(fzsk,'yyyy-mm-dd HH:MM:SS');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if xx==1%ֻ�޶���γ�ȷ�Χ
    weizhi_tiaoxuan=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));  
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ���޵�����ֱ�ӷ���
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
elseif xx==12%ֻ�޶���γ�ȡ��𼶷�Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));  
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi2);
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,�𼶷�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;        
    end
elseif xx==13%ֻ�޶���γ�ȡ�ʱ�䷶Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi3);
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,ʱ�䷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==14%ֻ�޶���γ�ȡ���ȷ�Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi4=intersect(find(dz_shendu>=xx2),find(dz_shendu<=sx2));
    weizhi_tiaoxuan=intersect(weizhi1,weizhi4);
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,��ȷ�Χ���޵�����ֱ�ӷ���
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
elseif xx==123%ֻ�޶���γ�ȡ��𼶡�ʱ�䷶Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi3=intersect(find(datenum_fz>=xx3),find(datenum_fz<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),weizhi3);
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,�𼶷�Χ,ʱ�䷶Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==124%ֻ�޶���γ�ȡ��𼶡���ȷ�Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),weizhi4);
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,�𼶷�Χ,��ȷ�Χ���޵�����ֱ�ӷ���
        txfznum=[];
        txzhenji=[];
        return;
    end
elseif xx==134%ֻ�޶���γ�ȡ�ʱ�䡢��ȷ�Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi3=intersect(find(datenum_fz>=xx2),find(datenum_fz<=sx2));
    weizhi4=intersect(find(dz_shendu>=xx3),find(dz_shendu<=sx3));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi3),weizhi4);
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,ʱ�䷶Χ,��ȷ�Χ���޵�����ֱ�ӷ���
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
elseif xx==1234%�޶���γ�ȡ��𼶡�ʱ�䡢��ȷ�Χ
    weizhi1=intersect(find(abs(dz_jingdu-jingdu)<=xx1),find(abs(dz_weidu-weidu)<=sx1));
    weizhi2=intersect(find(zhenji>=xx2),find(zhenji<=sx2));
    weizhi3=intersect(find(datenum_fz>=xx3),find(datenum_fz<=sx3));
    weizhi4=intersect(find(dz_shendu>=xx4),find(dz_shendu<=sx4));
    weizhi_tiaoxuan=intersect(intersect(weizhi1,weizhi2),intersect(weizhi3,weizhi4));
    if isempty(weizhi_tiaoxuan)%����̨վָ����γ�ȷ�Χ,�𼶷�Χ��ʱ�䷶Χ����ȷ�Χ���޵�����ֱ�ӷ���
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
    [s1,s2]=size(dataout);
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
