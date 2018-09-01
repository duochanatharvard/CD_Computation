% [output,l_effect, out_member, out_std] = CDC_var_bt(field_1,N,dim,field_2)
% 
% output variables are:
% - output:     variance
% - l_effect:   effective sample size
% - out_member: bootstrap member of variance
% - out_std:    std of bootstrapped variance
% 
% CDC_var_bt computes the variance or the covariance in certain dimension
% and perform bootstrap to estimate the uncertainty of variance.
% Bootstrapped data are corrected to account for the underestimation due to
% re-sampling.
% 
% Last update: 2018-08-23

function [output,l_effect, out_member, out_std] = CDC_var_bt(field_1,N,dim,field_2)

    % **************************************************
    % Parsing the data
    % **************************************************
    if  nargin < 3  && size(field_1,1) ~= 1,
        dim = 1;
    elseif nargin < 3 && size(field_1,1) == 1,
        dim = 2;    
    end
    
    if nargin < 4,
        field_2 = field_1;
    end

    % **************************************************
    % Compute sample variance
    % **************************************************
    [output,l_effect] = CDC_var(field_1,dim,field_2);
    
    % **************************************************
    % Bootstrap for the order 
    % **************************************************
    rng(0);
    [~,boot_sample] = bootstrp(N, @(x) [mean(x)], [1:size(field_1,dim)]);
    
    % **************************************************
    % Re-sample and estimate variances
    % **************************************************
    out_member = nan([size(output) N]);
    dim_2 = numel(size(out_member));
    for ct = 1:N

        if rem(ct,10) == 0,  disp(num2str(ct)); end
        
        field_11 = CDC_subset(field_1,dim,boot_sample(:,ct));
        field_22 = CDC_subset(field_2,dim,boot_sample(:,ct));

        temp = CDC_var(field_11,dim,field_22);
        out_member = CDC_assign(out_member,temp,dim_2,ct);
    end
 
    % **************************************************
    % Correct for underestimation
    % ************************************************** 
    med = quantile(out_member,0.5,dim_2);
    rep = size(out_member);
    rep(1:dim_2-1) = 1;
    out_member = out_member + repmat(output - med,rep);
 
    % **************************************************
    % Correct for underestimation
    % **************************************************    
    out_std = CDC_std(out_member,dim_2);
    
    out_member = squeeze(out_member);
    
end