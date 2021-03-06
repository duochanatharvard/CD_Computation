% output = CDC_earth_gw(input,lon,lat,varname,mass,scale_x,scale_y,do_regress)
%
% CDC_earth_gw compute the geostrophic wind
% Input are:
%  - input: should have the dimension of longitude x latitude
%  - lon and lat: longitude and latitude, in unit of degree
%  - varname: pres (Pa: default) or hgt height (m)
%  - mass: air (default) or water
%
% Output is the geostrophic wind in unit of m/s
%  
% Last update: 2018-09-24

function [u,v] = CDC_earth_gw(input,lon,lat,varname,mass,scale_x,scale_y,do_regress)
    
    if min(size(lon)) == 1,
        [lat,lon] = meshgrid(lat,lon);
    end
    
    if ~exist('varname','var'),
        varname = 'pres';
    end
    
    if ~exist('mass','var'),
        mass = 'air';
    end
    
    switch mass,
        case 'air',
            rho = 1.22;
        case 'water',
            rho = 1027;
    end

    dx = CDC_earth_grad(input,1,lon,lat,scale_x,do_regress) / 1e5;
    dy = CDC_earth_grad(input,2,lon,lat,scale_y,do_regress) / 1e5;
    
    f = 2 .* sin(lat/180*pi) .* 7.29e-5;
    rep_list = size(input);
    rep_list(1:2) = 1;
    f = repmat(f,rep_list);
    
    switch varname,   
        case 'pres',
            u = - dy ./ f ./ rho;
            v =   dx ./ f ./ rho;
        case 'hgt'
            u = - dy ./ f * 9.807;
            v =   dx ./ f * 9.807;
    end
    
end