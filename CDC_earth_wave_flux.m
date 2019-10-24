% [flux_final_x, flux_final_y] = CDC_earth_wave_flux(z_amn,z_clim,pressure)
% 
% Compute the 2D stationary wave flux on a certain pressure level
% following Eq. 38 in Takaya and Nakamura (2001)
% 
% Inputs:
% z_anm and z_clim are gropotential in unit of [m^2 s^-2]
% pressure is the height level and is in unit of [hPa]
% 
% Reference:
% Takaya, K., & Nakamura, H. (2001). A formulation of a phase-independent 
%     wave-activity flux for stationary and migratory quasigeostrophic eddies 
%     on a zonally varying basic flow. Journal of the Atmospheric Sciences, 58(6), 608-627.
% 
% Also see: http://www.atmos.rcast.u-tokyo.ac.jp/nishii/programs/tnf_xy_onelevel.f90

function [flux_final_x, flux_final_y] = CDC_earth_wave_flux(z_amn,z_clim,lon,lat,pressure)

    % *********************************************************************
    % Set parameters and parse inputs
    % *********************************************************************
    scale      = 1;
    scale_x    = 1;
    scale_y    = 1;
    do_regress = 0;
    pressure   = pressure/1000;
    key        = 15; % mask results within this latitude

    if min(size(lon)) == 1,
        [lat,lon] = meshgrid(lat,lon);
    end

    rep_list = size(z_amn);
    rep_list(1:2) = 1;

    % *********************************************************************
    % Compute the stream function
    % *********************************************************************
    f = 2 .* sin(lat/180*pi) .* 7.29e-5;
    f = repmat(f,rep_list);
    psi = z_amn ./f;

    % *********************************************************************
    % Compute geostrophic winds
    % *********************************************************************
    varname = 'hgt';
    mass    = 'air';
    [u_g,v_g] = CDC_earth_gw(z_amn/9.8,lon,lat,varname,mass,scale_x,scale_y,do_regress);
    [u_b,v_b] = CDC_earth_gw(z_clim/9.8,lon,lat,varname,mass,scale_x,scale_y,do_regress);

    % *********************************************************************
    % compute wave activity fluxes
    % *********************************************************************
    dim   = 1;
    du_dx = CDC_earth_grad_sphere(u_g,dim,lon,lat,scale,do_regress);  % XXX/m

    dim   = 1;
    dv_dx = CDC_earth_grad_sphere(v_g,dim,lon,lat,scale,do_regress);

    dim   = 2;
    du_dy = CDC_earth_grad_sphere(u_g,dim,lon,lat,scale,do_regress);

    % ---------------------------------------------------------------------
    % Compute individual terms
    % ---------------------------------------------------------------------
    term_x_U = v_g.^2 - psi .* dv_dx;
    term_x_V = psi .* du_dx - u_g .* v_g ;
    term_y_U = term_x_V;
    term_y_V = u_g.^2 + psi .* du_dy;

    % ---------------------------------------------------------------------
    % Merge with the mean-flow
    % ---------------------------------------------------------------------
    flux_x   = repmat(u_b,rep_list) .* term_x_U + repmat(v_b,rep_list) .* term_x_V;
    flux_y   = repmat(u_b,rep_list) .* term_y_U + repmat(v_b,rep_list) .* term_y_V;

    % ---------------------------------------------------------------------
    % Scale with pressure level and mean-flow speed
    % ---------------------------------------------------------------------
    wspeed   = sqrt(u_b.^2 + v_b.^2);
    flux_final_x = flux_x .* pressure .* cos(repmat(lat,rep_list)/180*pi) ./2  ./ repmat(wspeed,rep_list);
    flux_final_y = flux_y .* pressure .* cos(repmat(lat,rep_list)/180*pi) ./2  ./ repmat(wspeed,rep_list);

    flux_final_x(abs(repmat(lat,rep_list)) < key) = nan;
    flux_final_y(abs(repmat(lat,rep_list)) < key) = nan;

    flux_final_x(abs(repmat(u_b,rep_list)) < 1.0) = nan;
    flux_final_y(abs(repmat(u_b,rep_list)) < 1.0) = nan;
end