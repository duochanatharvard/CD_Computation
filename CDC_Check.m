function CDC_Check

disp('clear;')
disp('addpath(''/n/home10/dchan/Matlab_Tool_Box/CD_Computation/'')')
disp('addpath(''/n/home10/dchan/Matlab_Tool_Box/CD_Figures/'')')
disp(' ') 
disp('files_now = CDF_filenames(pwd);')
disp(' ') 
disp('ct = 0;') 
disp('clear(''files_all'',''list'')')
disp('for yr = 1853:2014') 
disp('    for mon = 1:12') 
disp('        ct = ct + 1;') 
disp('        files_all{ct} = [''IMMA1_R3.0.0_'',num2str(yr),''-'',CDF_num2str(mon,2),''_All_pairs.mat''];')
disp('        list(ct,:) = [yr, mon];')
disp('    end') 
disp('end') 
disp(' ')
disp('l = ismember(files_all,files_now);')
disp('ll = find(~l);')
disp(' ')
disp('string =[];')
disp('for ct = 1:numel(ll)')
disp('    string = [string , '','' , num2str(ll(ct))];')
disp('end')
disp(' ')
disp('string')