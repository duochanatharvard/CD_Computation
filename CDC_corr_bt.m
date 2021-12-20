% [output,l_effect, out_member, out_std] = CDC_corr_bt(field_1,field_2,dim,N,N_block)
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
% Last update: 2018-11-24

function [output,l_effect, out_member, out_std] = CDC_corr_bt(field_1,field_2,dim,N,N_block)

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
    elseif isempty(field_2),
        field_2 = field_1;
    end

    if ~exist('N_block','var'), N_block = 1; end

    % **************************************************
    % Compute sample variance
    % **************************************************
    [output,l_effect] = CDC_corr(field_1,field_2,dim);
    
    % **************************************************
    % Bootstrap for the order 
    % **************************************************
    rng(0);
    [~,boot_sample] = bootstrp(N, @(x) [mean(x)], [1:size(field_1,dim)/N_block]);
    
    % **************************************************
    % Re-sample and estimate variances
    % **************************************************
    out_member = nan([size(output) N]);
    dim_2 = numel(size(out_member));
    for ct = 1:N

        if rem(ct,10) == 0,  disp(num2str(ct)); end
        
        order = repmat(boot_sample(:,ct)',N_block,1);
        order = order(:);
        field_11 = CDC_subset(field_1,dim,order);
        field_22 = CDC_subset(field_2,dim,order);

        temp = CDC_corr(field_11,field_22,dim);
        out_member = CDC_assign(out_member,temp,dim_2,ct);
    end
 
    % **************************************************
    % Correct for underestimation
    % ************************************************** 
    % TODO - 20190313
    out_member = out_member;
    size(field_1,dim);
 
    % **************************************************
    % Correct for underestimation
    % **************************************************    
    out_std = CDC_std(out_member,dim_2);
    
    out_member = squeeze(out_member);
    
end