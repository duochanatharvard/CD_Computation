%
%
% CDC_CAPE computes the convective available potential energy by:
% 1. compute the partile temperature along lifting
% 2. compute CAPE by intergration
%
% The function handles matrixrized computations

function [CAPE,CIN,Tp,Te] = CDC_CAPE(p0, T0, q0, p, Te , Qe)

    % for debug
    if 0,
        cd('/Volumes/My Passport Pro/SAM_RCE_WND')
        file_load = 'Space_explore_stats_MSE.mat';
        load(file_load,'TABS_save','QV_save','p','z','QP_save');
        % p  = ncread(file_load,'p');
        % z  = ncread(file_load,'z');
        % QV = ncread(file_load,'QV');
        % T  = ncread(file_load,'TABS');
        % QP  = ncread(file_load,'QP');
        spd_id = 1;
        hgt_id = 2;
        dmn_id = 6;
        QP = QP_save(:,:,spd_id,hgt_id,dmn_id);
        T  = TABS_save(:,:,spd_id,hgt_id,dmn_id);
        QV = QV_save(:,:,spd_id,hgt_id,dmn_id);
        T0 = T(1,:);
        p0 = p(1);
        q0 = QV(1,:);
        Te = T;
        Qe = QV;
        clear('T','QV','TABS_save','QP_save','QV_save')
    end
    
    if nanmean(Qe(1,:)) > 1;  Qe = Qe / 1000; end
    if nanmean(q0(1,:)) > 1;  q0 = q0 / 1000; end    

    % ***********************************************
    % Parsing inputs
    % ***********************************************
    if 1, % Leave this before computing cape
        if numel(T0) == 1;
            T0 = repmat(T0,1,size(Te,2));
        end

        if numel(p0) == 1;
            p0 = repmat(p0,1,size(Te,2));
        end
    end

    % ***********************************************
    % Setting parameters
    % ***********************************************
    p_ref = 1000;   % mb
    R  = 287;       % J / K / kg
    Cp = 1004;      % J / K / kg
    L  = 2.5104e6;  % J / kg

    % ***********************************************
    % pre-define some functions
    % ***********************************************
    % Saturation vapor pressure
    f_es_t = @(t) 6.112 .* exp(17.67 .* (t-273.15)./(t-29.65));

    % Potential temperature
    f_theta_t = @(t,p) t .* (p ./ p_ref).^(-R/Cp);

    % temperature from potential temperature
    f_t_theta = @(theta,p) theta .* (p ./ p_ref).^(R/Cp);

    % saturate specific humidity from satuation vapor pressure
    f_qs_es = @(es,p) es * 0.622 ./ (p - 0.378 * es);

    % saturate equavlant potential tempeartuere from temperature
    f_thetaes_t = @(t,p) f_theta_t(t,p) .* ...
                        exp(L .* f_qs_es (f_es_t(t), p) ./ Cp ./ t);

    % ***********************************************
    % Find Lifting Condensation Level
    % ***********************************************
    Theta_0 = f_theta_t(T0,p0);
    T_dry = f_t_theta(repmat(Theta_0,size(p,1),1) , repmat(p,1,size(T0,2)));

    p_x = repmat(p_ref,1,size(T0,2));
    err = 1;
    while err > 1e-4;
        q_x = f_qs_es( f_es_t( f_t_theta(Theta_0, p_x)) ,p_x);
        p_x = p_x - (q_x - q0) * 10;
        err =  max(abs(q_x - q0));
    end
    p_lcl = p_x;

    % ***********************************************
    % Find equavlant potential tempeartuere at LCL
    % ***********************************************
    T_lcl = f_t_theta(Theta_0, p_lcl);
    Theta_e_lcl = f_thetaes_t(T_lcl , p_lcl);

    % ***********************************************
    % Solve for Temperature at all height using
    % that Theta_e_0 is conservative
    % ***********************************************
    Theta_e_0 = repmat(Theta_e_lcl, numel(p), 1);
    T_x = repmat(T_lcl, numel(p), 1);
    err = 1;
    while err > 5e-3;
        Theta_e_x = f_thetaes_t(T_x , repmat(p,1,size(T0,2)));
        div = Theta_e_x - Theta_e_0;
        T_x = T_x - min(abs(div) * 0.1 , 10) .* sign(div);
        err =  max(max(abs(Theta_e_x - Theta_e_0)));
    end

    T_moist = T_x;

    % ***********************************************
    % Compute qn 
    % ***********************************************
    ES = f_es_t(T_moist);
    Q_moist = f_qs_es(ES,repmat(p,1,size(T0,2)));
    Q_dry   = repmat(q0,96,1);

    % ***********************************************
    % Combine T_dry and T_moist to obtain a
    % temperature profile of parcle: Tp
    % ***********************************************
    l_dry = repmat(p,1,size(T0,2)) > repmat(p_lcl,size(p,1),1);
    Tp = T_moist;
    Tp(l_dry) = T_dry(l_dry);

    Qp = Q_moist;
    Qp(l_dry) = Q_dry(l_dry);
    
    Tp = Tp .* (1 + 0.61 .* Qp);
    Te = Te .* (1 + 0.61 .* Qe);

    %% ***********************************************
    % Combine T_dry and T_moist to obtain a
    % temperature profile of parcle: Tp
    % ***********************************************
    l = Tp > Te;
    dif = Tp - Te;
    dif(l == 0) = 0;
    lnp = log(p);
    
    dif_m = (dif(1:end-1,:) + dif(2:end,:))/2;
    d_lnp = lnp(1:end-1) - lnp(2:end);
    
    CAPE  = cumsum(dif_m .* repmat(d_lnp,1,size(dif_m,2)),1) * R;

    l = Tp < Te;
    l(50:end,:) = 0;
    dif = Tp - Te;
    dif(l == 0) = 0;
    lnp = log(p);
    
    dif_m = (dif(1:end-1,:) + dif(2:end,:))/2;
    d_lnp = lnp(1:end-1) - lnp(2:end);
    
    CIN  = cumsum(dif_m .* repmat(d_lnp,1,size(dif_m,2)),1) * R;
     
    
end


