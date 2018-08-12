% output = CDC_prob(input)
% 
% CDC_prob converts log-likelihood pdf into normalized pdf
%
% Last update: 2018-08-09

function output = CDC_prob(input)

    L = exp(input);
    L_sum = CDC_nansum(L(:));
    input = input - log(L_sum);
    output = exp(input);
    
end