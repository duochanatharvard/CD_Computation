% file_name = CDC_ls(dir_load,file_type,key_word)
%
% Example for getting a processed output:
%    dir_file  = CMIP6_IO(var_name,exp_name,'processed','mon');
%    file_list = CDC_ls(dir_file,'nc',{['_',model,'_'],['_',en,'_'],['_reso_',num2str(reso)]});

function file_name = CDC_ls(dir_load,file_type,keyword)
    
    dir = pwd;
    cd(dir_load);
    if ~strcmp(dir_load(end),'/')    dir_load(end+1) = '/';   end

    command = 'ls -1 ';
    
    if exist('file_type','var') && ~exist('keyword','var')
        command = [command,'*.',file_type];
    elseif exist('keyword','var') && isempty(file_type)
        if ~iscell(keyword)
            command = [command,'*',keyword,'*'];
        else
            for ct = 1:numel(keyword)
               command = [command,'*',keyword{ct}];
            end
        end 
    elseif exist('keyword','var') && ~isempty(file_type)
        if ~iscell(keyword)
            command = [command,'*',keyword,'*.',file_type];
        else
            for ct = 1:numel(keyword)
               command = [command,'*',keyword{ct}];
            end
            command = [command,'*.',file_type]; 
        end
    end
    
    [~,a] = system(command);
    file_list = [0 find(a == 10)];
    for i = 1:numel(file_list)-1
        file_name{i} = [dir_load,a(file_list(i)+1:file_list(i+1)-1)];
    end
    
    cd(dir)
end
