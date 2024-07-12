%--------------------------------------------------------------------------
%批量画图里的子函数，用来实现成图功能
%--------------------------------------------------------------------------
function plhtzhs(inli,inh,name_FBM,FM,data,edata,pre,xx,jgt,TickJieguo,Pname,Fname,f_mm,f_nn,txfznum,txzhenji,fwcs,fwcs2,tname)
%绘图参数
FNX=14;%震级表示字号
FNNX='Times New Roman';%震级表示字体
LW=0.5;%线宽
MS=8;%markersize
color_error=0.7;%errorbar的灰度
cc='r';%颜色
mc='k';%makercolor
bs=fwcs(1);%控制曲线绘制范围
yxmi=fwcs(2);%控制曲线绘制范围
yxma=fwcs(3);%控制曲线绘制范围
xxmi=fwcs2(1);%控制曲线绘制范围
xxma=fwcs2(2);%控制曲线绘制范围
%%%%%%%%%%%%%%%%%%%重复代码是为了减少判断次数
hp=figure; hold on;
set(hp,'Position',[360 280 460 245]);
set(hp,'PaperPositionMode','auto');
if inli==1||inli==3
    for jj=1:1:length(inh)
        hh=strmatch(FM{inh(jj)},name_FBM);
        datat=data(:,hh); ee=edata(:,hh); namel=[FM{inh(jj)},pre];
        namel(isspace(namel))=[];
        errorbar(xx,datat,ee,'color',color_error*ones(1,3),'LineStyle','none');
        hold on; plot(xx,datat,cc,'LineWidth',LW,'Markersize',MS,'Marker','.','MarkerEdgecolor',mc);
        axis tight; ym=ylim; xm=xlim;
        
        if isnan(bs)==0%标准差限定
            yxi=find(isfinite(datat));
            jzd=mean(datat(yxi));
            sdd=std(datat(yxi),1);
            ylim([jzd-bs*sdd jzd+bs*sdd]);
            ym=ylim;
        else
            if isnan(yxmi)==0%直接限定
                ylim([yxmi ym(2)]);
                ym=ylim;
            end
            if isnan(yxma)==0%直接限定
                ylim([ym(1) yxma]);
                ym=ylim;
            end
        end
        if isnan(xxmi)==0%直接限定
            xxmi=datenum(num2str(xxmi),'yyyymmdd');
            xlim([xxmi xm(2)]);
            xm=xlim;
        end
        if isnan(xxma)==0%直接限定
            xxma=datenum(num2str(xxma),'yyyymmdd');
            xlim([xm(1) xxma]);
            xm=xlim;
        end
        
        BmTick(gca,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn);
        if ~isempty(tname)
            title(tname);
        end
        hold off; %set(gcf,'outerposition',get(0,'screensize'));
        set(gca,'Position',[0.1300 0.1400 0.7750 0.77]);
        Figname=strcat(Pname,namel,Fname(f_mm:f_nn));
        saveas(hp,Figname,'emf');
        saveas(hp,Figname,'pdf');
        saveas(hp,Figname,'fig');
        %saveas(hp,Figname,'ai');
        close(hp);
    end
else
    for jj=1:1:length(inh)
        hh=strmatch(FM{inh(jj)},name_FBM);
        datat=data(:,hh); ee=edata(:,hh); namel=[FM{inh(jj)},pre,'-标地震'];
        namel(isspace(namel))=[];
        errorbar(xx,datat,ee,'color',color_error*ones(1,3),'LineStyle','none');
        hold on; plot(xx,datat,cc,'LineWidth',LW,'Markersize',MS,'Marker','.','MarkerEdgecolor',mc);
        axis tight; ym=ylim; xm=xlim;
        
        if isnan(bs)==0%标准差限定
            yxi=find(isfinite(datat));
            jzd=mean(datat(yxi));
            sdd=std(datat(yxi),1);
            ylim([jzd-bs*sdd jzd+bs*sdd]);
            ym=ylim;
        else
            if isnan(yxmi)==0%直接限定
                ylim([yxmi ym(2)]);
                ym=ylim;
            end
            if isnan(yxma)==0%直接限定
                ylim([ym(1) yxma]);
                ym=ylim;
            end
        end
        if isnan(xxmi)==0%直接限定
            xxmi=datenum(num2str(xxmi),'yyyymmdd');
            xlim([xxmi xm(2)]);
            xm=xlim;
        end
        if isnan(xxma)==0%直接限定
            xxma=datenum(num2str(xxma),'yyyymmdd');
            xlim([xm(1) xxma]);
            xm=xlim;
        end
        
        if ~isempty(txfznum)
            lentx=length(txfznum);
            yfw=ym(2)-ym(1); yyx=ym(2)-yfw/5; yys=ym(2)-yfw/10;
            dzx=[txfznum';txfznum';NaN*ones(1,lentx)];
            dzy=[yyx*ones(1,lentx);yys*ones(1,lentx);NaN*ones(1,lentx)];
            dzx=dzx(:); dzy=dzy(:); dzjb=plot(dzx,dzy,'r-');
            zjjb=text(txfznum,yys*ones(lentx,1),txzhenji,'VerticalAlignment','bottom','HorizontalAlignment','center','FontName', FNNX,'FontSize',FNX);
        end
        BmTick(gca,xm,ym,jgt,TickJieguo,Fname,pre,f_mm,f_nn);
        if ~isempty(tname)
            title(tname);
        end
        hold off; %set(gcf,'outerposition',get(0,'screensize'));
        set(gca,'Position',[0.1300 0.1400 0.7750 0.77]);
        Figname=strcat(Pname,namel,Fname(f_mm:f_nn));
        saveas(hp,Figname,'emf');
        saveas(hp,Figname,'pdf');
        saveas(hp,Figname,'fig');
        %saveas(hp,Figname,'ai');
        close(hp);
    end
end
end