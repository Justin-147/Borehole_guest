%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
%C                        XW.FOR                                       C
%CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC
function FAI=XW(IZL,IA,IB,IC,ID,IE,IF,ISC,TAO,S,H,P,N,PS)
M=fix(ISC/10)+ISC-fix(ISC/10)*10;
if M==fix(M/2)*2
    IG=0;
else
    IG=-1;
end
if IZL==3||IZL==6
    IG=IG+1;
else
end
FAI=IA*TAO+IB*S+IC*H+ID*P-IE*N+IF*PS+IG*90;
FAI=FX(FAI);

    function y=FX(X)
        y=X-fix(X/360)*360;
    end
end

