% [output, out_member, out_std] = CDC_mean_bt(field_1,N,dim,N_block)
% 
% output variables are:
% - output:     mean
% - out_member: bootstrap member of mean
% - out_std:    std of bootstrapped mean
% 
% CDC_mean_bt computes the mean in certain dimension
% and perform bootstrap to estimate the uncertainty of mean.
% 
% 
% Last update: 2018-11-24

function [output, out_member, out_std] = CDC_mean_bt(field_1,N,dim,N_block)

    % **************************************************
    % Parsing the data
    % **************************************************
    if  nargin < 3  && size(field_1,1) ~= 1,
        dim = 1;
    elseif nargin < 3 && size(field_1,1) == 1,
        dim = 2;    
    end
    
    if ~exist('N_block','var'), N_block = 1; end

    % **************************************************
    % Compute sample mean
    % **************************************************
    output = nanmean(field_1,dim);
    
    % **************************************************
    % Bootstrap for the order 
    % **************************************************
    rng(0);
    [~,boot_sample] = bootstrp(N, @(x) [mean(x)], [1:size(field_1,dim)/N_block]);
    
    % **************************************************
    % Re-sample and estimate mean
    % **************************************************
    out_member = nan([size(output) N]);
    dim_2 = numel(size(out_member));
    for ct = 1:N
        
        if rem(ct,10) == 0,  disp(num2str(ct)); end
                
        order = repmat(boot_sample(:,ct)',N_block,1);
        order = order(:);
        field_11 = CDC_subset(field_1,dim,order);

        temp = nanmean(field_11,dim);
        out_member = CDC_assign(out_member,temp,dim_2,ct);
    end
 
    % **************************************************
    % Correct for underestimation: not for mean
    % ************************************************** 
    % med = quantile(out_member,0.5,dim_2);
    % rep = size(out_member);
    % rep(1:dim_2-1) = 1;
    % out_member = out_member + repmat(output - med,rep);
 
    % **************************************************
    % Correct for underestimation
    % **************************************************    
    out_std = CDC_std(out_member,dim_2);
    
    out_member = squeeze(out_member);
    
end