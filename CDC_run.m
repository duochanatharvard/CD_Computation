% output = CDC_run(input,N,dim)

function output = CDC_run(input,N,dim)

    output = nan(size(input));

    NN = size(input,dim);
    
    for ct = 1:NN

        if ismember(ct,((N+1)/2): (NN - (N-1)/2)),
            list = (ct-(N-1)/2):(ct+(N-1)/2);
            
        elseif ismember(ct,1:((N-1)/2)),
            list = 1:(ct+(N-1)/2);
            
        elseif ismember(ct,(NN - (N-1)/2):NN),
            list =  (ct - (N-1)/2):NN;
        end
        
        input_sub = CDC_subset(input,dim,list);
        temp = nanmean(input_sub,dim);
        output = CDC_assign(output,temp,dim,ct); 
        
    end  
end

    
    