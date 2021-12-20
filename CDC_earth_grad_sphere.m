% output = CDC_earth_grad_sphere(input,dim,lon,lat,scale,do_regress)
% This function is used when computing divergence and crul of flows
% For gradient of scalers, please use [CDC_earth_grad]
% 
% Input are:
%  - input: should have the dimension of longitude x latitude
%  - dim: on which dimension to compute the gradient
%  - lon and lat: longitude and latitude, in unit of degree
%  - scale: over which length is the gradient computed, unit: boxes
%  - do_regress: whether use regression to find grad.      default: 0
% 
% The output unit is XXX/m.

function output = CDC_earth_grad_sphere(input,dim,lon,lat,scale,do_regress)

    if dim == 1,
        % If the crul is on the longitude
        % This is the same as computing the gradient
        % So you should just all the function of CDC_earth_grad

        output = CDC_earth_grad(input,dim,lon,lat,scale,do_regress) /1e5;

    else
        % If the crul is on the latitude, 
        % A change in the radius has to be considered
        
        rep_list = size(input);
        rep_list(1:2) = 1;

        if min(size(lon)) == 1,
            [lat,lon] = meshgrid(lat,lon);
        end

        lat_mat = repmat(lat/180*pi,rep_list);
        input2  = input .* cos(lat_mat);
        
        output0 = CDC_earth_grad(input2,dim,lon,lat,scale,do_regress);
        
        output  = output0 ./ cos(lat_mat) /1e5;
        
    end
end