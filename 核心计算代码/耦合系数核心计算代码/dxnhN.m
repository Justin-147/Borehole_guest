function RK = dxnhN(xs,Y,V,P,W)
%最小二乘法多项拟合,返回反演系数
if nargin == 3
    len=length(Y);%这里输入数据长度需一致
    lenuy=length(find(isnan(Y)==0));%有效数据长度
    if lenuy>len*0.5%一半数据有效才计算
        t=1:1:len;
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[V(2:len);NaN]; tmpz2=[V(3:len);NaN;NaN];
        tmpf1=[NaN;V(1:len-1)]; tmpf2=[NaN;NaN;V(1:len-2)];
        Vd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %确保参与计算的向量均是列向量
        V=V(:);Vd=Vd(:);t=t(:);Y=Y(:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Vtmp=V; Ttmp=t; Ttmp2=Ttmp.^2;%V,t,t^2都是连续的
        Vdtmp=Vd; Ytmp=Y;
        inn=[3:len-2]';%Vd的非NaN位置
        inn=intersect(find(isnan(Ytmp)==0),inn);%查找非NaN的位置
        Vtmp=Vtmp(inn); Ttmp=Ttmp(inn); Ttmp2=Ttmp2(inn);  
        Vdtmp=Vdtmp(inn); Ytmp=Ytmp(inn);%只用非NaN数据参与运算
        
        fac=[Vtmp,Vdtmp,ones(length(inn),1),Ttmp,Ttmp2];
        A=fac'*fac;
        B=fac'*Ytmp;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        RK=A\B;
        RK(2)=RK(2)/RK(1);
        %Yn=RK(1)*V+RK(2)*RK(1)*Vd;
        %Yn=Yn+RK(3)+RK(4)*t+RK(5)*(t.*t);%拟合值，仍然用NaN
        RK=[RK(1);RK(2);NaN;NaN;NaN;NaN;RK(3);RK(4);RK(5)];         
        %RK的各值分别对应R,dt,Kp,dtp,Kw,dtw,K0,K1,K2
    else
        RK=NaN*ones(9,1);
        %Yn=NaN*ones(len,1);
    end
elseif nargin==4
    len=length(Y);%这里输入数据长度需一致
    lenuy=length(find(isnan(Y)==0));%有效数据长度
    lenup=length(find(isnan(P)==0));%有效数据长度
    if lenuy>len*0.5&&lenup>len*0.5%一半数据有效才计算
        t=1:1:len;%V与P的时间序列需一致,这里的P既可能是气压，又可能是水位
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[V(2:len);NaN]; tmpz2=[V(3:len);NaN;NaN];
        tmpf1=[NaN;V(1:len-1)]; tmpf2=[NaN;NaN;V(1:len-2)];
        Vd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        
        tmpz1=[P(2:len);NaN]; tmpz2=[P(3:len);NaN;NaN];
        tmpf1=[NaN;P(1:len-1)]; tmpf2=[NaN;NaN;P(1:len-2)];
        Pd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %确保参与计算的向量均是列向量
        V=V(:);P=P(:);Vd=Vd(:);Pd=Pd(:);t=t(:);Y=Y(:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%可替换2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Vtmp=V; Ttmp=t; Ttmp2=Ttmp.^2;%V,t,t^2都是连续的
        Vdtmp=Vd; Ytmp=Y;
        Ptmp=P; Pdtmp=Pd;        
        inn=[3:len-2]';%Vd的非NaN位置
        inn=intersect(find(isnan(Ytmp)==0),inn);%查找非NaN的位置
        inn=intersect(find(isnan(Ptmp)==0),inn);
        inn=intersect(find(isnan(Pdtmp)==0),inn);
        Vtmp=Vtmp(inn); Ttmp=Ttmp(inn); Ttmp2=Ttmp2(inn);  
        Pdtmp=Pdtmp(inn); Ptmp=Ptmp(inn);
        Vdtmp=Vdtmp(inn); Ytmp=Ytmp(inn);%只用非NaN数据参与运算
                
        fac=[Vtmp,Vdtmp,Ptmp,Pdtmp,ones(length(inn),1),Ttmp,Ttmp2];
        A=fac'*fac;
        B=fac'*Ytmp;
        RK=A\B;
        RK(2)=RK(2)/RK(1);
        RK(4)=RK(4)/RK(3);
        %Yn=RK(1)*V+RK(2)*RK(1)*Vd;
        %Yn=Yn+RK(3)*P+RK(4)*RK(3)*Pd;
        %Yn=Yn+RK(5)+RK(6)*t+RK(7)*(t.*t);%拟合值，仍然用NaN
        if xs==2
            RK=[RK(1);RK(2);RK(3);RK(4);NaN;NaN;RK(5);RK(6);RK(7)];
        elseif xs==3
            RK=[RK(1);RK(2);NaN;NaN;RK(3);RK(4);RK(5);RK(6);RK(7)];
        else
            return;
        end        
        %RK的各值分别对应R,dt,Kp,dtp,Kw,dtw,K0,K1,K2        
    else
        RK=NaN*ones(9,1);
        %Yn=NaN*ones(len,1);
    end
elseif nargin==5
    len=length(Y);%这里输入数据长度需一致
    lenuy=length(find(isnan(Y)==0));%有效数据长度
    lenup=length(find(isnan(P)==0));%有效数据长度
    lenuw=length(find(isnan(W)==0));%有效数据长度
    if lenuy>len*0.5&&lenup>len*0.5&&lenuw>len*0.5%一半数据有效才计算
        t=1:1:len;%V与P、W的时间序列需一致
        %%%%%%%%%%%%%%%%%%%%%%%%%%%可替换1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %     非循环形式的代码(5点等距公式近似求导)
        tmpz1=[V(2:len);NaN]; tmpz2=[V(3:len);NaN;NaN];
        tmpf1=[NaN;V(1:len-1)]; tmpf2=[NaN;NaN;V(1:len-2)];
        Vd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        
        tmpz1=[P(2:len);NaN]; tmpz2=[P(3:len);NaN;NaN];
        tmpf1=[NaN;P(1:len-1)]; tmpf2=[NaN;NaN;P(1:len-2)];
        Pd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        
        tmpz1=[W(2:len);NaN]; tmpz2=[W(3:len);NaN;NaN];
        tmpf1=[NaN;W(1:len-1)]; tmpf2=[NaN;NaN;W(1:len-2)];
        Wd=(2/3)*(tmpz1-tmpf1)-(1/12)*(tmpz2-tmpf2);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%可替换1%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %确保参与计算的向量均是列向量
        V=V(:);P=P(:);W=W(:);Vd=Vd(:);Pd=Pd(:);Wd=Wd(:);t=t(:);Y=Y(:);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%可替换2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        Vtmp=V; Ttmp=t; Ttmp2=Ttmp.^2;%V,t,t^2都是连续的
        Vdtmp=Vd; Ytmp=Y;
        Ptmp=P; Pdtmp=Pd;
        Wtmp=W; Wdtmp=Wd;        
        inn=[3:len-2]';%Vd的非NaN位置
        inn=intersect(find(isnan(Ytmp)==0),inn);%查找非NaN的位置
        inn=intersect(find(isnan(Ptmp)==0),inn);
        inn=intersect(find(isnan(Pdtmp)==0),inn);
        inn=intersect(find(isnan(Wtmp)==0),inn);
        inn=intersect(find(isnan(Wdtmp)==0),inn);
        Vtmp=Vtmp(inn); Ttmp=Ttmp(inn); Ttmp2=Ttmp2(inn);  
        Pdtmp=Pdtmp(inn); Ptmp=Ptmp(inn);
        Wdtmp=Wdtmp(inn); Wtmp=Wtmp(inn);
        Vdtmp=Vdtmp(inn); Ytmp=Ytmp(inn);%只用非NaN数据参与运算
        
        fac=[Vtmp,Vdtmp,Ptmp,Pdtmp,Wtmp,Wdtmp,ones(length(inn),1),Ttmp,Ttmp2];
        A=fac'*fac;
        B=fac'*Ytmp;
        RK=A\B;
        RK(2)=RK(2)/RK(1);
        RK(4)=RK(4)/RK(3);
        RK(6)=RK(6)/RK(5);
        %Yn=RK(1)*V+RK(2)*RK(1)*Vd;
        %Yn=Yn+RK(3)*P+RK(4)*RK(3)*Pd;
        %Yn=Yn+RK(5)*W+RK(6)*RK(5)*Wd;
        %Yn=Yn+RK(7)+RK(8)*t+RK(9)*(t.*t);%拟合值，仍然用NaN
        %RK的各值分别对应R,dt,Kp,dtp,Kw,dtw,K0,K1,K2
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%可替换2%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    else
        RK=NaN*ones(9,1);
        %Yn=NaN*ones(len,1);
    end
else
    return;
end
end
