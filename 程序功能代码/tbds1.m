%-------------------------------------------------------------------------
%填补断数
%-------------------------------------------------------------------------
function [dataz,timet]=tbds1(dataz,timet,QS)
timet=timet(:);
dataz=dataz(:);
len=length(timet);
timet_s=num2str(timet);
[len1,len2]=size(timet_s);
if len2==12%分钟值数据
    bcc=1440;
    tt=datenum(timet_s,'yyyymmddHHMM');
elseif len2==10%整点值数据
    bcc=24;
    tt=datenum(timet_s,'yyyymmddHH');
elseif len2==8%日值数据
    bcc=1;
    tt=datenum(timet_s,'yyyymmdd');
else
    return;
end    
tt1=tt(1:len-1); tt2=tt(2:len);
sjjg=round((tt2-tt1)*bcc);%前后两个时间的间隔
iwz=find(sjjg~=1);%断数的位置 
dj=0;
if len2==12%以代码的重复性来减少判断次数
    for ii=1:1:length(iwz)
        tbb=[];     js=sjjg(iwz(ii))-1;
        for jj=1:1:js
            [yy,mm,dd,hh,mm]=datevec(tt1(iwz(ii))+jj/bcc);            
            tmp=yy*100000000+mm*1000000+dd*10000+hh*100+mm;            
            tbb=[tbb;tmp];
        end
        dbb=QS*ones(length(tbb),1);
        len=length(timet);
        timet=[timet(1:iwz(ii)+dj);tbb;timet(iwz(ii)+dj+1:len)];
        dataz=[dataz(1:iwz(ii)+dj);dbb;dataz(iwz(ii)+dj+1:len)];
        dj=dj+js;
    end
elseif len2==10
    for ii=1:1:length(iwz)
        tbb=[];     js=sjjg(iwz(ii))-1;
        for jj=1:1:js
            [yy,mm,dd,hh]=datevec(tt1(iwz(ii))+jj/bcc);
            tmp=yy*1000000+mm*10000+dd*100+hh;
            tbb=[tbb;tmp];
        end
        dbb=QS*ones(length(tbb),1);
        len=length(timet);
        timet=[timet(1:iwz(ii)+dj);tbb;timet(iwz(ii)+dj+1:len)];
        dataz=[dataz(1:iwz(ii)+dj);dbb;dataz(iwz(ii)+dj+1:len)];
        dj=dj+js;
    end            
elseif len2==8
    for ii=1:1:length(iwz)
        tbb=[];     js=sjjg(iwz(ii))-1;
        for jj=1:1:js
            [yy,mm,dd]=datevec(tt1(iwz(ii))+jj/bcc);
            tmp=yy*10000+mm*100+dd;
            tbb=[tbb;tmp];
        end
        dbb=QS*ones(length(tbb),1);
        len=length(timet);
        timet=[timet(1:iwz(ii)+dj);tbb;timet(iwz(ii)+dj+1:len)];
        dataz=[dataz(1:iwz(ii)+dj);dbb;dataz(iwz(ii)+dj+1:len)];
        dj=dj+js;
    end    
end
end