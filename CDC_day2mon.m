function output = CDC_day2mon(input)

    dim = find(size(input)==365);
    sz  = size(input);
    sz(dim) = 12;
    
    days = [31 28 31 30 31 30 31 31 30 31 30 31];
    day_id = [0 cumsum(days)];
    
    output = nan(sz);
    for ct_mon = 1:12
        list = (day_id(ct_mon)+1):1:day_id(ct_mon+1);
        temp = CDC_subset(input,dim,list);
        temp = nanmean(temp,dim);
        output = CDC_assign(output,temp,dim,ct_mon);
    end
    
end
    