% [output,model_out] = CDC_cmip5_subset(input,models,dim,option)
%
% CDC_cmip5_subset data acoording to different criteria
% Input list:
%  - models: model_name ensemble
%  - option: {'All', 'Mean', 'First'}
%           * All: do nothing
%           * Mean: Take mean of individual models
%           * First: Take the first ensemble member of that model
% 
% Last update: 2018-08-10

function [output,model_out] = CDC_cmip5_subset(input,models,dim,option)

    if ~exist('option','var'),
        option = 'All';
    end

    if ~exist('dim','var'),
        dim = numel(size(input));
    end
    
    switch option,
        case 'All',
            output = input;
            model_out = models;
            
        case 'Mean',
            
            [model_out,~,J] = unique(models(:,1));
            
            list = size(input);
            list(dim) = size(model_out,1);
            output = nan(list);
            for md = 1:size(model_out,1)
                
                logic = J == md;
                temp = nanmean(CDC_subset(input,dim,logic),dim);
                output = CDC_assign(output,temp,dim,md); 
            end
            
        case 'First',
            
            logic = ismember(models(:,2),'r1i1p1');
            output = CDC_subset(input,dim,logic);
            model_out = models(logic,:);            
    end
end