function RK = dxnhJ(Y,V,P,W)
%最小二乘法多项拟合,返回反演系数
%重复代码是为了如果遇到异常情况能够尽快跳过
len=length(Y);%这里输入数据长度需一致
t=1:1:len;  t=t'; tt=2*t+1;
if nargin==2    
    lenuy=length(find(isnan(Y)==0));%有效数据长度
    if lenuy>len*0.5%一半数据有效才计算
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[V(2:len);NaN]; tmpz2=[V(3:len);NaN;NaN];
        tmpf1=[NaN;V(1:len-1)]; tmpf2=[NaN;NaN;V(1:len-2)];
        Vd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %%%%%%%%%%%%%%%%%%%%%%%%
        Yc=diff(Y);        Yc=[Yc;Yc(end)];%观测数据差分
        Vc=diff(V);        Vc=[Vc;Vc(end)];%理论数据差分
        Vdc=diff(Vd);      Vdc=[Vdc;Vdc(end)];%理论数据导数差分
        inn=intersect(find(isnan(Yc)==0),t);%查找非NaN的位置
        inn=intersect(find(isnan(Vdc)==0),inn);
        %重复部分
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Yc=Yc(inn); Vc=Vc(inn); Vdc=Vdc(inn); tt=tt(inn);%只用非NaN数据参与运算
        D1=Vc;  D2=Vdc; D3=Vc;  D4=Vdc; D5=ones(length(D1),1);  D6=tt; YY=Yc;
        inz=find(Vc>0);
        D3(inz)=0; D4(inz)=0;
        inf=setxor(inz,1:1:length(Vc));
        D1(inf)=0; D2(inf)=0;
        BB=[D1,D2,D3,D4,D5,D6];
        NN=BB'*BB; WW=BB'*YY; R=NN\WW;
        RK=abs(R(1)/R(3));%加卸载响应比
    else
        RK=NaN;
    end
elseif nargin==3
    lenuy=length(find(isnan(Y)==0));%有效数据长度
    lenup=length(find(isnan(P)==0));%有效数据长度
    if lenuy>len*0.5&&lenup>len*0.5%一半数据有效才计算
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[V(2:len);NaN]; tmpz2=[V(3:len);NaN;NaN];
        tmpf1=[NaN;V(1:len-1)]; tmpf2=[NaN;NaN;V(1:len-2)];
        Vd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %%%%%%%%%%%%%%%%%%%%%%%%
        Yc=diff(Y);        Yc=[Yc;Yc(end)];%观测数据差分
        Vc=diff(V);        Vc=[Vc;Vc(end)];%理论数据差分
        Vdc=diff(Vd);      Vdc=[Vdc;Vdc(end)];%理论数据导数差分
        inn=intersect(find(isnan(Yc)==0),t);%查找非NaN的位置
        inn=intersect(find(isnan(Vdc)==0),inn);
        %重复部分
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[P(2:len);NaN]; tmpz2=[P(3:len);NaN;NaN];
        tmpf1=[NaN;P(1:len-1)]; tmpf2=[NaN;NaN;P(1:len-2)];
        Pd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %%%%%%%%%%%%%%%%%%%%%%%%
        Pc=diff(P);        Pc=[Pc;Pc(end)];%气压/水位数据差分
        Pdc=diff(Pd);      Pdc=[Pdc;Pdc(end)];%气压/水位数据导数差分
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        inn=intersect(find(isnan(Pdc)==0),inn);%查找非NaN的位置
        Yc=Yc(inn); Vc=Vc(inn); Vdc=Vdc(inn); tt=tt(inn); Pc=Pc(inn);  Pdc=Pdc(inn);%只用非NaN数据参与运算
        D1=Vc;  D2=Vdc; D3=Vc;  D4=Vdc;  D5=Pc;  D6=Pdc;   D7=ones(length(D1),1);  D8=tt; YY=Yc;
        inz=find(Vc>0);
        D3(inz)=0; D4(inz)=0;
        inf=setxor(inz,1:1:length(Vc));
        D1(inf)=0; D2(inf)=0;
        BB=[D1,D2,D3,D4,D5,D6,D7,D8];
        NN=BB'*BB; WW=BB'*YY; R=NN\WW;
        RK=abs(R(1)/R(3));%加卸载响应比
    else
        RK=NaN;
    end
elseif nargin==4
    lenuy=length(find(isnan(Y)==0));%有效数据长度
    lenup=length(find(isnan(P)==0));%有效数据长度
    lenuw=length(find(isnan(W)==0));%有效数据长度
    if lenuy>len*0.5&&lenup>len*0.5&&lenuw>len*0.5%一半数据有效才计算
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[V(2:len);NaN]; tmpz2=[V(3:len);NaN;NaN];
        tmpf1=[NaN;V(1:len-1)]; tmpf2=[NaN;NaN;V(1:len-2)];
        Vd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %%%%%%%%%%%%%%%%%%%%%%%%
        Yc=diff(Y);        Yc=[Yc;Yc(end)];%观测数据差分
        Vc=diff(V);        Vc=[Vc;Vc(end)];%理论数据差分
        Vdc=diff(Vd);      Vdc=[Vdc;Vdc(end)];%理论数据导数差分
        inn=intersect(find(isnan(Yc)==0),t);%查找非NaN的位置
        inn=intersect(find(isnan(Vdc)==0),inn);
        %重复部分
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[P(2:len);NaN]; tmpz2=[P(3:len);NaN;NaN];
        tmpf1=[NaN;P(1:len-1)]; tmpf2=[NaN;NaN;P(1:len-2)];
        Pd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        tmpz1=[W(2:len);NaN]; tmpz2=[W(3:len);NaN;NaN];
        tmpf1=[NaN;W(1:len-1)]; tmpf2=[NaN;NaN;W(1:len-2)];
        Wd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %%%%%%%%%%%%%%%%%%%%%%%%
        Pc=diff(P);        Pc=[Pc;Pc(end)];%气压数据差分
        Pdc=diff(Pd);      Pdc=[Pdc;Pdc(end)];%气压数据导数差分
        Wc=diff(W);        Wc=[Wc;Wc(end)];%水位数据差分
        Wdc=diff(Wd);      Wdc=[Wdc;Wdc(end)];%水位数据导数差分
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        inn=intersect(find(isnan(Pdc)==0),inn);%查找非NaN的位置
        Yc=Yc(inn); Vc=Vc(inn); Vdc=Vdc(inn); tt=tt(inn); Pc=Pc(inn);  Pdc=Pdc(inn);  Wc=Wc(inn);  Wdc=Wdc(inn);%只用非NaN数据参与运算
        D1=Vc;  D2=Vdc; D3=Vc;  D4=Vdc;  D5=Pc;  D6=Pdc;  D7=Wc;  D8=Wdc; D9=ones(length(D1),1);  D10=tt; YY=Yc;
        inz=find(Vc>0);
        D3(inz)=0; D4(inz)=0;
        inf=setxor(inz,1:1:length(Vc));
        D1(inf)=0; D2(inf)=0;
        BB=[D1,D2,D3,D4,D5,D6,D7,D8,D9,D10];
        NN=BB'*BB; WW=BB'*YY; R=NN\WW;
        RK=abs(R(1)/R(3));%加卸载响应比
    else
        RK=NaN;
    end
else
    return;
end
end
