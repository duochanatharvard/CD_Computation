% output = CDC_earth_gw(input,lon,lat,varname,mass)
%
% CDC_earth_gw compute the geostrophic wind
% Input are:
%  - input: should have the dimension of longitude x latitude
%  - lon and lat: longitude and latitude, in unit of degree
%  - varname: pres (default) or hgt height
%  - mass: air (default) or water
%
% Output is the geostrophic wind in unit of m/s
%  
% Last update: 2018-08-10

function [u,v] = CDC_earth_gw(input,lon,lat,varname,mass)
    
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
            rho = 1.29;
        case 'water',
            rho = 1023;
    end

    dx = CDC_earth_grad(input,1,lon,lat,1) / 10e5;
    dy = CDC_earth_grad(input,2,lon,lat,1) / 10e5;
    
    f = 2 .* sin(lat/180*pi) .* 7.29e-5;
    
    switch varname,   
        case 'pres',
            u = - dy ./ f ./ rho;
            v =   dx ./ f ./ rho;
        case 'hgt'
            u = - dy ./ f * 9.8;
            v =   dx ./ f * 9.8;
    end
    
end