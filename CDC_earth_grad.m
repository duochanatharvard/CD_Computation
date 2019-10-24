% output = CDC_earth_grad(input,dim,lon,lat,scale,do_regress)
%
% CDC_earth_grad compute the gradient over longitude or latitude
% Input are:
%  - input: should have the dimension of longitude x latitude
%  - dim: on which dimension to compute the gradient
%  - lon and lat: longitude and latitude, in unit of degree
%  - scale: over which length is the gradient computed, unit: boxes
%  - do_regress: whether use regression to find grad.      default: 0
%
% Output is the gradient in unit of ~ 100km^-1.
%  
% Last update: 2018-08-09

function output = CDC_earth_grad(input,dim,lon,lat,scale,do_regress)

    % ************************************
    % Parse input 
    % ************************************
    if ~exist('scale','var')
        scale = 1;
    end

    if ~exist('do_regress','var')
        do_regress = 0;
    end
    
    if min(size(lon)) == 1,
        [lat,lon] = meshgrid(lat,lon);
    end
    
    if ~ismember(dim,[1 2]),
        error('Not differenciating over longitude or latitude');
    end

    % ************************************
    % Compute gradient 
    % ************************************
    N = size(input,dim);
    N_dim = numel(size(input));
    rep_list = size(input);
    rep_list(1:2) = 1;
    
    if do_regress == 0,  % This only uses two points
        
        if dim == 1,
                
            l_1 = [N-scale+1:N 1:N-scale];
            l_2 = [1+scale:N 1:scale];
            diff_input = CDC_subset(input,dim,l_2) - CDC_subset(input,dim,l_1);
            diff_dist  = CDC_subset(lon,dim,l_2) - CDC_subset(lon,dim,l_1);
            diff_dist  = rem(diff_dist+180*5,360)-180;
            diff_dist  = repmat(diff_dist .* cos(lat/180*pi),rep_list);

        elseif dim == 2,

            l_1 = [ones(1,scale)*1 1:N-scale];
            l_2 = [1+scale:N ones(1,scale)*N];
            diff_input = CDC_subset(input,dim,l_2) - CDC_subset(input,dim,l_1);
            diff_dist  = CDC_subset(lat,dim,l_2) - CDC_subset(lat,dim,l_1);
            diff_dist  = repmat(diff_dist,rep_list);
        end
        
        output = diff_input ./ (diff_dist * 1.117);
        
    else % Use regression to find the gradient
        
        input_temp = nan([size(input),scale*2+1]);
        postn_temp = nan([size(input),scale*2+1]);
        
        if dim == 1,
            postn = repmat(lon,rep_list);
        else
            postn = repmat(lat,rep_list);
        end
        
        ct = 0;
        for s_cur = 0:scale

            ct = ct + 1;
            if dim == 1,
                l = [1+s_cur:N 1:s_cur];
            else
                l = [ones(1,s_cur)*1 1:N-s_cur];
            end
            temp = CDC_subset(input,dim,l);
            input_temp = CDC_assign(input_temp,temp,N_dim+1,ct);
            temp = CDC_subset(postn,dim,l);
            postn_temp = CDC_assign(postn_temp,temp,N_dim+1,ct);
            
            if s_cur ~= 0,
                ct = ct + 1;
                if dim == 1,
                    l = [N-s_cur+1:N 1:N-s_cur];
                else
                    l = [1+s_cur:N ones(1,s_cur)*N];
                end
                temp = CDC_subset(input,dim,l);
                input_temp = CDC_assign(input_temp,temp,N_dim+1,ct);
                temp = CDC_subset(postn,dim,l);
                postn_temp = CDC_assign(postn_temp,temp,N_dim+1,ct);
            end
        end
        
        if dim == 1,
            temp = postn_temp(1:scale,:,:,:,:,:);
            temp(temp > 300) = temp(temp > 300) - 360;
            postn_temp(1:scale,:,:,:,:,:) = temp;

            temp = postn_temp(end-scale+1:end,:,:,:,:,:);
            temp(temp < 60) = temp(temp < 60) + 360;
            postn_temp(end-scale+1:end,:,:,:,:,:) = temp;        
        end
        
        output = CDC_trend(input_temp,postn_temp,N_dim+1);
        output = output{1};
        if dim == 1,
            output = output ./ 1.117 ./ repmat(cos(lat/180*pi),rep_list);
        else
            output = output ./ 1.117;
        end
    end    
end