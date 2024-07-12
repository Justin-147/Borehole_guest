function [ee1,es]=TheoryTide(weid,jingd,hh,ihs,timet,faa)
%计算应变固体潮的理论值(整点值)
%参考历元为J2000.0
%%%%%%%%%%%%%%%%%%%%%%%%%%%%
fi=weid*pi/180;%转换成弧度制
ddf=fi;%地理纬度
fi=fi-0.192424*pi/180*sin(2*fi);%观测站之地心纬度
%来源于郗老师《固体潮汐与引潮参数》
pa=1-0.00332479*sin(ddf)^2+hh/6378140;%地心向径/赤道半径，来源于郗老师《固体潮汐与引潮参数》
gg0=1/(1+0.0053024*sin(ddf)^2-0.0000059*sin(2*ddf)^2);%平均重力加速度/重力加速度，来源于郗老师《固体潮汐与引潮参数》
pg=pa*gg0;
pg2=pa^2*gg0;
year=floor(timet/1000000);%格式转换
mon=floor(timet/10000)-year*100;
day=floor(timet/100)-year*10000-mon*100;
hour=timet-year*1000000-mon*10000-day*100;
minu=0;
yr=unique(year);
for i=1:1:length(yr)
    ll=find(year==yr(i));
    if mod(yr(i)-2000,4)==0
        %闰年的判别规则：被4整除且不被100整除 或者被400整除，程序里现在使用的判别规则有限制，2000年开始，2100年之前可以使用
        bb(ll)=29;
    else
        bb(ll)=28;
    end
    dr(ll)=floor((yr(i)-2000-1)/4)+1;
    %这里与1900不同，+1
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
%%%%%%%%%%%%%%%%%%%%%%%下列公式部分来源于郗老师《固体潮汐与引潮参数》
t=((year-2000)*365+dr+d+0.5-1+(tt-ihs)/24)/36525;%自2000年1月1日12hE.T.(历书时)算起的儒略世纪数，与1900不同，-1
%此处将1900改成了2000
%计算 s, h, p, n, ps, e, tao
s=218.31643+481267.88128*t-0.00161*t.^2+0.000005*t.^3;%月亮平黄经
h=280.46607+36000.76980*t+0.00030*t.^2;%太阳平黄经
p=83.35345+4069.01388*t-0.01031*t.^2-0.00001*t.^3;%月亮近地点平黄经
n=125.04452-1934.13626*t+0.00207*t.^2+0.000002*t.^3;%月亮升交点平黄经
ps=282.93835+1.71946*t+0.00046*t.^2+0.000003*t.^3;%太阳近地点平黄经
e=23.43929-0.01300*t-0.00000016*t.^2+0.0000005*t.^3;%平黄赤交角
%采用了J2000.0系统
%%%%%%%%%%%%%%%%%%%%%%%上列公式部分来源于郗老师《固体潮汐与引潮参数》
rs=(18.6973746+2400.0513369*t+0.0000258622*t.^2-1.7222*10^(-9)*t.^3)*15;%平太阳赤经（转换成角度，赤经的单位是时间，1h=15度）,来源于《精密引潮位展开及某些诠释》
%采用了J2000.0系统
tao=(tt-8)*15+rs+jingd-180;%此为推导出的公式，由郗老师《固体潮汐理论值计算》，tao等于月亮的地方时角+月亮的赤经=地方恒星时
s=s*pi/180;%转换成弧度制
h=h*pi/180;
p=p*pi/180;
n=n*pi/180;
ps=ps*pi/180;
e=e*pi/180;
tao=tao*pi/180;
%calculating  x, b, cr,xs, bs, crs
%%%%%%%%%%%%%%%%%%%%%%%下列公式部分来源于郗老师《固体潮汐理论值计算》
x=s-0.0032*sin(h-ps)-0.001*sin(2*h-2*p)+0.001*sin(s-3*h+p+ps)+0.0222*sin(s-2*h+p);
x=x+0.0007*sin(s-h-p+ps)-0.0006*sin(s-h)+0.1098*sin(s-p)-0.0005*sin(s+h-p-ps);
x=x+0.0008*sin(2*s-3*h+ps)+0.0115*sin(2*s-2*h)+0.0037*sin(2*s-2*p);
x=x-0.002*sin(2*s-2*n)+0.0009*sin(3*s-2*h-p);%月亮黄经
b=-0.0048*sin(p-n)-0.0008*sin(2*h-p-n)+0.003*sin(s-2*h+n)+0.0895*sin(s-n);
b=b+0.001*sin(2*s-2*h+p-n)+0.0049*sin(2*s-p-n)+0.0006*sin(3*s-2*h-n);%月亮黄纬
cr=1+0.01*cos(s-2*h+p)+0.0545*cos(s-p)+0.003*cos(2*s-2*p);
cr=cr+0.0009*cos(3*s-2*h-p)+0.0006*cos(2*s-3*h+ps)+0.0082*cos(2*s-2*h);%月亮的c/R
xs=h+0.033417*sin(h-ps)+0.000349*sin(2*h-2*ps);%太阳的黄经，来源于郗老师《新的引潮位完全展开》
crs=1+0.016709*cos(h-ps)+0.000279*cos(2*h-2*ps);%太阳的c/R，来源于郗老师《新的引潮位完全展开》
%太阳的黄纬bs=0
%%%%%%%%%%%%%%%%%%%%%%%上列公式部分来源于郗老师《固体潮汐理论值计算》
%calculating cos(th):cth,cths
dd0=cos(e).*cos(b).*sin(x)-sin(e).*sin(b);%月亮：赤纬余弦*赤经正弦，来源于郗老师《固体潮汐理论值计算》
dd1=sin(e).*sin(x).*cos(b)+cos(e).*sin(b);%月亮：赤纬正弦，来源于郗老师《固体潮汐理论值计算》
dd2=dd0.*sin(tao)+cos(b).*cos(x).*cos(tao);%月亮：赤纬余弦*地方时角余弦，推导得
dd3=cos(b).*cos(x).*sin(tao)-cos(tao).*dd0;%月亮：赤纬余弦*地方时角正弦，推导得
dd4=sin(e).*sin(xs);%bs=0，太阳：赤纬正弦，来源于郗老师《固体潮汐理论值计算》
dd5=cos(xs).*cos(tao)+sin(tao).*sin(xs).*cos(e);%bs=0，太阳：赤纬余弦*地方时角余弦，推导得
dd6=cos(xs).*sin(tao)-cos(tao).*sin(xs).*cos(e);%bs=0，太阳：赤纬余弦*地方时角正弦，推导得
cth=sin(fi)*dd1+cos(fi)*dd2;%月亮地心天顶距的余弦
cths=sin(fi)*dd4+cos(fi)*dd5;%太阳地心天顶距的余弦
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%计算应变固体潮理论值
%%%%%%%%%%%%%%%%%%%%%%%下列公式部分来源于郗老师《固体潮汐与引潮参数》
stra1=14.05*pg*cr.^3;
stra1=stra1.*((cos(ddf)*dd1-sin(ddf)*dd2).^2-cth.^2);
stra1=stra1+17.208*pg*cr.^3.*(3*cth.^2-1);
stra1=stra1+0.02*pg2*cr.^4.*cth.*(10*(cos(ddf)*dd1-sin(ddf)*dd2).^2-(5*cth.^2-1));
stra1=stra1+0.136*pg2.*cr.^4.*(5*cth.^3-3*cth);
stra1=stra1+6.452*pg*crs.^3.*((cos(ddf)*dd4-sin(ddf)*dd5).^2-cths.^2);
stra1=stra1+7.903*pg*crs.^3.*(3*cths.^2-1);
%%%%%%%%%%%%
stra2=14.05*pg*cr.^3.*((cos(ddf)*dd3).^2-cth*cos(ddf).*dd2)/(cos(ddf)^2);
%将张老师程序里/(cos(ddf))^2改为/(cos(ddf)^2)
stra2=stra2-14.05*pg*cr.^3.*cth*tan(ddf).*(cos(ddf)*dd1-sin(ddf)*dd2);
stra2=stra2+17.028*pg*cr.^3.*(3*cth.^2-1);
%张老师程序里为17.208，依照郗老师《固体潮汐与引潮参数》改为17.028
stra2=stra2+0.02*pg2*cr.^4.*(10*cth.*(cos(ddf)*dd3).^2-(5*cth.^2-1)*cos(ddf).*dd2)/(cos(ddf)^2);
%将张老师程序里/(cos(ddf))^2改为/(cos(ddf)^2)
stra2=stra2-0.02*pg2*cr.^4* tan(ddf).*(5*cth.^2-1).*(cos(ddf)*dd1-sin(ddf)*dd2);
stra2=stra2+0.136*pg2*cr.^4.*(5*cth.^3-3*cth);
stra2=stra2+6.452*pg*crs.^3.*((cos(ddf)*dd6).^2-cths*cos(ddf).*dd5)/(cos(ddf)^2);
%将张老师程序里/(cos(ddf))^2改为/(cos(ddf)^2)
stra2=stra2-6.452*pg*crs.^3.*cths*tan(ddf).*(cos(ddf)*dd4-sin(ddf)*dd5);
stra2=stra2+7.903*pg*crs.^3.*(3*cths.^2-1);
%%%%%%%%%%%%
stra3=28.1*pg*cr.^3;
stra3=stra3.*((cos(ddf)*dd1-sin(ddf)*dd2)*cos(ddf).*dd3-cth*sin(ddf).*dd3)/cos(ddf);
%将(cos(ddf)*dd3)改成cos(ddf)*dd3
stra3=stra3+28.1*pg*cr.^3*tan(ddf).*cth.*dd3;
%将cos(ddf)约掉
stra3=stra3+0.041*pg2*cr.^4.*(10*cth.*(cos(ddf)*dd1-sin(ddf)*dd2)*cos(ddf).*dd3)/cos(ddf);
stra3=stra3-0.041*pg2*cr.^4.*(5*cth.^2-1)*tan(ddf).*dd3;
%将sin(ddf)/cos(ddf)化为tan(ddf)
stra3=stra3+0.041*pg2*cr.^4.*(5*cth.^2-1).*dd3*tan(ddf);
%将cos(ddf)约掉
stra3=stra3+12.905*pg*crs.^3.*((cos(ddf)*dd4-sin(ddf)*dd5)*cos(ddf).*dd6-cths*sin(ddf).*dd6)/cos(ddf);
stra3=stra3+12.905*pg*crs.^3*tan(ddf).*cths.*dd6;
%将cos(ddf)约掉
stra3=stra3/2;
%%%%%%%%%%%%%%%%%%%%%%%下列公式部分来源于郗老师《固体潮汐与引潮参数》
fa=faa*pi/180;%第1路方位角（弧度制）
ee1=cos(fa)^2*stra1+sin(fa)^2*stra2-sin(2*fa)*stra3;%第1路应变理论值
es=stra1+stra2;%面应变理论值
% ee3=sin(fa)^2*stra1+cos(fa)^2*stra2+sin(2*fa)*stra3;%第3路应变理论值
% fa=(faa+45)*pi/180;%第2路方位角（弧度制）
% ee2=cos(fa)^2*stra1+sin(fa)^2*stra2-sin(2*fa)*stra3;%第2路应变理论值
% ee4=sin(fa)^2*stra1+cos(fa)^2*stra2+sin(2*fa)*stra3;%第4路应变理论值
%%%%%%%%%%%%%%%%%%%%%%%上列公式部分来源于郗老师《固体潮汐与引潮参数》
end