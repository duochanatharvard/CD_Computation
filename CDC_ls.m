% file_name = CDC_ls(dir_load,file_type)
%
% CDC_ls returns all the files in a given directory, return values can be
%        directly used to loop over files
%  - dir_disp: direcotry to display, default is current directory
%  - file_type: optional
%  
% Last update: 2018-08-10

function file_name = CDC_ls(dir_disp,file_type)
    
    dir = pwd;
    
    if nargin < 1,
        dir_disp = dir;
    end
    
    cd(dir_disp);

    command = 'ls -1';
    if exist('file_type','var'),
        command = [command,' *.',file_type];
    end
    
    [~,a] = system(command);
    file_list = [0 find(a == 10)];
    for i = 1:numel(file_list)-1
        file_name{i} = a(file_list(i)+1:file_list(i+1)-1);
    end
    
    cd(dir)
end
    