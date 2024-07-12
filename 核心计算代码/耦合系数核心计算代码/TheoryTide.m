function [ee1,es]=TheoryTide(weid,jingd,hh,ihs,timet,faa)
%����Ӧ����峱������ֵ(����ֵ)
%�ο���ԪΪJ2000.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fi=weid*pi/180;%ת���ɻ�����
ddf=fi;%����γ��
fi=fi-0.192424*pi/180*sin(2*fi);%�۲�վ֮����γ��
%��Դ��ۭ��ʦ�����峱ϫ������������
pa=1-0.00332479*sin(ddf)^2+hh/6378140;%������/����뾶����Դ��ۭ��ʦ�����峱ϫ������������
gg0=1/(1+0.0053024*sin(ddf)^2-0.0000059*sin(2*ddf)^2);%ƽ���������ٶ�/�������ٶȣ���Դ��ۭ��ʦ�����峱ϫ������������
pg=pa*gg0;
pg2=pa^2*gg0;
year=floor(timet/1000000);%��ʽת��
mon=floor(timet/10000)-year*100;
day=floor(timet/100)-year*10000-mon*100;
hour=timet-year*1000000-mon*10000-day*100;
minu=0;
yr=unique(year);
for i=1:1:length(yr)
    ll=find(year==yr(i));
    if mod(yr(i)-2000,4)==0
        %������б���򣺱�4�����Ҳ���100���� ���߱�400����������������ʹ�õ��б���������ƣ�2000�꿪ʼ��2100��֮ǰ����ʹ��
        bb(ll)=29;
    else
        bb(ll)=28;
    end
    dr(ll)=floor((yr(i)-2000-1)/4)+1;
    %������1900��ͬ��+1
end
bb=bb';
dr=dr';
mo=unique(mon);
for i=1:1:length(mo)
    ll=find(mon==mo(i));
    if mo(i)==1
        d(ll)=day(ll)-1;
    elseif mo(i)==2
        d(ll)=31+day(ll)-1;
    elseif mo(i)==3
        d(ll)=31+bb(ll)+day(ll)-1;
    elseif mo(i)==4
        d(ll)=31+bb(ll)+31+day(ll)-1;
    elseif mo(i)==5
        d(ll)=31+bb(ll)+31++30+day(ll)-1;
    elseif mo(i)==6
        d(ll)=31+bb(ll)+31++30+31+day(ll)-1;
    elseif mo(i)==7
        d(ll)=31+bb(ll)+31++30+31+30+day(ll)-1;
    elseif mo(i)==8
        d(ll)=31+bb(ll)+31++30+31+30+31+day(ll)-1;
    elseif mo(i)==9
        d(ll)=31+bb(ll)+31++30+31+30+31+31+day(ll)-1;
    elseif mo(i)==10
        d(ll)=31+bb(ll)+31++30+31+30+31+31+30+day(ll)-1;
    elseif mo(i)==11
        d(ll)=31+bb(ll)+31++30+31+30+31+31+30+31+day(ll)-1;
    elseif mo(i)==12
        d(ll)=31+bb(ll)+31++30+31+30+31+31+30+31+30+day(ll)-1;
    else
    end
end
d=d';
tt=hour+minu/60;
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ������������
t=((year-2000)*365+dr+d+0.5-1+(tt-ihs)/24)/36525;%��2000��1��1��12hE.T.(����ʱ)�������������������1900��ͬ��-1
%�˴���1900�ĳ���2000
%���� s, h, p, n, ps, e, tao
s=218.31643+481267.88128*t-0.00161*t.^2+0.000005*t.^3;%����ƽ�ƾ�
h=280.46607+36000.76980*t+0.00030*t.^2;%̫��ƽ�ƾ�
p=83.35345+4069.01388*t-0.01031*t.^2-0.00001*t.^3;%�������ص�ƽ�ƾ�
n=125.04452-1934.13626*t+0.00207*t.^2+0.000002*t.^3;%����������ƽ�ƾ�
ps=282.93835+1.71946*t+0.00046*t.^2+0.000003*t.^3;%̫�����ص�ƽ�ƾ�
e=23.43929-0.01300*t-0.00000016*t.^2+0.0000005*t.^3;%ƽ�Ƴཻ��
%������J2000.0ϵͳ
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ������������
rs=(18.6973746+2400.0513369*t+0.0000258622*t.^2-1.7222*10^(-9)*t.^3)*15;%ƽ̫���ྭ��ת���ɽǶȣ��ྭ�ĵ�λ��ʱ�䣬1h=15�ȣ�,��Դ�ڡ���������λչ����ĳЩڹ�͡�
%������J2000.0ϵͳ
tao=(tt-8)*15+rs+jingd-180;%��Ϊ�Ƶ����Ĺ�ʽ����ۭ��ʦ�����峱ϫ����ֵ���㡷��tao���������ĵط�ʱ��+�����ĳྭ=�ط�����ʱ
s=s*pi/180;%ת���ɻ�����
h=h*pi/180;
p=p*pi/180;
n=n*pi/180;
ps=ps*pi/180;
e=e*pi/180;
tao=tao*pi/180;
%calculating  x, b, cr,xs, bs, crs
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ����ֵ���㡷
x=s-0.0032*sin(h-ps)-0.001*sin(2*h-2*p)+0.001*sin(s-3*h+p+ps)+0.0222*sin(s-2*h+p);
x=x+0.0007*sin(s-h-p+ps)-0.0006*sin(s-h)+0.1098*sin(s-p)-0.0005*sin(s+h-p-ps);
x=x+0.0008*sin(2*s-3*h+ps)+0.0115*sin(2*s-2*h)+0.0037*sin(2*s-2*p);
x=x-0.002*sin(2*s-2*n)+0.0009*sin(3*s-2*h-p);%�����ƾ�
b=-0.0048*sin(p-n)-0.0008*sin(2*h-p-n)+0.003*sin(s-2*h+n)+0.0895*sin(s-n);
b=b+0.001*sin(2*s-2*h+p-n)+0.0049*sin(2*s-p-n)+0.0006*sin(3*s-2*h-n);%������γ
cr=1+0.01*cos(s-2*h+p)+0.0545*cos(s-p)+0.003*cos(2*s-2*p);
cr=cr+0.0009*cos(3*s-2*h-p)+0.0006*cos(2*s-3*h+ps)+0.0082*cos(2*s-2*h);%������c/R
xs=h+0.033417*sin(h-ps)+0.000349*sin(2*h-2*ps);%̫���Ļƾ�����Դ��ۭ��ʦ���µ�����λ��ȫչ����
crs=1+0.016709*cos(h-ps)+0.000279*cos(2*h-2*ps);%̫����c/R����Դ��ۭ��ʦ���µ�����λ��ȫչ����
%̫���Ļ�γbs=0
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ����ֵ���㡷
%calculating cos(th):cth,cths
dd0=cos(e).*cos(b).*sin(x)-sin(e).*sin(b);%��������γ����*�ྭ���ң���Դ��ۭ��ʦ�����峱ϫ����ֵ���㡷
dd1=sin(e).*sin(x).*cos(b)+cos(e).*sin(b);%��������γ���ң���Դ��ۭ��ʦ�����峱ϫ����ֵ���㡷
dd2=dd0.*sin(tao)+cos(b).*cos(x).*cos(tao);%��������γ����*�ط�ʱ�����ң��Ƶ���
dd3=cos(b).*cos(x).*sin(tao)-cos(tao).*dd0;%��������γ����*�ط�ʱ�����ң��Ƶ���
dd4=sin(e).*sin(xs);%bs=0��̫������γ���ң���Դ��ۭ��ʦ�����峱ϫ����ֵ���㡷
dd5=cos(xs).*cos(tao)+sin(tao).*sin(xs).*cos(e);%bs=0��̫������γ����*�ط�ʱ�����ң��Ƶ���
dd6=cos(xs).*sin(tao)-cos(tao).*sin(xs).*cos(e);%bs=0��̫������γ����*�ط�ʱ�����ң��Ƶ���
cth=sin(fi)*dd1+cos(fi)*dd2;%���������춥�������
cths=sin(fi)*dd4+cos(fi)*dd5;%̫�������춥�������
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%����Ӧ����峱����ֵ
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ������������
stra1=14.05*pg*cr.^3;
stra1=stra1.*((cos(ddf)*dd1-sin(ddf)*dd2).^2-cth.^2);
stra1=stra1+17.208*pg*cr.^3.*(3*cth.^2-1);
stra1=stra1+0.02*pg2*cr.^4.*cth.*(10*(cos(ddf)*dd1-sin(ddf)*dd2).^2-(5*cth.^2-1));
stra1=stra1+0.136*pg2.*cr.^4.*(5*cth.^3-3*cth);
stra1=stra1+6.452*pg*crs.^3.*((cos(ddf)*dd4-sin(ddf)*dd5).^2-cths.^2);
stra1=stra1+7.903*pg*crs.^3.*(3*cths.^2-1);
%%%%%%%%%%%%
stra2=14.05*pg*cr.^3.*((cos(ddf)*dd3).^2-cth*cos(ddf).*dd2)/(cos(ddf)^2);
%������ʦ������/(cos(ddf))^2��Ϊ/(cos(ddf)^2)
stra2=stra2-14.05*pg*cr.^3.*cth*tan(ddf).*(cos(ddf)*dd1-sin(ddf)*dd2);
stra2=stra2+17.028*pg*cr.^3.*(3*cth.^2-1);
%����ʦ������Ϊ17.208������ۭ��ʦ�����峱ϫ��������������Ϊ17.028
stra2=stra2+0.02*pg2*cr.^4.*(10*cth.*(cos(ddf)*dd3).^2-(5*cth.^2-1)*cos(ddf).*dd2)/(cos(ddf)^2);
%������ʦ������/(cos(ddf))^2��Ϊ/(cos(ddf)^2)
stra2=stra2-0.02*pg2*cr.^4* tan(ddf).*(5*cth.^2-1).*(cos(ddf)*dd1-sin(ddf)*dd2);
stra2=stra2+0.136*pg2*cr.^4.*(5*cth.^3-3*cth);
stra2=stra2+6.452*pg*crs.^3.*((cos(ddf)*dd6).^2-cths*cos(ddf).*dd5)/(cos(ddf)^2);
%������ʦ������/(cos(ddf))^2��Ϊ/(cos(ddf)^2)
stra2=stra2-6.452*pg*crs.^3.*cths*tan(ddf).*(cos(ddf)*dd4-sin(ddf)*dd5);
stra2=stra2+7.903*pg*crs.^3.*(3*cths.^2-1);
%%%%%%%%%%%%
stra3=28.1*pg*cr.^3;
stra3=stra3.*((cos(ddf)*dd1-sin(ddf)*dd2)*cos(ddf).*dd3-cth*sin(ddf).*dd3)/cos(ddf);
%��(cos(ddf)*dd3)�ĳ�cos(ddf)*dd3
stra3=stra3+28.1*pg*cr.^3*tan(ddf).*cth.*dd3;
%��cos(ddf)Լ��
stra3=stra3+0.041*pg2*cr.^4.*(10*cth.*(cos(ddf)*dd1-sin(ddf)*dd2)*cos(ddf).*dd3)/cos(ddf);
stra3=stra3-0.041*pg2*cr.^4.*(5*cth.^2-1)*tan(ddf).*dd3;
%��sin(ddf)/cos(ddf)��Ϊtan(ddf)
stra3=stra3+0.041*pg2*cr.^4.*(5*cth.^2-1).*dd3*tan(ddf);
%��cos(ddf)Լ��
stra3=stra3+12.905*pg*crs.^3.*((cos(ddf)*dd4-sin(ddf)*dd5)*cos(ddf).*dd6-cths*sin(ddf).*dd6)/cos(ddf);
stra3=stra3+12.905*pg*crs.^3*tan(ddf).*cths.*dd6;
%��cos(ddf)Լ��
stra3=stra3/2;
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ������������
fa=faa*pi/180;%��1·��λ�ǣ������ƣ�
ee1=cos(fa)^2*stra1+sin(fa)^2*stra2-sin(2*fa)*stra3;%��1·Ӧ������ֵ
es=stra1+stra2;%��Ӧ������ֵ
% ee3=sin(fa)^2*stra1+cos(fa)^2*stra2+sin(2*fa)*stra3;%��3·Ӧ������ֵ
% fa=(faa+45)*pi/180;%��2·��λ�ǣ������ƣ�
% ee2=cos(fa)^2*stra1+sin(fa)^2*stra2-sin(2*fa)*stra3;%��2·Ӧ������ֵ
% ee4=sin(fa)^2*stra1+cos(fa)^2*stra2+sin(2*fa)*stra3;%��4·Ӧ������ֵ
%%%%%%%%%%%%%%%%%%%%%%%���й�ʽ������Դ��ۭ��ʦ�����峱ϫ������������
end