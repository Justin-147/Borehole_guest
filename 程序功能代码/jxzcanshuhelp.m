%---------------------------------------------------------
% 加卸载响应比参数帮助信息
%---------------------------------------------------------
function tinf=jxzcanshuhelp( )
% 加卸载响应比参数帮助信息
        tinf={'线应变及面应变单文件加卸载响应比计算，要求数据为整点值';...
            '所读文件缺数标记需一致';...
            ' ';...
            '拟合模型类型：';...
            '1：基本模型';...
            '2：考虑气压影响的模型';...
            '3：考虑水位影响的模型';...
            '4：同时考虑气压、水位影响的模型';...
            ' ';...
            '%应变单位换算因子SCF，实现观测值与理论值单位的一致';...
            '%换算后数据=原始观测数据*单位换算因子';...            
       };
