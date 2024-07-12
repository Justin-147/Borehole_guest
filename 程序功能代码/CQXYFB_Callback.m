% --------------------------------------------------------------------
% 批量抽取想要分波数据保存
% --------------------------------------------------------------------
function CQXYFB_Callback(hObject, eventdata, handles)
% 批量抽取想要分波数据保存
tinf={'%请保证您之前曾经做过调和分析处理';...
    '%找到程序之前为您存储的以TH-打头的mat文件'};
set(handles.inform,'String',tinf,'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
%读文件名
[Fname,Pname]=uigetfile({'TH-*.mat','调和分析结果文件(*.mat)'},'请挑选待处理的文件','MultiSelect','on');
%[Fname,Pname]=uigetfile({'TC_TH-*.mat;TH-*.mat','调和分析结果文件(*.mat)';'TC_TH-*.mat','剔除异常点后的结果文件(*.mat)';'TH-*.mat','未剔除异常点的结果文件(*.mat)'},'请挑选待处理的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    QKtsxx(handles);     return;
else
    NFZ=1;
end
dnl=[1,2,3,4];
[inl,valuel]=listdlg('PromptString','选择所需的数据','SelectionMode',...
    'Multiple','ListString',{'潮汐因子','潮汐因子误差','相位滞后','相位滞后误差'...
    },'InitialValue',dnl,'ListSize',[200 250]);
if valuel==0
    QKtsxx(handles);     return;
end
FM={'  Q1','  O1','  M1','  J1','  K1','  S1','  P1','PSK1',' OO1','S1K1',' PI1','PSI1','PHI1',...
    ' 2N2','  N2','  M2','  L2','  S2','  K2','  M3'};
[inh,valueh]=listdlg('PromptString','选择所需的分波','SelectionMode',...
    'Multiple','ListString',FM,'InitialValue',1,'ListSize',[200 250]);
if valueh==0
    QKtsxx(handles);     return;
end
set(handles.inform,'String','从表中选中您已计算并希望抽选出的分波','Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
if NFZ==1%一个文件
    Fname={Fname};
end

for iiNFZ=1:1:NFZ
    dbfile=[Pname,Fname{iiNFZ}];
    load(dbfile); %导入数据
    if (exist('FBM','var')&&exist('Factor','var')&&exist('PhaseL','var')&&exist('Msf','var')&&exist('Msp','var')&&exist('timej','var'))==0
        set(handles.inform,'String','因数据不全未处理','Fontsize',10,'Fontweight','normal','Horizontalalignment','left'); return;
    end
    FF=Fname{iiNFZ};
    f_nn=find(FF=='.')-1;
    f_mm=find(FF=='-',1)+1;
    if isempty(f_mm)
        f_mm=1;
    end
    if isempty(f_nn)
        f_nn=length(FF);
    end
    name_FBM=char(struct2cell(FBM));
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    for ii=1:1:length(inl)
        if inl(ii)==1
            data=Factor;         pre='潮汐因子';
        elseif inl(ii)==2
            data=Msf;            pre='因子误差';
        elseif inl(ii)==3
            data=PhaseL;         pre='相位滞后';
        else
            data=Msp;            pre='相位误差';
        end
        data(find(isnan(data)==1))=QS;
        for jj=1:1:length(inh)
            hh=strmatch(FM{inh(jj)},name_FBM);
            datat=data(:,hh); namel=[FM{inh(jj)},pre];
            namel(isspace(namel))=[];
            outname=strcat(Pname,namel,FF(f_mm:f_nn),'.txt');
            %             if FF(1:2)=='TC'
            %                 outname=strcat(Pname,namel,FF(f_mm:f_nn),'tc.txt');
            %             else
            %                 outname=strcat(Pname,namel,FF(f_mm:f_nn),'.txt');
            %             end
            fido=fopen(outname,'wt');
            fprintf(fido,'%8i %.5f\n',[timej';datat']);
            fclose(fido);
        end
    end
end
set(handles.inform,'String',{'抽取的分波数据已经按默认文件名保存完毕';['可在',Pname,'下找到']},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
end