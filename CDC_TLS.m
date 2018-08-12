% [output, Err, fitted] = CDC_TLS(field_y, field_x, dim, do_intercept)
%
% CDC_TLS fit the following models using
%                                      orthogonal linear regression method: 
%                              y = a + bx   
% or                           y =     bx
% 
% Return variables are:
%   output: {slope} + {intercept}
%   Err: Uncertainty in each direction
%   Fitted: Fitted value in each direction
%
% Last update: 2018-08-09

function [output, Err, fitted] = CDC_TLS(field_y, field_x, dim, do_intercept)


    dim_list = ones(1,numel(size(field_y)));
    dim_list(dim) = size(field_y,dim);
    dim_list_r = size(field_y);
    dim_list_r(dim) = 1;

    if min(size(field_x)) == 1,
        field_x = repmat(reshape(field_x,dim_list),dim_list_r);
    end

    l_nan = isnan(field_x) | isnan(field_y);
    field_x (l_nan) = nan;
    field_y (l_nan) = nan;
    
    if do_intercept == 1,

        field_anm_x = CDC_demean(field_x , dim);
        field_anm_y = CDC_demean(field_y , dim);

        cov_xy = CDC_nansum(field_anm_x .* field_anm_y,dim);
        var_xx = CDC_nansum(field_anm_x .* field_anm_x,dim);
        var_yy = CDC_nansum(field_anm_y .* field_anm_y,dim);

        B = - 0.5 * (var_yy - var_xx) ./ cov_xy;
        b1 = -B + (B.^2 + 1).^0.5;
        b2 = -B - (B.^2 + 1).^0.5;
        a1 = nanmean(field_y,dim) - nanmean(field_x,dim) .* b1;
        a2 = nanmean(field_y,dim) - nanmean(field_x,dim) .* b2;
        R  = CDC_corr(field_y,field_x,dim);

        Yhat1 = repmat(b1,dim_list) .* field_x + repmat(a1,dim_list);
        Yhat2 = repmat(b2,dim_list) .* field_x + repmat(a2,dim_list);
        Xhat1 = (field_y - repmat(a1,dim_list)) ./ repmat(b1,dim_list);
        Xhat2 = (field_y - repmat(a2,dim_list)) ./ repmat(b2,dim_list);

        Yhat = Yhat1; Yhat(repmat(R,dim_list) < 0) = Yhat2(repmat(R,dim_list) < 0);
        Xhat = Xhat1; Xhat(repmat(R,dim_list) < 0) = Xhat2(repmat(R,dim_list) < 0);  

        P{1} = b1;  P{1}(R < 0) = b2(R < 0);
        P{2} = a1;  P{2}(R < 0) = a2(R < 0);

        fitted.Fit_x = (field_x ./ repmat(P{1},dim_list) + field_y - repmat(P{2},dim_list)) ./ ...
                 repmat(P{1} + 1./P{1},dim_list);
        fitted.Fit_y = fitted.Fit_x .* repmat(P{1},dim_list) + repmat(P{2},dim_list);

    else
        
        A = CDC_nansum(field_x.^2,dim);
        B = -2 * CDC_nansum(field_x .* field_y,dim);
        C = CDC_nansum(field_y.^2,dim);
        D = (A - C) ./ B;
        
        R  = CDC_corr(field_y,field_x,dim);

        b1 = D + sqrt(D.^2 + 1);
        b2 = D - sqrt(D.^2 + 1);

        P{1} = b1;  P{1}(R < 0) = b2(R < 0);

        fitted.Fit_x = (field_x ./ repmat(P{1},dim_list) + field_y) ./ ...
                 repmat(P{1} + 1./P{1},dim_list);
        fitted.Fit_y = fitted.Fit_x .* repmat(P{1},dim_list);

    end
    
    Err.Std_X = CDC_std(fitted.Fit_x - field_x , dim);
    Err.Std_Y = CDC_std(fitted.Fit_y - field_y , dim);
    output = P;
        
    
    if 0,  % Visualization, turn off, only for debugging
        figure(2);clf;
        plot(field_x,field_y,'b*'); 
        hold on;
        plot(fitted.Fit_x,fitted.Fit_y,'bx');
        for i = 1:numel(field_x)
            plot([field_x(i) fitted.Fit_x(i)],[field_y(i) fitted.Fit_y(i)],'r--');
        end
        hold off
    end
end