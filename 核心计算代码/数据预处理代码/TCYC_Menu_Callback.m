% --------------------------------------------------------------------
% 剔除异常数值点
% --------------------------------------------------------------------
function TCYC_Menu_Callback(hObject, eventdata, handles)
% 剔除异常数值点
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%读文件名
[Fname,Pname]=uigetfile({'*.txt','txt文件(*.txt)';'*.dat','dat文件(*.dat)';'*.*','所有符合要求的文件(*.*)'},'请挑选待处理的文件','MultiSelect','on');
%完整文件路径
if iscell(Fname)
    NFZ=length(Fname);
elseif Fname==0  %如果没有打开文件，则跳出程序
    QKtsxx(handles);     return;
else
    NFZ=1;
end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
dnFW=[1];
[inFW,valueFW]=listdlg('PromptString','限定方式','SelectionMode',...
    'Single','ListString',{'标准差限定','范围限定'},...
    'InitialValue',dnFW,'ListSize',[200 250]);
if valueFW==0
    QKtsxx(handles);     return;
end

if inFW==1
    depfw=struct('bs','3','QS','999999.0');
    prompt={'超过几倍标准差的数据点剔除','缺数标记'};
    title='标准差限定'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'bs','QS'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
elseif inFW==2
    depfw=struct('yxmi','0','yxma','1','QS','99999');
    prompt={'数据下限','数据上限','缺数标记'};
    title='范围限定'; lines=1; resize='on';
    hi=inputdlg(prompt,title,lines,struct2cell(depfw),resize);
    if isempty(hi)
        QKtsxx(handles);     return;
    end
    fields={'yxmi','yxma','QS'};
    if size(hi,1)>0 depfw=cell2struct(hi,fields,1); end
else
    return;
end
%%%清空提示信息栏
QKtsxx(handles);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if NFZ==1%一个文件
    Fname={Fname};
end
QS=str2num(depfw.QS);

if inFW==1
    for iiNFZ=1:1:NFZ
        dbfile=[Pname,Fname{iiNFZ}];
        FF=Fname{iiNFZ};
        tmp=load(dbfile); [M,N]=size(tmp);
        %如果不是两列数据，则跳过文件
        if N~=2
            continue;
        else
            dataz=tmp(:,2);    timet=tmp(:,1);
        end
        %填补断数
        [dataz,timet]=tbds(dataz,timet,QS);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dataz(find(dataz==QS))=NaN;%替换缺数为NaN，便于计算
        bs=str2num(depfw.bs);
        iny=find(isfinite(dataz));
        jz=mean(dataz(iny));
        bzc=std(dataz(iny),1);
        dataz(find(dataz<jz-bs*bzc))=NaN;
        dataz(find(dataz>jz+bs*bzc))=NaN;
        
        dataz(find(isnan(dataz)))=QS;%替换NaN为缺数标记
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'-tcyc','.txt');
        fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
        fido=fopen(outname,'wt');
        fprintf(fido,fm,[timet';dataz']);
        fclose(fido);
    end
elseif inFW==2
    for iiNFZ=1:1:NFZ
        dbfile=[Pname,Fname{iiNFZ}];
        FF=Fname{iiNFZ};
        tmp=load(dbfile); [M,N]=size(tmp);
        %如果不是两列数据，则跳过文件
        if N~=2
            continue;
        else
            dataz=tmp(:,2);    timet=tmp(:,1);
        end
        %填补断数
        [dataz,timet]=tbds(dataz,timet,QS);
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        dataz(find(dataz==QS))=NaN;%替换缺数为NaN，便于计算
        yxmi=str2num(depfw.yxmi);
        yxma=str2num(depfw.yxma);
        dataz(find(dataz<yxmi))=NaN;
        dataz(find(dataz>yxma))=NaN;
        
        dataz(find(isnan(dataz)))=QS;%替换NaN为缺数标记
        f_nn=find(FF=='.')-1;
        outname=strcat(Pname,FF(1:f_nn),'-tcyc','.txt');
        fm=strcat('%',num2str(length(num2str(timet(1)))),'i %.5f\n');
        fido=fopen(outname,'wt');
        fprintf(fido,fm,[timet';dataz']);
        fclose(fido);
    end    
else
    return;
end
set(handles.inform,'String',{'处理后的数据已经按默认文件名保存完毕';['可在',Pname,'下找到'];'后缀名是-tcyc.txt'},'Fontsize',10,'Fontweight','normal','Horizontalalignment','left');
