function output = CDC_mon2sea(input)

    dim = find(size(input)==12);
    sz  = size(input);
    sz(dim) = 4;
    
    sea_list = [12 1 2; 3 4 5; 6 7 8; 9 10 11];
    output = nan(sz);
    for ct_sea = 1:4
        list = sea_list(ct_sea,:);
        temp = CDC_subset(input,dim,list);
        temp = nanmean(temp,dim);
        output = CDC_assign(output,temp,dim,ct_sea);
    end
    
end
    