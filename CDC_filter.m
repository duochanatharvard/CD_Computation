% output = CDC_filter(input,mode,cutoff,dim)
% mode: 'h','l','b'
% cutoff: in unit of intervals
% dim

function output = CDC_filter(input,mode,cutoff,dim)


    if ~exist('dim','var') == 1,
        if size(a,1) > size(a,2),
            dim = 1;
        else
            dim = 2;
        end
    end
    
    Y = fft(input,[],dim);
    
    cutoff = round(size(input,dim) ./ cutoff);
    l = true(1,size(input,dim));
    
    
    if strcmp(mode,'l')
        % low pass cut off high
        l(1+cutoff+1:end-cutoff) = 0;
        
    elseif strcmp(mode,'h')
        % high pass cut off low
        l([1:1+cutoff end-cutoff+1:end]) = 0;
        
    elseif strcmp(mode,'b')
        
        % cutoff 1 is high, higher than this should be cut off
        % cutoff 2 is low, lower than this should be cut off
        
        % low pass, should use high
        l(1+cutoff(1)+1:end-cutoff(1)) = 0;
        
        % high pass, should use high
        l([1:1+cutoff(2) end-cutoff(2)+1:end]) = 0;
    end
    
    logic = zeros(size(input));
    logic = CDC_assign(logic,1,dim,l);
    Y(logic == 0) = 0;
    
    output = ifft(Y,[],dim);
    
end

