% output = CDC_run(input,N,dim)

function output = CDC_run(input,N,dim)

    if ~exist('N','var'), N = 3; end
    if isempty(N),        N = 3; end

    if any(size(input) == 1)
        input = reshape(input,numel(input),1);
        dim   = 1;
    end

    if ~exist('dim','var'), error('dim not assigned!'); end
    if isempty(dim),        error('dim not assigned!'); end

    output = nan(size(input));

    NN = size(input,dim);
    if rem(N,2) == 0
        Nh = floor(N / 2);  % Half window size
        % error('N has to be an odd number');
    else
        Nh = (N - 1)/2;
    end

    for ct = 1:NN

        if rem(N, 2) == 0
            % Even case: center the window such that ct is at N/2
            list = (ct - Nh):(ct + Nh - 1);
            % list = (ct - Nh + 1):(ct + Nh);
        else
            % Odd case: center the window such that ct is at the center
            list = (ct - Nh):(ct + Nh);
        end

        list(list < 1)  = [];
        list(list > NN) = [];
        
        input_sub    = CDC_subset(input,dim,list);
        temp         = nanmean(input_sub,dim);
        output       = CDC_assign(output,temp,dim,ct); 
        
    end  
end