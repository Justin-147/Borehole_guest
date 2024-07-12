%--------------------------------------------------------------------------
%������ͼ����Ӻ���������ʵ�ֳ�ͼ����
%--------------------------------------------------------------------------
function plhtzhs(inli,inh,name_FBM,FM,data,edata,pre,xx,jgt,TickJieguo,Pname,Fname,f_mm,f_nn,txfznum,txzhenji,fwcs,fwcs2,tname)
%��ͼ����
FNX=14;%�𼶱�ʾ�ֺ�
FNNX='Times New Roman';%�𼶱�ʾ����
LW=0.5;%�߿�
MS=8;%markersize
color_error=0.7;%errorbar�ĻҶ�
cc='r';%��ɫ
mc='k';%makercolor
bs=fwcs(1);%�������߻��Ʒ�Χ
yxmi=fwcs(2);%�������߻��Ʒ�Χ
yxma=fwcs(3);%�������߻��Ʒ�Χ
xxmi=fwcs2(1);%�������߻��Ʒ�Χ
xxma=fwcs2(2);%�������߻��Ʒ�Χ
%%%%%%%%%%%%%%%%%%%�ظ�������Ϊ�˼����жϴ���
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
        
        if isnan(bs)==0%��׼���޶�
            yxi=find(isfinite(datat));
            jzd=mean(datat(yxi));
            sdd=std(datat(yxi),1);
            ylim([jzd-bs*sdd jzd+bs*sdd]);
            ym=ylim;
        else
            if isnan(yxmi)==0%ֱ���޶�
                ylim([yxmi ym(2)]);
                ym=ylim;
            end
            if isnan(yxma)==0%ֱ���޶�
                ylim([ym(1) yxma]);
                ym=ylim;
            end
        end
        if isnan(xxmi)==0%ֱ���޶�
            xxmi=datenum(num2str(xxmi),'yyyymmdd');
            xlim([xxmi xm(2)]);
            xm=xlim;
        end
        if isnan(xxma)==0%ֱ���޶�
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
        datat=data(:,hh); ee=edata(:,hh); namel=[FM{inh(jj)},pre,'-�����'];
        namel(isspace(namel))=[];
        errorbar(xx,datat,ee,'color',color_error*ones(1,3),'LineStyle','none');
        hold on; plot(xx,datat,cc,'LineWidth',LW,'Markersize',MS,'Marker','.','MarkerEdgecolor',mc);
        axis tight; ym=ylim; xm=xlim;
        
        if isnan(bs)==0%��׼���޶�
            yxi=find(isfinite(datat));
            jzd=mean(datat(yxi));
            sdd=std(datat(yxi),1);
            ylim([jzd-bs*sdd jzd+bs*sdd]);
            ym=ylim;
        else
            if isnan(yxmi)==0%ֱ���޶�
                ylim([yxmi ym(2)]);
                ym=ylim;
            end
            if isnan(yxma)==0%ֱ���޶�
                ylim([ym(1) yxma]);
                ym=ylim;
            end
        end
        if isnan(xxmi)==0%ֱ���޶�
            xxmi=datenum(num2str(xxmi),'yyyymmdd');
            xlim([xxmi xm(2)]);
            xm=xlim;
        end
        if isnan(xxma)==0%ֱ���޶�
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