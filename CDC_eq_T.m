% eq_T = CDC_eq_T(T,p)
% Derivative of saturation specific humidity (kg/kg)
% input: temperature (C or K) and pressure (Pa or hPa)
% output: Derivative of saturation specific humidity (kg/kg)

function eq_T = CDC_eq_T(T,p)

    if nanmean(T(:)) < 200,  T = T + 273.15; end
    if nanmean(p(:)) > 80000, p = p / 100;   end

    A    = p - 0.378 * CDC_es(T);
    B    = 0.622 ./ A + CDC_eq(T,p) ./ A * 0.378;
    eq_T = B .* CDC_es_T(T);
    
end