% --------------------------------------------------------------------
%单文件S变换结果绘图区成图
% --------------------------------------------------------------------
function STPinMPZ_Callback(hObject, eventdata, handles)
tinf={'%请保证您之前曾经做过S变换';...
    '%找到程序之前为您存储的以ST-打头的mat文件';...
    '%请注意，如果数据量较大可能导致程序运行缓慢，并影响后续操作';...
    '%请关闭并重新启动程序来进行其它操作'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
[Fname,Pname]=uigetfile({'ST-*.mat','S变换结果文件(*.mat)'},'请挑选待处理的文件','MultiSelect','off');
dbfile=[Pname,Fname];
%如果没有打开文件，则跳出程序
if sum(dbfile)==0
    QKtsxx(handles);     return;
end
load(dbfile);
if (exist('stout','var')&&exist('tout','var')&&exist('fout','var'))==0
    errordlg('文件内数据不全，请确认之前进行过S变换！', '数据错误');
    QKtsxx(handles);     return;
end

dnl=1;
[inl,valuel]=listdlg('PromptString','选择绘图类型','SelectionMode',...
    'Multiple','ListString',{'平面图','三维曲面图'},...
    'InitialValue',dnl,'ListSize',[200 250]);
KJXpn(handles,'off');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
FNL=15;    FNX=14;%字号
FNNX='Times New Roman';
FNNL='楷体_GB2312';
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if inl==1
    imagesc(tout,fout,abs(stout));  colorbar('eastoutside'); axis xy;
    colormap('jet');
    set(gca,'FontSize',FNX,'FontName',FNNX);
    ylabel('频率','FontSize',FNL,'FontName',FNNL);
    xlabel('时间','FontSize',FNL,'FontName',FNNL);
elseif inl==2
    [TT,FF]=meshgrid(tout,fout);
    surf(TT,FF,abs(stout));
    colorbar('eastoutside');
    colormap('jet');
    shading interp;
    set(gca,'FontSize',FNX,'FontName',FNNX);
    ylabel('频率','FontSize',FNL,'FontName',FNNL);
    xlabel('时间','FontSize',FNL,'FontName',FNNL);
    set(gca,'view',[6 72]);
else    
end
QKtsxx(handles);     return;

