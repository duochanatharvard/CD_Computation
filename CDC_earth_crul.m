% output = CDC_earth_crul(input,dim,lon,lat,scale,do_regress)
% This can be a little bit comfusing
% for U wind, dim should be 2 and for V wind, dim should be 1.

function output = CDC_earth_crul(input,dim,lon,lat,scale,do_regress)

    if dim == 1,
        % If the crul is on is on the longitude
        % A change in the radius has to be considered

        rep_list = size(input);
        rep_list(1:2) = 1;

        if min(size(lon)) == 1,
            [lat,lon] = meshgrid(lat,lon);
        end

        lat_mat = repmat(lat/180*pi,rep_list);
        input2  = input .* cos(lat_mat);
        
        output0 = CDC_earth_grad(input2,dim,lon,lat,scale,do_regress);
        
        output  = output0 ./ cos(lat_mat);        

    else
        % If the divergence is on the latitude, 
        % This is the same as computing the gradient
        % So you should just all the function of CDC_earth_grad
        
        output = - CDC_earth_grad(input,dim,lon,lat,scale,do_regress);
        
    end
end