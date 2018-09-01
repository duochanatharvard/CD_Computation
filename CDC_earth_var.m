% output = CDC_earth_var(input,dim,num_in_cycle,N)
%
% CDC_earth_var returns the variance after removing the cycle of mean
% and trend. When N > 1, use boostrap to estimate uncertainties.
% 
% Last update: 2018-08-10

function [output,out_member,out_std] = CDC_earth_var(input,dim,num_in_cycle,N)

    if ~exist('N','var'), N = 1; end

    input_demean = CDC_demean(input,dim,num_in_cycle);

    input_detrend = CDC_detrend(input_demean,dim,num_in_cycle);

    if N == 1,
        output = squeeze(CDC_var(input_detrend,dim));
        out_member = [];
        out_std = [];
    else
        [output,~,out_member,out_std] = CDC_var_bt(input_detrend,N,dim);
        output = squeeze(output);
        out_std = squeeze(out_std);
    end
  
end