function JXZLQ(handles,wb,lx)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%��ʾ��ʾ��Ϣ
if wb==1
    tif={['��ʼ����' handles.pny handles.fny];'���ܻ���Ҫһ��ʱ��'};
else
    tif={['��ʼ����' handles.pny handles.fny];'���ܻ���Ҫһ��ʱ��';handles.stif{1};handles.stif{2}};
end
set(handles.inform,'String',tif,'Fontsize',10,'Fontweight','bold','Horizontalalignment','left');
pause(1);
tic;%��ʼ��ʱ
if wb==1
    hw=waitbar(0,'��ж����Ӧ�ȼ�����...','Name',[handles.pny handles.fny]);
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%������ֵ
%����Ĳ���ѡ��
MX=str2num(handles.canshu.MX);
IHS=str2num(handles.canshu.IHS);
%̨վ��Ϣ
FB=str2num(handles.canshu.FB);
FL=str2num(handles.canshu.FL);
HH=str2num(handles.canshu.HH);
AZ=str2num(handles.canshu.AZ);
%ʱ��
CCH=str2num(handles.canshu.CCH);
BCH=str2num(handles.canshu.BCH);
%����
WZ=str2num(handles.canshu.WZ);%����Ľ����Ϊ�����ĸ�ʱ����ϵ���Ϣ
QS=str2num(handles.canshu.QS);%�����е�ȱ����ǣ��ڵ��ñ�����ǰ�Ѿ��滻��NaN��,���ʱ��ת��
%SCF=str2num(handles.canshu.SCF);%��λ�������ӣ��ڵ��ñ�����ǰ�Ѿ�ʹ�ò�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%׼������
timeuz=handles.shijian;%�ܵ�����ʱ������
timet=handles.tt;%�ܵ�����ʱ������
len=length(timeuz);%���м��������
ds=fix((len-CCH)/BCH)+1;%�ܹ���Ҫ�ֵĶ���
db=24*BCH;%������Сʱ
dc=24*CCH;%������Сʱ
datazY=handles.shujuy;%�ܵ�Ӧ������
if lx==1
    pend='_xyb';
elseif lx==2
    pend='_myb';
elseif lx==3
    pend='_tyb';
end
if MX==2
    datazP=handles.shujup;%�ܵ���ѹ����
    app=['_jxz',num2str(MX),pend];
elseif MX==3
    datazW=handles.shujuw;%�ܵ�ˮλ����
    app=['_jxz',num2str(MX),pend];
elseif MX==4
    datazP=handles.shujup;%�ܵ���ѹ����
    datazW=handles.shujuw;%�ܵ�ˮλ����
    app=['_jxz',num2str(MX),pend];
else
    app=['_jxz',num2str(MX),pend];
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ds>0
    %�������۹��峱ϫֵ
    if lx==1
        [datazV,tmp]=TheoryTide(FB,FL,HH,IHS,timet,AZ);%��Ӧ�䣬�˺�����Nakai��Ϻ��ļ��������
    elseif lx==2
        [tmp,datazV]=TheoryTide(FB,FL,HH,IHS,timet,AZ);%��Ӧ��
    elseif lx==3
        [tmp,datazV]=TheoryTide(FB,FL,HH,IHS,timet,AZ);%��Ӧ��
        datazV=datazV*2/3;
    end
else
    return;
end
timej=[];%��¼ʱ��
RKK=[];%�洢��ж����Ӧ��
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
    tinf={['�������======>','��ʱ',num2str(ttu),'����'];...
        ['��ж����Ӧ�ȵļ�����������',outname,'��']};
    set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
    close(hw);
end
end