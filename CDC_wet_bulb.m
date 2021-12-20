% wet = CDC_wet_bulb(T,q,p)
% Compute dew point temperature from specific humidity
% input: temperature (C or K), specific humidity (kg/kg) and p (hPa or Pa)
% output: wet bulb temperature (C)

function wet = CDC_wet_bulb(T,q,p)

    if nanmean(T(:)) < 200,  T = T + 273.15; end
    if nanmean(p(:)) > 80000, p = p / 100;   end
    if nanmean(q(:)) > 0.5,   q = q / 1000;  end

    L      = 2.5008e6;   % J / kg
    cp     = 1005;       % J/kg K

    q_s   = CDC_eq(T,p);
    err   = q_s - q;
    while max(err(:)) > 1e-9
        beta    = - cp / L;
        alpha   = CDC_eq_T(T,p); 
        delta_T = err ./ (alpha - beta) / 2;
        T       = T - delta_T;
        q       = q - beta * delta_T;
        q_s     = CDC_eq(T,p);
        err     = q_s - q;
    end
    
    wet = T - 273.15;
end

