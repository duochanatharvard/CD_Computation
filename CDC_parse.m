% output = CDC_parse(input,delimeter,type)
%  
% CDC_parse parse the string and return numbers or texts
% when the delimiter is space(default), ignore nan is there are two
% consecutive spaces.
% Type is {"Numeric", "String"}
% 
% Last update: 2018-08-12


function output = CDC_parse(input,delimeter,type)

    if ~exist('delimeter','var'),
        delimeter = ' ';
    end

    if isempty(delimeter),
        delimeter = ' ';
    end

    if strcmp(delimeter,' '),
        do_ignore = 1;
    else
        do_ignore = 0;
    end

    if ~exist('type','var'),
        type = 'Numeric';
    end

    list = find(input == delimeter);
    if list(1) ~= 1,        list = [0 list];    end
    if list(end) ~= numel(input),    list = [list numel(input)+1];   end

    ct_eff = 0;
    clear('output')
    for ct = 1:numel(list)-1

        temp = input(list(ct)+1:list(ct+1)-1);

        if ~do_ignore || ~ isempty(temp),

            ct_eff = ct_eff + 1;

            if strcmp(type,'Numeric')

                temp = str2double(temp);

                if isempty(temp),
                    temp = NaN;
                end

                output(ct_eff) = temp;
            else
                output{ct_eff} = temp;
            end
        end
    end
end