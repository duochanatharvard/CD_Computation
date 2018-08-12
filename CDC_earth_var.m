% output = CDC_earth_var(input,dim,num_in_cycle)
%
% CDC_earth_var returns the variance after 
%                                     removing the cycle of mean and trend
% Last update: 2018-08-10

function output = CDC_earth_var(input,dim,num_in_cycle)

    input_demean = CDC_demean(input,dim,num_in_cycle);

    input_detrend = CDC_detrend(input_demean,dim,num_in_cycle);

    output = squeeze(CDC_var(input_detrend,dim));
    
end