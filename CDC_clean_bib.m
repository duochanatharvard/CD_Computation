%  CDC_clean_bib(file1,file2)

function  CDC_clean_bib(file1,file2)

%%
    file1 = '/Users/duochan/Desktop/bib1.bib';
    file2 = '/Users/duochan/Desktop/bib1.bib';
    
    % Load the fist bib file ----------------------------------------------
    [item,item_key,title_key]= process_bib(file1);
    
    % If other files exist, combine them ----------------------------------
    if exist('file2','var')
        if ~isempty(file2)
            [item2,item2_key,title2_key]= process_bib(file2);
            
            item      = [item      item2];
            item_key  = [item_key  item2_key];
            title_key = [title_key title2_key];
        end
    end

    % Sort items ----------------------------------------------------------
    [~,I] = sort(item_key);
    item = item(I);
    title_key = title_key(I);

    % Remove duplicates ---------------------------------------------------
    [~,I] = unique(title_key);
    item = item(I);
    
    s = [];
    for ct = 1:numel(item)
        s = [s item{ct}];
    end
    clc;disp(s)
    
end

function [item,item_key,title_key]= process_bib(file)

    text1 = fileread(file);
    
    list = [find(text1 == '@') numel(text1)];
    for ct = 1:numel(list)-1
        if ct ~= numel(list)-1
            item{ct} = text1(list(ct):list(ct+1)-1);
        else
            item{ct} = [text1(list(ct):list(ct+1)),10];
        end
    end
%
    % Clean up items in that file #########################################
    for ct = 1:numel(item)
        
        temp = item{ct};      
        temp(find(temp=='}',1,'last')+1:end) = [];
        if temp(end-2) ~= 10 
            temp = [temp(1:end-1), 10, temp(end)];
        end
        temp(temp == 9) = [];
        temp(end+1:end+2) = 10;  
        clear('list')
        list = find(temp == 10);
        
        % Loop over lines in that item ************************************
        clear('ct_l','author_first','title_first','year')
        for ct_l = 1:numel(list)-2
            list = find(temp == 10);
            tem = temp(list(ct_l)+1:list(ct_l+1));
            
            % Fix indent ==================================================
            tem = ['    ',tem(find(tem~=32,1):end)];
            
            % Fix indent if necessary =====================================
            if contains(tem,['='])
                id = find(tem == '=',1);
                tem(find(tem(1:id-1)~=32,1,'last')+1 : id-1) = [];
            end

            % Fix indent if necessary =====================================
            if contains(tem,'=')
                id = find(tem == '=',1);
                tem(id+ [1:find(tem(id+1:end)~=32,1)-1]) = [];
            end

            % Get property name ===========================================
            prop = lower(tem(find(tem~=32,1):find(tem=='=')-1));
            tem(find(tem~=32,1):find(tem=='=')-1) = prop;

            % Fix properties if necessary =================================
            if strcmp(prop,'title')
                
                % Title should be in the original form --------------------
                if ~contains(tem,'title={{')
                    id = strfind(tem,'title={');
                    tem = [tem(1:id-1),'title={{',tem(id+7:end)];
                    id2 = strfind(tem,'},');
                    id2 = id2(find(id2>id,1));
                    tem = [tem(1:id2-1),'}},',tem(id2+2:end)];
                end
                
                % Remove existing {} that I added by hand -----------------
                if contains(tem,' {')
                    id = strfind(tem,' {');
                    tem(id+1) = [];
                end

                if contains(tem,'} ')
                    id = strfind(tem,'} ');
                    tem(id) = [];
                end
                
                % Get the first work of the title -------------------------
                id = strfind(tem,'title={{');
                title_text  = tem(id+8:end);
                title_first = lower(title_text(1:find(title_text==' ',1)-1));
                if ismember(title_first,{'A','a','On','on','Of','of',...
                                      'The','the','Why','why','What','what',...
                                      'is','Is','are','Are','An','an','In','in'})
                    l           = find(title_text==' ');
                    title_first = lower(title_text(l(1)+1:l(2)-1));
                end
                title_first(title_first == ',') = [];
                title_first(title_first == '.') = [];
                title_first(title_first == ' ') = [];
                                
            elseif strcmp(prop,'journal')
               tem = caseconvert_title(tem); 
               
            % Get the family name of the first author =====================
            elseif strcmp(prop,'author')
                id = strfind(tem,'author={');
                author_text  = tem(id+8:end);
                author_first = lower(author_text(1:find(ismember(author_text,[' ,-']),1)-1));
                author_first(author_first == '{') = [];
                author_first(author_first == '}') = [];

            % Get year ====================================================
            elseif strcmp(prop,'year')
                id    = strfind(tem,'year={');
                year  = tem(id+[6:9]);
            end
            
            temp = [temp(1:list(ct_l)) tem temp(list(ct_l+1)+1:end)];
        end

        % Replace citation key with a standard one ************************
        item_key{ct}  = [author_first,year,title_first];
        item_key{ct}(item_key{ct} == ' ') = [];
        title_key{ct} = [item_key{ct},' ',title_text];
        tem = temp(1:list(1));
        tem = [tem(1:find(tem=='{',1)),item_key{ct},tem(find(tem==',',1,'last'):end)];
        temp = [tem temp(list(1)+1:end)];
        
        temp(find(temp=='}',1,'last')+1:end) = [];
        temp(end+1:end+2) = 10;
        item{ct} = temp;
    end
    
    % Sort items ##########################################################
    [item_key,I] = sort(item_key);
    item = item(I);
    title_key = title_key(I);

end

function  data = caseconvert_title(data)

    data(1)=upper(data(1));
    data_num = numel(data);
    
    for count=2:data_num
        
        if isstrprop(data(count-1),'alphanum')==1
            data(count)=lower(data(count));
        else
            data(count)=upper(data(count));
        end
        
        if (count>=3 && count<=data_num-1 && ...
                data(count-2)~=' ' && data(count-1)=='''' && ...
                data(count+1)==' ') ...
                || (count>=3 && ...
                data(count-2)~=' ' && data(count-1)=='''')
            data(count)=lower(data(count));
        end
    end
end