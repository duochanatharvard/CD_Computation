% output = CDC_earth_grad(input,dim,lon,lat,scale)
%
% CDC_earth_grad compute the gradient over longitude or latitude
% Input are:
%  - input: should have the dimension of longitude x latitude
%  - dim: on which dimension to compute the gradient
%  - lon and lat: longitude and latitude, in unit of degree
%  - scale: over which length is the gradient computed, unit: boxes
%
% Output is the gradient in unit of ~ 100km^-1.
%  
% Last update: 2018-08-09

function output = CDC_earth_grad(input,dim,lon,lat,scale)

    if ~exist('scale','var')
        scale = 1;
    end
    
    if min(size(lon)) == 1,
        [lat,lon] = meshgrid(lat,lon);
    end
    
    if ~ismember(dim,[1 2]),
        error('Not differenciating over longitude or latitude');
    end

    if dim == 1,

        input_ex = [input(end-scale+1:end,:,:,:,:,:,:); input;...
                                            input(1:scale,:,:,:,:,:,:)];
                                        
        lon_ex   = [lon(end-scale+1:end,:,:,:,:,:,:) - 360; lon;...
                                            lon(1:scale,:,:,:,:,:,:) + 360];
        
        diff_input = input_ex(1+scale*2:end,:,:,:,:,:,:) - ...
                                        input_ex(1:end-scale*2,:,:,:,:,:,:);
                                    
        diff_dist  = lon_ex(1+scale*2:end,:,:,:,:,:,:) - ...
                                        lon_ex(1:end-scale*2,:,:,:,:,:,:);
                                    
        rep_list = size(input);
        rep_list(1:2) = 1;
        diff_dist  = repmat(diff_dist .* cos(lat/180*pi),rep_list);
        
    elseif dim == 2,

        rep_list = ones(1,numel(size(input)));
        rep_list(2) = scale;
        
        input_ex = [repmat(input(:,1,:,:,:,:,:),rep_list), input,...
                                   repmat(input(:,end,:,:,:,:,:),rep_list)];  
                               
        lat_ex   = [repmat(lat(:,1,:,:,:,:,:),rep_list), lat,...
                                   repmat(lat(:,end,:,:,:,:,:),rep_list)];

        diff_input = input_ex(:,1+scale*2:end,:,:,:,:,:) -  ...
                                   input_ex(:,1:end-scale*2,:,:,:,:,:);
                               
        diff_dist  = lat_ex(:,1+scale*2:end,:,:,:,:,:) - ...
                                   lat_ex(:,1:end-scale*2,:,:,:,:,:);

        rep_list = size(input);
        rep_list(1:2) = 1;
        diff_dist  = repmat(diff_dist,rep_list);
    end
    
    output = diff_input ./ (diff_dist * 1.11);
end