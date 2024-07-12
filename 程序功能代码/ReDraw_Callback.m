% --------------------------------------------------------------------
%重新绘图函数（更改x,y的范围及间距）
% --------------------------------------------------------------------
function ReDraw_Callback(hObject, eventdata, handles)
datexx=handles.datexx;
ytmin=str2num(get(handles.YTMin,'String'));
ytstep=str2num(get(handles.YTStep,'String'));
ytmax=str2num(get(handles.YTMax,'String'));
xtmin=get(handles.XTMin,'String');
xtmax=get(handles.XTMax,'String');
dx1=datenum(xtmin(1:8),'yyyymmdd');
dx2=datenum(xtmax(1:8),'yyyymmdd');
if dx1<datexx(1)||dx2>datexx(2)
    errordlg('绘图范围不能超出数据范围', '范围错误');    return;    
end
if dx1>dx2
    errordlg('xmin不能大于xmax', '范围错误');    return;    
end
xsmin=dx1;
xsmax=dx2;
set(handles.MainPlotZone,'xlim',[xsmin xsmax]);
set(handles.MainPlotZone,'ylim',[ytmin ytmax]);
set(handles.MainPlotZone,'ytick',[ytmin:ytstep:ytmax]); 
%%%%
jgt=round((dx2-dx1)/365);
if jgt==5
    jgt=4;
elseif jgt==0
    jgt=1;
elseif jgt>5
    jgt=12;
end
%%%%
stdate=str2num(xtmin(1:8));
styy=mod(fix(stdate/100),100);%第一个月份
stnn=fix(stdate/10000);%第一个年份
tpend=str2num(xtmax(1:8));
TickJieguo=FHXtick(jgt,stnn,styy,tpend);%返回tick及label
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mb=handles.shuju(1);
zb=handles.shuju(2);
tl=handles.shuju(3);
lj=handles.shuju(4);
ab=handles.shuju(5);
FNX=handles.shuju(6);
h2=handles.jubing{1};
h3=handles.jubing{2};
h4=handles.jubing{3};
h5=handles.jubing{4};
h6=handles.jubing{5};

hold on;
xs1=xsmax+(xsmax-xsmin)/ab;
ys1=ytmin-(ytmax-ytmin)/mb;
ys2=ytmin-(ytmax-ytmin)/zb;
ys3=(ytmax-ytmin)/tl+ytmin;
ys4=ytmin-(ytmax-ytmin)/lj;
if jgt~=12
    xt=TickJieguo{1};%minortick的位置
    xl=TickJieguo{2};%minortick的label
    xtm=TickJieguo{3};%主tick的位置
    ml=TickJieguo{4};%主ticklabel
    set(handles.MainPlotZone,'xtick',xt);%minortick
    set(handles.MainPlotZone,'xticklabel',xl);%minorticklabel
    set(h2,'Position',[xs1,ys1],'String','月份');
    if ishandle(h3)
        delete(h3);
    end
    if ishandle(h5)
        delete(h5);
    end
    set(h4,'Position',[xs1,ys2],'String','年份');
    %主tick
    lenx=length(xtm);  zxtm=[xtm';xtm';NaN*ones(1,lenx)];
    zxtm=zxtm(:);
    zytm=[ones(1,lenx)*ytmin;ones(1,lenx)*ys3;ones(1,lenx)*NaN];
    zytm=zytm(:);       h5=plot(handles.MainPlotZone,zxtm,zytm,'k');
    %主ticklabel
    if isempty(xtm)
        ns=TickJieguo{5};
        h3=text((xsmin+xsmax)/2,ys2,num2str(ns),'HorizontalAlignment',...
             'center','VerticalAlignment','top','FontSize',FNX);%不足1年的情况      
    else        
        h3=text(xtm,ys2*ones(1,length(xtm)),ml,'HorizontalAlignment',...
            'center','VerticalAlignment','top','FontSize',FNX);          
    end
else
    xt=TickJieguo{1};%tick的位置
    xl=TickJieguo{2};%tick的label
    set(handles.MainPlotZone,'xtick',xt);%tick
    set(handles.MainPlotZone,'xticklabel',xl);%ticklabel
    set(h2,'Position',[xs1,ys1],'String','年份');
    if ishandle(h3)
        delete(h3);
    end
    if ishandle(h4)
        delete(h4);
    end
    if ishandle(h5)
        delete(h5);
    end
end
%set(h6,'Position',[(xsmin+xsmax)/2,ys4]);

dzjb=handles.dzjubing;
zjjb=handles.zjjubing;
txzhenji=handles.txzhenji;
if isempty(dzjb)==0
    tx=get(dzjb,'XData');
    ty=get(dzjb,'YData');
    yfw=ytmax-ytmin;
    yyx=ytmax-yfw/5;
    yys=ytmax-yfw/10;
    lenty=length(ty);
    ty(1:3:lenty-2)=yyx;
    ty(2:3:lenty-1)=yys;
    ty(3:3:lenty)=NaN;
    set(dzjb,'YData',ty);
    delete(zjjb);
    zjy=yys*ones(lenty/3,1);
    zjx=tx(1:3:lenty-2);    
    zjjb=text(zjx,zjy,txzhenji,'VerticalAlignment','bottom','HorizontalAlignment','center');
    handles.zjjubing=zjjb;
end

handles.jubing={h2,h3,h4,h5,h6};
guidata(gcbo,handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
return;